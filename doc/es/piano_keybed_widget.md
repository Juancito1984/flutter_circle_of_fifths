# 🎹 PianoKeybedWidget

El widget **`PianoKeybedWidget`** es un teclado visual e interactivo de piano que renderiza de 1 a 3 octavas mediante vectores dinámicos, resaltando las teclas correspondientes a cualquier acorde, escala o modo musical.

---

## 🎯 Características Principales

1. **Renderizado de 1 a 3 Octavas**:
   * Soporta 1 octava (12 teclas), 2 octavas (24 teclas) o 3 octavas (36 teclas) adaptándose automáticamente al ancho disponible.
2. **Resaltado Inteligente de Notas**:
   * Las teclas pulsadas o activas se colorean con el acento del tema.
   * La nota fundamental o tónica (`rootNote`) puede destacarse con un color diferenciado para identificar la base del acorde o escala.
3. **Etiquetas de Teclas (`showNoteLabels`)**:
   * Muestra el nombre de la nota en cada tecla activa (`C`, `D`, `E`, etc.).
   * Soporta preferencia por bemoles (`preferFlats: true` para mostrar `Db`, `Eb`, `Gb`, `Ab`, `Bb`).
4. **Interacción Táctil Desacoplada (`onNoteTap`)**:
   * Detecta toques en cada tecla individual y entrega la nota pulsada (ej. `'C4'`, `'G4'`).
   * Para mantener la librería libre de dependencias nativas y con 160/160 puntos en pub.dev, el widget no fuerza un reproductor nativo. Puedes conectar directamente el sintetizador en memoria incluido ([`SimpleAudioSynthesizer`](../../lib/src/audio/simple_audio_synthesizer.dart)) con tu reproductor de audio preferido (`audioplayers`, `just_audio`, etc.).

---

## ⚙️ Tabla de Propiedades

| Parámetro | Tipo | Valor por Defecto | Descripción |
| :--- | :--- | :--- | :--- |
| **`highlightedNotes`** *(requerido)* | `List<String>` | — | Lista de notas a resaltar en el teclado (ej: `['C', 'E', 'G']`). |
| **`rootNote`** | `String?` | `null` | Nota fundamental o tónica (se resalta con un tono especial en el teclado). |
| **`octaves`** | `int` | `2` | Cantidad de octavas visibles (`1`, `2` o `3`). |
| **`showNoteLabels`** | `bool` | `true` | Determina si se dibuja la etiqueta de texto con el nombre de la nota sobre la tecla. |
| **`preferFlats`** | `bool` | `false` | Si es `true`, usa nomenclatura con bemoles (`Db`, `Eb`, etc.) en lugar de sostenidos (`C#`, `D#`). |
| **`height`** | `double` | `150` | Altura del teclado en píxeles. |
| **`onNoteTap`** | `ValueChanged<String>?` | `null` | Callback ejecutado cuando el usuario toca una tecla específica, entregando el nombre de la nota. |

---

## 💻 Ejemplos de Uso

### 1. Acorde de Do Mayor (C - E - G) con Reproducción de Audio

```dart
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circle_of_fifths/flutter_circle_of_fifths.dart';

class PianoChordDemo extends StatefulWidget {
  const PianoChordDemo({super.key});

  @override
  State<PianoChordDemo> createState() => _PianoChordDemoState();
}

class _PianoChordDemoState extends State<PianoChordDemo> {
  final AudioPlayer _player = AudioPlayer();

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _playNote(String note) async {
    // Genera la onda sonora PCM WAV en memoria sin plugins C++
    final wavBytes = SimpleAudioSynthesizer.synthesizeChordNotes([note]);
    if (wavBytes.isNotEmpty) {
      await _player.stop();
      await _player.play(BytesSource(wavBytes));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: PianoKeybedWidget(
          highlightedNotes: const ['C', 'E', 'G'],
          rootNote: 'C',
          octaves: 2,
          showNoteLabels: true,
          height: 140,
          onNoteTap: (note) => _playNote(note),
        ),
      ),
    );
  }
}
```

---

### 2. Escala Pentatónica Menor con Bemoles

```dart
PianoKeybedWidget(
  highlightedNotes: const ['Eb', 'Gb', 'Ab', 'Bb', 'Db'],
  rootNote: 'Eb',
  preferFlats: true,
  octaves: 1,
  height: 120,
)
```
