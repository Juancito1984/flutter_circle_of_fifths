# 📚 Documentación en Español - flutter_circle_of_fifths

Una suite musical completa, interactiva, personalizable y adaptada a **Material 3** para Flutter que incluye el **Círculo de Quintas, Visor de Canciones con Acordes (ChordPro), Transpositor Armónico, Diagramas de Instrumentos (Guitarra, Ukulele, Piano), Progresiones Armónicas con Análisis Romano, Modos Gregorianos y Síntesis de Audio en Dart Puro**.

[![pub package](https://img.shields.io/pub/v/flutter_circle_of_fifths.svg)](https://pub.dev/packages/flutter_circle_of_fifths)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Flutter](https://img.shields.io/badge/Flutter-%3E%3D3.10.0-02569B?logo=flutter)](https://flutter.dev)

*🌍 [Switch to English Documentation](../en/README.md) | [🏠 Portada Principal](../../README.md)*

---

## 🌟 Características Principales

- 🎡 **Rueda Interactiva de 12 Sectores**: Toca el anillo exterior para tonalidades Mayores o el anillo medio para sus Menores Relativas.
- 🔄 **Rotación Dinámica a las 12:00**: Centra suavemente la tonalidad activa en la parte superior.
- 📝 **Visor de Canciones con Acordes (`ChordSheetViewer`)**: Formato ChordPro y entre corchetes (`[C]Amazing [F]grace...`). Muestra etiquetas de acordes flotantes sobre las sílabas exactas. Toca cualquier acorde para ver cómo tocarlo.
- 🎚️ **Motor de Transposición Armónica (`ChordTransposer`)**: Transpone canciones completas por semitonos (`+1` / `-1`) o directamente entre tonalidades del Círculo de Quintas adaptando enarmonías (`#` frente a `b`).
- 🎸 **Diagramas de Acordes para Instrumentos**: Mástiles vectoriales con cejillas y dedos para **Guitarra (6 cuerdas)** y **Ukulele (4 cuerdas)**, además de **Teclado de Piano (1 a 3 octavas)** con notas resaltadas.
- 🎼 **Constructor de Progresiones Armónicas (`ProgressionBuilderWidget`)**: Plantillas estándar (Pop/Rock Axis, Jazz ii-V-I, 12-Bar Blues, Canon de Pachelbel), análisis en números romanos ($I, ii, iii, IV, V, vi, vii^\circ$) y sugerencias de dominantes secundarios.
- 🎷 **7 Modos Gregorianos y Escalas Avanzadas (`ScaleModesWidget`)**: Jónico, Dórico, Frigio, Lidio, Mixolidio, Eolio y Locrio; más Pentatónicas, Blues, Menor Armónica y Menor Melódica.
- 🔊 **Síntesis de Audio en Dart Puro (`SimpleAudioSynthesizer`)**: Generación de audio PCM WAV en memoria sin plugins nativos, 100% funcional en las 6 plataformas (Android, iOS, Web, Windows, macOS, Linux).
- 🌐 **Internacionalización Completa (i18n)**: Personaliza o traduce todos los textos (`CircleOfFifthsLabels`) de todos los widgets desde un solo lugar, con soporte en español integrado (`CircleOfFifthsLabels.spanish`).
- 🎨 **Adaptativo a Material 3**: Hereda de forma nativa la paleta de colores claro y oscuro de la aplicación.
- 📱 **Modales BottomSheet Listos para Usar**: Se despliegan con una sola línea de código para el Círculo de Quintas y el Inspector de Acordes.

---

## 🧩 Catálogo de Widgets y Documentación Individual

A continuación tienes acceso a la guía técnica detallada de cada widget con sus tablas de propiedades, explicaciones y ejemplos:

| Widget | Archivo Fuente | Documentación Completa | Resumen de Funcionalidad |
| :--- | :--- | :--- | :--- |
| **`ChordSheetViewer`** | [`chord_sheet_viewer.dart`](../../lib/src/widgets/chord_sheet_viewer.dart) | [📖 Guía de ChordSheetViewer](chord_sheet_viewer.md) | Visor de partituras/letras con acordes, transposición en tiempo real, `showChords`, ajuste de estrofas e interlineado. |
| **`CircleOfFifthsWheelWidget`** | [`circle_of_fifths_wheel.dart`](../../lib/src/widgets/circle_of_fifths_wheel.dart) | [📖 Guía de CircleOfFifthsWheelWidget](circle_of_fifths_wheel.md) | Rueda cromática interactiva en `CustomPainter` con rotación a las 12:00, armaduras de clave y grados armónicos. |
| **`CircleOfFifthsSheet`** | [`circle_of_fifths_sheet.dart`](../../lib/src/widgets/circle_of_fifths_sheet.dart) | [📖 Guía de CircleOfFifthsSheet](circle_of_fifths_sheet.md) | Panel modal deslizable (*BottomSheet*) con vistas de Rueda y Resumen en cuadrícula, invocable con `.show(...)`. |
| **`ScaleDetailCard`** | [`scale_detail_card.dart`](../../lib/src/widgets/scale_detail_card.dart) | [📖 Guía de ScaleDetailCard](scale_detail_card.md) | Grados diatónicos (I–VII), fórmula interválica, acordes primarios/secundarios y teclado de piano con audio. |
| **`ChordInspectorSheet`** | [`chord_inspector_sheet.dart`](../../lib/src/widgets/chord_inspector_sheet.dart) | [📖 Guía de ChordInspectorSheet](chord_inspector_sheet.md) | Inspector modal de acordes con fórmulas y digitaciones en Guitarra, Ukelele y Piano con síntesis sonora. |
| **`FretboardWidget`** | [`fretboard_widget.dart`](../../lib/src/widgets/fretboard_widget.dart) | [📖 Guía de FretboardWidget](fretboard_widget.md) | Diagrama vectorial de mástil de cuerdas para Guitarra (6 cuerdas) y Ukelele (4 cuerdas) con dedos y cejillas. |
| **`PianoKeybedWidget`** | [`piano_keybed_widget.dart`](../../lib/src/widgets/piano_keybed_widget.dart) | [📖 Guía de PianoKeybedWidget](piano_keybed_widget.md) | Teclado visual interactivo de piano (1 a 3 octavas) resaltando las notas activas y notas al tacto. |
| **`ProgressionBuilderWidget`** | [`progression_builder_widget.dart`](../../lib/src/widgets/progression_builder_widget.dart) | [📖 Guía de ProgressionBuilderWidget](progression_builder_widget.md) | Constructor de progresiones armónicas populares en números romanos con sugerencias y reproducción rítmica. |
| **`ScaleModesWidget`** | [`scale_modes_widget.dart`](../../lib/src/widgets/scale_modes_widget.dart) | [📖 Guía de ScaleModesWidget](scale_modes_widget.md) | Explorador interactivo de los 7 Modos Griegos y escalas avanzadas con teclado y reproducción ascendente. |

---

## 🚀 Instalación

Agrega la dependencia en tu archivo `pubspec.yaml`:

```yaml
dependencies:
  flutter_circle_of_fifths: ^1.3.1
```

Ejecuta en la terminal:

```bash
flutter pub get
```

---

## 💻 Ejemplos de Integración Rápida

### 1. Desplegar el Círculo de Quintas como Modal (Una línea)

```dart
import 'package:flutter/material.dart';
import 'package:flutter_circle_of_fifths/flutter_circle_of_fifths.dart';

void abrirCirculoDeQuintas(BuildContext context) {
  CircleOfFifthsSheet.show(
    context,
    labels: CircleOfFifthsLabels.spanish,
  );
}
```

---

### 2. Visor de Canciones con Acordes y Transposición

```dart
import 'package:flutter/material.dart';
import 'package:flutter_circle_of_fifths/flutter_circle_of_fifths.dart';

const cancionTexto = '''
{title: Amazing Grace}
[Verse 1]
[C]Amazing [F]grace, how [C]sweet the sound
That [C]saved a [G7]wretch like [C]me!
''';

Widget visorDeCancion() {
  return ChordSheetViewer(
    songText: cancionTexto,
    originalKey: 'C',
    targetKey: 'G', // Transpone automáticamente a Sol Mayor
    showChords: true,
    lineSpacing: 6.0,
    stanzaSpacing: 18.0,
    labels: CircleOfFifthsLabels.spanish,
  );
}
```

---

### 3. Internacionalización y Personalización de Idioma (i18n)

Configura o traduce todos los textos de la interfaz desde un único lugar con `CircleOfFifthsLabels`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_circle_of_fifths/flutter_circle_of_fifths.dart';

// Usar la traducción al español integrada directamente
final etiquetasEspanol = CircleOfFifthsLabels.spanish;

// O modificar palabras específicas usando copyWith
final etiquetasPersonalizadas = CircleOfFifthsLabels.spanish.copyWith(
  tapDegreeForChordHint: 'Toca para ver digitación',
);
```
