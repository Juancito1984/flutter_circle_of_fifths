import 'package:material_ui/material_ui.dart';
import '../models/chord_model.dart';

/// Interactive vector Piano Keybed widget (1 or 2 octaves) that highlights
/// the notes of a selected chord or scale.
class PianoKeybedWidget extends StatelessWidget {
  /// List of note names to highlight on the keyboard (e.g., `['C', 'E', 'G']`).
  final List<String> highlightedNotes;

  /// Optional root note to highlight with a distinct tonic accent color (e.g., `'C'`).
  final String? rootNote;

  /// Number of octaves to display (`1` or `2`). Defaults to `2`.
  final int octaves;

  /// Whether to render note labels on the keys.
  final bool showNoteLabels;

  /// Optional callback invoked when a piano key is tapped, passing the note name.
  final ValueChanged<String>? onNoteTap;

  /// Height of the piano keyboard.
  final double height;

  /// Prefer flat notation (`Db`, `Eb`, `Gb`, `Ab`, `Bb`) on key labels.
  final bool preferFlats;

  /// Optional custom background color for active/highlighted white keys.
  /// Defaults to [ColorScheme.primaryContainer].
  final Color? activeKeyColor;

  /// Optional custom accent color for the root/tonic key.
  /// Defaults to [ColorScheme.primary].
  final Color? rootKeyColor;

  /// Optional custom background color for active/highlighted black keys.
  /// Defaults to [ColorScheme.secondary].
  final Color? activeBlackKeyColor;

  /// Creates a [PianoKeybedWidget].
  const PianoKeybedWidget({
    super.key,
    required this.highlightedNotes,
    this.rootNote,
    this.octaves = 2,
    this.showNoteLabels = true,
    this.onNoteTap,
    this.height = 150,
    this.preferFlats = false,
    this.activeKeyColor,
    this.rootKeyColor,
    this.activeBlackKeyColor,
  }) : assert(octaves >= 1 && octaves <= 3, 'octaves must be between 1 and 3');

  List<int> _computeActiveKeys() {
    if (highlightedNotes.isEmpty) return const [];
    final semitones = highlightedNotes
        .map(ChordTransposer.noteToSemitone)
        .where((s) => s != -1)
        .toList();
    if (semitones.isEmpty) return const [];

    if (octaves == 1) {
      return semitones.toSet().toList();
    }

    // Build an ascending voicing starting from the first note (root/bass) in octave 0
    final activeKeys = <int>[];
    int previousAbsolute = -1;
    for (final s in semitones) {
      int candidate = s;
      if (previousAbsolute != -1 && candidate <= previousAbsolute) {
        candidate += 12;
      }
      if (candidate >= octaves * 12) {
        candidate %= (octaves * 12);
      }
      activeKeys.add(candidate);
      previousAbsolute = candidate;
    }
    return activeKeys;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final activeKeys = _computeActiveKeys();
    final rootSemitone =
        rootNote != null ? ChordTransposer.noteToSemitone(rootNote!) : -1;

    return SizedBox(
      height: height,
      width: double.infinity,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = Size(constraints.maxWidth, height);
          return GestureDetector(
            onTapDown: onNoteTap == null
                ? null
                : (details) {
                    final note = _hitTestNote(
                      details.localPosition,
                      size,
                      octaves: octaves,
                      preferFlats: preferFlats,
                    );
                    if (note != null) {
                      onNoteTap!(note);
                    }
                  },
            child: CustomPaint(
              size: size,
              painter: _PianoKeybedPainter(
                activeKeys: activeKeys,
                rootSemitone: rootSemitone,
                octaves: octaves,
                showNoteLabels: showNoteLabels,
                preferFlats: preferFlats,
                colorScheme: colorScheme,
                customActiveKeyColor: activeKeyColor,
                customRootKeyColor: rootKeyColor,
                customActiveBlackKeyColor: activeBlackKeyColor,
              ),
            ),
          );
        },
      ),
    );
  }

  static String? _hitTestNote(
    Offset pos,
    Size size, {
    required int octaves,
    required bool preferFlats,
  }) {
    final totalWhiteKeys = 7 * octaves;
    final whiteKeyWidth = size.width / totalWhiteKeys;
    final blackKeyWidth = whiteKeyWidth * 0.62;
    final blackKeyHeight = size.height * 0.60;

    const whiteSemitones = [0, 2, 4, 5, 7, 9, 11];
    const blackSemitoneAfterWhite = <int, int>{
      0: 1,
      1: 3,
      3: 6,
      4: 8,
      5: 10,
    };

    // Check black keys first since they sit on top of white keys
    if (pos.dy <= blackKeyHeight) {
      for (int oct = 0; oct < octaves; oct++) {
        for (final entry in blackSemitoneAfterWhite.entries) {
          final whiteIdx = oct * 7 + entry.key;
          final centerX = (whiteIdx + 1) * whiteKeyWidth;
          final rect = Rect.fromLTWH(
            centerX - blackKeyWidth / 2,
            0,
            blackKeyWidth,
            blackKeyHeight,
          );
          if (rect.contains(pos)) {
            return ChordTransposer.semitoneToNote(
              entry.value,
              preferFlats: preferFlats,
            );
          }
        }
      }
    }

    final whiteIndex = (pos.dx / whiteKeyWidth).floor();
    if (whiteIndex >= 0 && whiteIndex < totalWhiteKeys) {
      final semitone = whiteSemitones[whiteIndex % 7];
      return ChordTransposer.semitoneToNote(semitone, preferFlats: preferFlats);
    }
    return null;
  }
}

class _PianoKeybedPainter extends CustomPainter {
  final List<int> activeKeys;
  final int rootSemitone;
  final int octaves;
  final bool showNoteLabels;
  final bool preferFlats;
  final ColorScheme colorScheme;
  final Color? customActiveKeyColor;
  final Color? customRootKeyColor;
  final Color? customActiveBlackKeyColor;

  _PianoKeybedPainter({
    required this.activeKeys,
    required this.rootSemitone,
    required this.octaves,
    required this.showNoteLabels,
    required this.preferFlats,
    required this.colorScheme,
    this.customActiveKeyColor,
    this.customRootKeyColor,
    this.customActiveBlackKeyColor,
  });

  static const List<int> _whiteSemitones = [0, 2, 4, 5, 7, 9, 11];
  static const Map<int, int> _blackAfterWhite = {
    0: 1,
    1: 3,
    3: 6,
    4: 8,
    5: 10,
  };

  @override
  void paint(Canvas canvas, Size size) {
    final totalWhiteKeys = 7 * octaves;
    final whiteKeyWidth = size.width / totalWhiteKeys;
    final blackKeyWidth = whiteKeyWidth * 0.62;
    final blackKeyHeight = size.height * 0.60;

    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = colorScheme.outlineVariant;

    final fillPaint = Paint()..style = PaintingStyle.fill;

    // 1. Draw White Keys
    for (int i = 0; i < totalWhiteKeys; i++) {
      final oct = i ~/ 7;
      final semitoneInOct = _whiteSemitones[i % 7];
      final absoluteKey = oct * 12 + semitoneInOct;
      final isHighlighted = activeKeys.contains(absoluteKey);
      final isRoot = isHighlighted && (semitoneInOct == rootSemitone);

      final rect = RRect.fromRectAndCorners(
        Rect.fromLTWH(
          i * whiteKeyWidth + 0.5,
          0,
          whiteKeyWidth - 1,
          size.height,
        ),
        bottomLeft: const Radius.circular(6),
        bottomRight: const Radius.circular(6),
      );

      final effectiveRootColor = customRootKeyColor ?? colorScheme.primary;
      final effectiveActiveWhiteColor =
          customActiveKeyColor ?? colorScheme.primaryContainer;

      if (isRoot) {
        fillPaint.color = effectiveRootColor;
      } else if (isHighlighted) {
        fillPaint.color = effectiveActiveWhiteColor;
      } else {
        fillPaint.color = Colors.white;
      }

      canvas.drawRRect(rect, fillPaint);
      canvas.drawRRect(rect, borderPaint);

      if (showNoteLabels && (isHighlighted || semitoneInOct == 0)) {
        final label = ChordTransposer.semitoneToNote(
          semitoneInOct,
          preferFlats: preferFlats,
        );
        final textColor = isRoot
            ? colorScheme.onPrimary
            : isHighlighted
                ? (customActiveKeyColor != null
                    ? (ThemeData.estimateBrightnessForColor(effectiveActiveWhiteColor) == Brightness.dark
                        ? Colors.white
                        : Colors.black87)
                    : colorScheme.onPrimaryContainer)
                : Colors.black54;

        _drawCenteredText(
          canvas,
          label,
          Offset(
            i * whiteKeyWidth + whiteKeyWidth / 2,
            size.height - 18,
          ),
          TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: whiteKeyWidth < 26 ? 10 : 12,
          ),
        );
      }
    }

    // 2. Draw Black Keys
    for (int oct = 0; oct < octaves; oct++) {
      for (final entry in _blackAfterWhite.entries) {
        final whiteIdx = oct * 7 + entry.key;
        final semitoneInOct = entry.value;
        final absoluteKey = oct * 12 + semitoneInOct;
        final isHighlighted = activeKeys.contains(absoluteKey);
        final isRoot = isHighlighted && (semitoneInOct == rootSemitone);

        final centerX = (whiteIdx + 1) * whiteKeyWidth;
        final rect = RRect.fromRectAndCorners(
          Rect.fromLTWH(
            centerX - blackKeyWidth / 2,
            0,
            blackKeyWidth,
            blackKeyHeight,
          ),
          bottomLeft: const Radius.circular(5),
          bottomRight: const Radius.circular(5),
        );

        final effectiveRootColor = customRootKeyColor ?? colorScheme.primary;
        final effectiveActiveBlackColor =
            customActiveBlackKeyColor ?? colorScheme.secondary;

        final blackKeyBorderPaint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = isHighlighted ? 1.8 : 1.2
          ..color = isHighlighted
              ? (isRoot ? effectiveRootColor : effectiveActiveBlackColor)
              : colorScheme.outlineVariant;

        if (isRoot) {
          fillPaint.color = effectiveRootColor;
        } else if (isHighlighted) {
          fillPaint.color = effectiveActiveBlackColor;
        } else {
          fillPaint.color = const Color(0xFF1E1E24);
        }

        canvas.drawRRect(rect, fillPaint);
        canvas.drawRRect(rect, blackKeyBorderPaint);

        // Highlight indicator badge at the bottom of the black key
        if (isHighlighted) {
          final indicatorPaint = Paint()
            ..style = PaintingStyle.fill
            ..color = isRoot ? colorScheme.onPrimary : colorScheme.onSecondary;

          final indicatorWidth = blackKeyWidth * 0.45;
          const indicatorHeight = 3.5;
          final indicatorRect = RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: Offset(centerX, blackKeyHeight - 4.5),
              width: indicatorWidth,
              height: indicatorHeight,
            ),
            const Radius.circular(2),
          );
          canvas.drawRRect(indicatorRect, indicatorPaint);
        }

        if (showNoteLabels && isHighlighted) {
          final label = ChordTransposer.semitoneToNote(
            semitoneInOct,
            preferFlats: preferFlats,
          );
          final textColor = isRoot
              ? colorScheme.onPrimary
              : colorScheme.onSecondary;

          _drawCenteredText(
            canvas,
            label,
            Offset(centerX, blackKeyHeight - 16),
            TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: blackKeyWidth < 18 ? 8 : 10,
            ),
          );
        }
      }
    }
  }

  void _drawCenteredText(
    Canvas canvas,
    String text,
    Offset center,
    TextStyle style,
  ) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: style),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(
      canvas,
      Offset(center.dx - tp.width / 2, center.dy - tp.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant _PianoKeybedPainter oldDelegate) {
    return oldDelegate.activeKeys != activeKeys ||
        oldDelegate.rootSemitone != rootSemitone ||
        oldDelegate.octaves != octaves ||
        oldDelegate.showNoteLabels != showNoteLabels ||
        oldDelegate.preferFlats != preferFlats ||
        oldDelegate.colorScheme != colorScheme;
  }
}
