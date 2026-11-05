import 'dart:math' as math;
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import '../models/chord_model.dart';

/// Pure Dart audio synthesizer generating in-memory PCM WAV audio.
/// Plays pure sine/harmonic tones cross-platform without platform channels, C++ bindings,
/// or external binary dependencies.
class SimpleAudioSynthesizer {
  SimpleAudioSynthesizer._();

  /// Standard sample rate in Hz.
  static const int sampleRate = 22050;

  /// Base A4 frequency standard (440 Hz).
  static const double a4Frequency = 440.0;

  /// Maps a note name (e.g., `'C'`, `'G#'`, `'Bb'`) and an octave (e.g. 4)
  /// to its exact equal-temperament frequency in Hz.
  static double noteToFrequency(String note, {int octave = 4}) {
    final semitone = ChordTransposer.noteToSemitone(note);
    if (semitone == -1) return a4Frequency;

    // C4 is semitone 0 in octave 4. A4 is semitone 9 in octave 4.
    // Difference from A4 (semitone 9 in octave 4):
    final midiNumber = (octave + 1) * 12 + semitone;
    const a4Midi = 69; // A4
    return a4Frequency * math.pow(2.0, (midiNumber - a4Midi) / 12.0);
  }

  /// Synthesizes a multi-note chord sound (or single note) into an uncompressed
  /// 16-bit Mono PCM WAV byte buffer with an exponential decay envelope.
  static Uint8List synthesizeWav({
    required List<double> frequencies,
    double durationSeconds = 0.8,
    double volume = 0.7,
  }) {
    final totalSamples = (sampleRate * durationSeconds).toInt();
    final byteCount = totalSamples * 2; // 16-bit PCM = 2 bytes per sample
    final wavBuffer = Uint8List(44 + byteCount);
    final bdata = ByteData.view(wavBuffer.buffer);

    // 1. WAV Header
    // "RIFF"
    wavBuffer.setRange(0, 4, [0x52, 0x49, 0x46, 0x46]);
    bdata.setUint32(4, 36 + byteCount, Endian.little);
    // "WAVE"
    wavBuffer.setRange(8, 12, [0x57, 0x41, 0x56, 0x45]);
    // "fmt "
    wavBuffer.setRange(12, 16, [0x66, 0x6D, 0x74, 0x20]);
    bdata.setUint32(16, 16, Endian.little); // Subchunk1Size (16 for PCM)
    bdata.setUint16(20, 1, Endian.little); // AudioFormat (1 for PCM)
    bdata.setUint16(22, 1, Endian.little); // NumChannels (1 = Mono)
    bdata.setUint32(24, sampleRate, Endian.little); // SampleRate
    bdata.setUint32(28, sampleRate * 2, Endian.little); // ByteRate (SampleRate * 1 * 2)
    bdata.setUint16(32, 2, Endian.little); // BlockAlign (1 * 2)
    bdata.setUint16(34, 16, Endian.little); // BitsPerSample
    // "data"
    wavBuffer.setRange(36, 40, [0x64, 0x61, 0x74, 0x61]);
    bdata.setUint32(40, byteCount, Endian.little);

    if (frequencies.isEmpty) {
      return wavBuffer;
    }

    // 2. Synthesize audio samples with soft harmonic overtone & ADSR decay
    final freqCount = frequencies.length;
    final gainPerFreq = volume / freqCount;

    for (int i = 0; i < totalSamples; i++) {
      final t = i / sampleRate;
      // Exponential decay envelope
      final envelope = math.exp(-3.5 * (t / durationSeconds));

      double sampleSum = 0.0;
      for (final freq in frequencies) {
        // Fundamental sine wave + subtle 2nd harmonic for warmer timbre
        final wave = 0.85 * math.sin(2.0 * math.pi * freq * t) +
            0.15 * math.sin(4.0 * math.pi * freq * t);
        sampleSum += wave * gainPerFreq;
      }

      final sampleValue = (sampleSum * envelope * 32767.0).clamp(-32768.0, 32767.0).toInt();
      bdata.setInt16(44 + i * 2, sampleValue, Endian.little);
    }

    return wavBuffer;
  }

  /// Synthesizes chord notes (e.g., `['C', 'E', 'G']`) into WAV bytes.
  static Uint8List synthesizeChordNotes(
    List<String> notes, {
    int baseOctave = 4,
    double durationSeconds = 1.0,
  }) {
    if (notes.isEmpty) return Uint8List(0);
    final frequencies = <double>[];
    int currentOctave = baseOctave;
    int previousSemitone = -1;

    for (final note in notes) {
      final semi = ChordTransposer.noteToSemitone(note);
      if (previousSemitone != -1 && semi <= previousSemitone) {
        currentOctave++;
      }
      frequencies.add(noteToFrequency(note, octave: currentOctave));
      previousSemitone = semi;
    }

    return synthesizeWav(
      frequencies: frequencies,
      durationSeconds: durationSeconds,
    );
  }
}
