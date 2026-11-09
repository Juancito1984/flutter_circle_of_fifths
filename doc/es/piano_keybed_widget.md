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
4. **Interacción Táctil y Síntesis Sonora (`onNoteTap`)**:
   * Permite escuchar el tono de cada tecla tocada con audio sintetizado puro o conectar una lógica personalizada de eventos.

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

### 1. Acorde de Do Mayor (C - E - G) en 2 Octavas

```dart
import 'package:flutter/material.dart';
import 'package:flutter_circle_of_fifths/flutter_circle_of_fifths.dart';

class PianoChordDemo extends StatelessWidget {
  const PianoChordDemo({super.key});

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
          onNoteTap: (note) {
            debugPrint('Tecla pulsada: $note');
          },
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
