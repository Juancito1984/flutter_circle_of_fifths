# 🔍 ChordInspectorSheet

El widget **`ChordInspectorSheet`** es un panel modal interactivo diseñado para el análisis armónico e instrumental en profundidad de cualquier acorde. Muestra su fórmula interválica, notas individuales y pestañas dedicadas con diagramas reales de digitación para **Guitarra**, **Ukelele** y **Piano**.

---

## 🎯 Características Principales

1. **Apertura Sencilla mediante Método Estático**:
   * Invócable con una sola línea de código: `ChordInspectorSheet.show(context, chordSymbol: "G7")`.
2. **Desglose Teórico del Acorde**:
   * Muestra la raíz, calidad armónica (Mayor, Menor, 7ma, Maj7, Sus4, Dim, etc.), bajo invertido (si es un *slash chord* como `D/F#`), fórmula interválica (1 - 3 - 5 - b7) y lista de notas que lo componen.
3. **Pestañas para 3 Instrumentos**:
   * **Guitarra**: Mástil de 6 cuerdas con cejillas, cuerdas muteadas y número de dedos.
   * **Ukelele**: Mástil de 4 cuerdas afinado en G-C-E-A estándar con digitación recomendada.
   * **Piano**: Teclado de 2 octavas con las teclas pulsadas iluminadas y etiquetas de notas.
4. **Reproducción de Audio en Tiempo Real**:
   * Incluye un botón para reproducir el acorde completo sintetizado armónicamente.
5. **Completamente Localizable (i18n)**:
   * Compatible con [`CircleOfFifthsLabels`](file:///C:/Users/ingej/StudioProjects/flutter_circle_of_fifths/lib/src/theme/circle_of_fifths_labels.dart) para traducir las pestañas de instrumentos y etiquetas teóricas.

---

## ⚙️ Tabla de Propiedades

### Parámetros del Constructor y de `ChordInspectorSheet.show(...)`

| Parámetro | Tipo | Valor por Defecto | Descripción |
| :--- | :--- | :--- | :--- |
| **`chordInfo`** *(requerido en constructor)* | `ChordInfo` | — | Objeto `ChordInfo` con los datos analizados del acorde (raíz, calidad, intervalos, digitaciones). |
| **`chordSymbol`** *(requerido en `.show`)* | `String` | — | Símbolo textual del acorde a inspeccionar (ej: `'C'`, `'Am7'`, `'F#m'`, `'C/G'`). |
| **`initialInstrument`** | `InstrumentType` | `InstrumentType.guitar` | Pestaña de instrumento abierta inicialmente (`guitar`, `ukulele`, `piano`). |
| **`labels`** | `CircleOfFifthsLabels` | `CircleOfFifthsLabels()` | Instancia de traducción para los encabezados y etiquetas de instrumentos. |

---

## 💻 Ejemplos de Uso

### 1. Desplegar el Inspector Modal desde Cualquier Botón

```dart
import 'package:flutter/material.dart';
import 'package:flutter_circle_of_fifths/flutter_circle_of_fifths.dart';

class ChordButtonExample extends StatelessWidget {
  const ChordButtonExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        ChordInspectorSheet.show(
          context,
          chordSymbol: 'Bm7',
          initialInstrument: InstrumentType.guitar,
          labels: CircleOfFifthsLabels.spanish,
        );
      },
      child: const Text('Inspeccionar Bm7'),
    );
  }
}
```

---

### 2. Uso Incrustado Directamente en un Layout

```dart
final chordInfo = ChordTransposer.parseChord('F#m');

ChordInspectorSheet(
  chordInfo: chordInfo,
  initialInstrument: InstrumentType.piano,
  labels: CircleOfFifthsLabels.spanish,
)
```
