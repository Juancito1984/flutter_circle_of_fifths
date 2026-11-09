# 🏛️ ScaleModesWidget

El widget **`ScaleModesWidget`** es un explorador teórico y sonoro interactivo de los **7 Modos Griegos** tradicionales y de **escalas avanzadas** modernas (Pentatónicas, Blues, Menor Armónica, Menor Melódica).

---

## 🎯 Características Principales

1. **Catálogo de los 7 Modos Eclesiásticos / Griegos**:
   * **Jónico** (*Ionian* - Mayor Natural)
   * **Dórico** (*Dorian* - Menor con 6ta Mayor)
   * **Frigio** (*Phrygian* - Menor con 2da Menor)
   * **Lidio** (*Lydian* - Mayor con 4ta Aumentada)
   * **Mixolidio** (*Mixolydian* - Mayor con 7ma Menor)
   * **Eólico** (*Aeolian* - Menor Natural)
   * **Locrio** (*Locrian* - Disminuido con 5ta Disminuida)
2. **Escalas Avanzadas**:
   * Pestaña dedicada a Pentatónica Mayor, Pentatónica Menor, Escala de Blues, Menor Armónica y Menor Melódica.
3. **Análisis de Fórmula y Notas Derivadas**:
   * Muestra la estructura de tonos y semitonos (ej: T - T - S - T - T - T - S) y las notas exactas generadas a partir de la tónica seleccionada.
4. **Teclado de Piano Integrado (`showPianoKeyboard`)**:
   * Resalta visualmente las teclas de la escala en un teclado interactivo.
5. **Generación de Frecuencias de la Escala**:
   * Permite generar las frecuencias y ondas sonoras de la escala en orden ascendente mediante `SimpleAudioSynthesizer` para reproducirlas con cualquier backend de audio.
6. **Localización e Idiomas (i18n)**:
   * Compatible con [`CircleOfFifthsLabels`](file:///C:/Users/ingej/StudioProjects/flutter_circle_of_fifths/lib/src/theme/circle_of_fifths_labels.dart) para mostrar nombres de modos y explicaciones teóricas en español.

---

## ⚙️ Tabla de Propiedades

| Parámetro | Tipo | Valor por Defecto | Descripción |
| :--- | :--- | :--- | :--- |
| **`rootNote`** | `String` | `'C'` | Nota tónica o fundamental de la escala (ej: `'C'`, `'A'`, `'F#'`). |
| **`showRootSelector`** | `bool` | `true` | Muestra un selector para cambiar la nota raíz en tiempo real. |
| **`showPianoKeyboard`** | `bool` | `true` | Muestra u oculta el teclado de piano interactivo con las notas resaltadas. |
| **`labels`** | `CircleOfFifthsLabels` | `CircleOfFifthsLabels()` | Objeto de localización con nombres de modos y textos traducidos. |
| **`onScaleChanged`** | `ValueChanged<ScaleFormula>?` | `null` | Callback ejecutado cuando el usuario selecciona un modo o escala diferente. |

---

## 💻 Ejemplos de Uso

### 1. Explorador de Modos en Pantalla Completa

```dart
import 'package:flutter/material.dart';
import 'package:flutter_circle_of_fifths/flutter_circle_of_fifths.dart';

class ModesPage extends StatelessWidget {
  const ModesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Modos Griegos y Escalas')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: ScaleModesWidget(
          rootNote: 'D', // Explora modos a partir de Re (D Dórico, D Frigio, etc.)
          showRootSelector: true,
          showPianoKeyboard: true,
          labels: CircleOfFifthsLabels.spanish,
          onScaleChanged: (scale) {
            debugPrint('Modo seleccionado: ${scale.name}');
          },
        ),
      ),
    );
  }
}
```
