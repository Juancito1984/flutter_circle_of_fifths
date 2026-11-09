# flutter_circle_of_fifths (Español)

Una suite musical completa, interactiva, personalizable y adaptada a **Material 3** para Flutter que incluye el **Círculo de Quintas, Visor de Canciones con Acordes (ChordPro), Transpositor Armónico, Diagramas de Instrumentos (Guitarra, Ukulele, Piano), Progresiones Armónicas con Análisis Romano, Modos Gregorianos y Síntesis de Audio en Dart Puro**.

[![pub package](https://img.shields.io/pub/v/flutter_circle_of_fifths.svg)](https://pub.dev/packages/flutter_circle_of_fifths)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Flutter](https://img.shields.io/badge/Flutter-%3E%3D3.10.0-02569B?logo=flutter)](https://flutter.dev)

---

🌐 **Idiomas / Languages**: [Español](README_ES.md) | [English](README_EN.md)

---

## ☕ Apoya el Proyecto

Si este paquete te ha sido útil y deseas apoyar su desarrollo y mantenimiento continuo, puedes contribuir a través de los siguientes enlaces:

- 💳 **PayPal**: [paypal.me/NyKservice](https://paypal.me/NyKservice)
- 🅿️ **Patreon**: [patreon.com/JuanPabloGosalvez](https://www.patreon.com/c/JuanPabloGosalvez)

¡Tu apoyo es enormemente apreciado para mantener este proyecto 100% gratuito, de código abierto y en constante evolución!

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

## 🚀 Instalación

Agrega la dependencia en tu archivo `pubspec.yaml`:

```yaml
dependencies:
  flutter_circle_of_fifths: ^1.3.0
```

Ejecuta en la terminal:

```bash
flutter pub get
```

---

## 💻 Ejemplos de Uso

### 1. Desplegar el Círculo de Quintas como Modal (Una línea)

```dart
import 'package:flutter/material.dart';
import 'package:flutter_circle_of_fifths/flutter_circle_of_fifths.dart';

void abrirCirculoDeQuintas(BuildContext context) {
  CircleOfFifthsSheet.show(
    context,
    customTheme: const CircleOfFifthsTheme(
      centerLabel: 'NyK',
    ),
  );
}
```

---

### 2. Rueda Interactiva y Tarjeta de Escala Diatónica

```dart
import 'package:flutter/material.dart';
import 'package:flutter_circle_of_fifths/flutter_circle_of_fifths.dart';

class PaginaMusical extends StatefulWidget {
  const PaginaMusical({super.key});

  @override
  State<PaginaMusical> createState() => _PaginaMusicalState();
}

class _PaginaMusicalState extends State<PaginaMusical> {
  int _selectedIndex = 0; // 0 = 'C'
  bool _isMinorMode = false;

  @override
  Widget build(BuildContext context) {
    final selectedModel = CircleOfFifthsModel.defaultKeys[_selectedIndex];

    return Scaffold(
      appBar: AppBar(title: const Text('Círculo de Quintas')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleOfFifthsWheelWidget(
              selectedIndex: _selectedIndex,
              isMinorMode: _isMinorMode,
              onKeySelected: (index, isMinor) {
                setState(() {
                  _selectedIndex = index;
                  _isMinorMode = isMinor;
                });
              },
            ),
            const SizedBox(height: 20),
            ScaleDetailCard(
              model: selectedModel,
              isMinorMode: _isMinorMode,
              showPianoScale: true, // Muestra el teclado de piano para la escala
            ),
          ],
        ),
      ),
    );
  }
}
```

---

### 3. Visor de Canciones con Acordes y Transposición en Tiempo Real

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
    showChords: true, // Cambia a false para ocultar acordes y ver solo la letra
    lineSpacing: 6.0, // Espacio entre líneas consecutivas de un verso
    stanzaSpacing: 18.0, // Espacio entre estrofas (líneas vacías)
    showDiagramModalOnTap: true, // Abre modal con Guitarra/Ukulele/Piano al pulsar un acorde
  );
}
```

---

### 4. Diagramas de Acordes para Instrumentos (Guitarra, Ukulele, Piano)

```dart
import 'package:flutter/material.dart';
import 'package:flutter_circle_of_fifths/flutter_circle_of_fifths.dart';

// Abre el modal inspector para cualquier acorde:
void inspeccionarAcorde(BuildContext context, String acorde) {
  ChordInspectorSheet.show(context, chordSymbol: acorde);
}

// O inserta los diagramas directamente en tu UI:
Widget construirDiagramas() {
  final info = ChordTransposer.parseChord('G7');
  return Column(
    children: [
      FretboardWidget(voicing: info.guitarVoicing, chordTitle: 'G7 (Guitarra)'),
      FretboardWidget(voicing: info.ukuleleVoicing, chordTitle: 'G7 (Ukulele)'),
      PianoKeybedWidget(highlightedNotes: info.notes, rootNote: info.root),
    ],
  );
}
```

---

### 5. Constructor de Progresiones y Análisis en Números Romanos

```dart
import 'package:flutter/material.dart';
import 'package:flutter_circle_of_fifths/flutter_circle_of_fifths.dart';

Widget constructorProgresion() {
  return const ProgressionBuilderWidget(
    activeKey: 'C',
  );
}
```

---

### 6. Modos Gregorianos y Escalas Avanzadas

```dart
import 'package:flutter/material.dart';
import 'package:flutter_circle_of_fifths/flutter_circle_of_fifths.dart';

Widget exploradorModos() {
  return const ScaleModesWidget(
    rootNote: 'D', // Explora Dórico, Frigio, Lidio, Blues, etc.
  );
}
```

---

### 7. Internacionalización y Personalización de Idioma (i18n)

Configura o traduce todos los textos de la interfaz desde un único lugar con `CircleOfFifthsLabels`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_circle_of_fifths/flutter_circle_of_fifths.dart';

// Opción A: Usar la traducción al español integrada directamente
final etiquetasEspanol = CircleOfFifthsLabels.spanish;

// Opción B: Modificar solo algunas palabras usando copyWith
final etiquetasPersonalizadas = CircleOfFifthsLabels.spanish.copyWith(
  tapDegreeForChordHint: 'Presiona para ver el acorde',
);

// Opción C: Conectar todas las traducciones desde el gestor de idiomas de tu app (l10n)
final misEtiquetas = CircleOfFifthsLabels(
  title: context.idioma.circuloDeQuintas,
  interactiveWheelLabel: context.idioma.ruedaInteractiva,
  summaryViewLabel: context.idioma.vistaResumen,
  majorLabel: context.idioma.mayor,
  minorLabel: context.idioma.menor,
  tapDegreeForChordHint: context.idioma.tocaParaVerAcorde,
  transposeLabel: context.idioma.transponer,
  resetLabel: context.idioma.restablecer,
  keyLabel: context.idioma.tonalidad,
  uniqueChordsLabel: context.idioma.acordesDeLaCancion,
  guitarLabel: context.idioma.guitarra,
  ukuleleLabel: context.idioma.ukelele,
  pianoLabel: context.idioma.piano,
  progressionTitle: context.idioma.progresionArmonica,
  modesCategoryLabel: context.idioma.modos,
  advancedCategoryLabel: context.idioma.avanzado,
);

// Pásalo a cualquier widget o modal de la librería:
void mostrarModalConIdioma(BuildContext context) {
  CircleOfFifthsSheet.show(context, labels: misEtiquetas);
}
```

---

## 🎨 Configuración de Tema Personalizado

```dart
CircleOfFifthsTheme(
  centerLabel: 'NyK',
  tonicColor: Colors.amber,
  subdominantDominantColor: Colors.deepOrange,
  minorChordsColor: Colors.teal,
  diminishedColor: Colors.indigo,
)
```

---

## 📄 Licencia

Este proyecto está licenciado bajo la Licencia MIT - consulta el archivo [LICENSE](LICENSE) para más detalles.
