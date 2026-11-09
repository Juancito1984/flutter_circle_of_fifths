# 📝 ChordSheetViewer

El widget **`ChordSheetViewer`** es un visor musical de alto rendimiento diseñado para renderizar letras con acordes en formato **ChordPro** o notación entre corchetes (`[C]Letra`), integrando un motor de transposición armónica en tiempo real, control independiente de interlineado y apertura automática de diagramas de digitación para instrumentos.

---

## 🎯 Características Principales

1. **Alineación Precisa Acorde-Sílaba**: Cada acorde se posiciona exactamente sobre la sílaba o palabra a la que acompaña usando un diseño envolvente (*wrapped*) responsivo.
2. **Motor de Transposición Armónica**:
   * Transposición por semitonos paso a paso (`-11` a `+11`).
   * Transposición directa a cualquier tonalidad del **Círculo de Quintas** (por ejemplo, de `C` a `F#` o `Eb`), resolviendo de forma inteligente las alteraciones enarmónicas (`#` vs `b`).
3. **Control Avanzado de Espaciado e Interlineado**:
   * Separación entre versos contiguos (`lineSpacing`).
   * Separación entre estrofas o párrafos vacíos (`stanzaSpacing`).
   * Distancia vertical entre el badge del acorde y la letra (`chordToLyricSpacing`).
   * Separación entre palabras (`wordSpacing`) y en saltos de línea largos (`lineRunSpacing`).
4. **Modo Mostrar/Ocultar Acordes (`showChords`)**:
   * Permite alternar entre la vista con cifrado y la vista de solo letra.
   * Al estar en `showChords: false`, renderiza la canción como un bloque de texto continuo optimizado para lectura y selección nativa.
5. **Inspector de Acordes Integrado**:
   * Al tocar cualquier acorde, se despliega automáticamente un modal interactivo ([`ChordInspectorSheet`](file:///C:/Users/ingej/StudioProjects/flutter_circle_of_fifths/lib/src/widgets/chord_inspector_sheet.dart)) con diagramas de digitación para **Guitarra**, **Ukelele** y **Piano**, junto con síntesis de audio.
6. **Soporte Completo de Internacionalización (i18n)**:
   * Compatible con [`CircleOfFifthsLabels`](file:///C:/Users/ingej/StudioProjects/flutter_circle_of_fifths/lib/src/theme/circle_of_fifths_labels.dart) para personalizar o traducir todos los textos del visor y de la barra de transposición.

---

## 🛠 Sintaxis del Formato de Entrada (`songText`)

El widget procesa texto plano con acordes insertados entre corchetes:

```text
[G]Amazing grace, how [C]sweet the [G]sound
That saved a wretch like [D]me!
I [G]once was lost, but [C]now am [G]found,
Was [Em]blind, but [D]now I [G]see.

[G]Twas grace that taught my [C]heart to [G]fear,
And grace my fears re[D]lieved.
```

* **Encabezados de sección**: Las líneas que contengan etiquetas como `[Verse 1]`, `[Chorus]`, `[Intro]`, `[Bridge]` se formatean automáticamente con `sectionStyle`.
* **Líneas vacías**: Representan separación entre estrofas y aplican el espaciado definido por `stanzaSpacing`.
* **Acordes con bajo invertido (Slash Chords)**: Soporta acordes compuestos como `[C/G]`, `[D/F#]`, `[Am7/G]`.

---

## ⚙️ Tabla de Propiedades

| Parámetro | Tipo | Valor por Defecto | Descripción |
| :--- | :--- | :--- | :--- |
| **`songText`** *(requerido)* | `String` | — | Texto de la canción en formato ChordPro o con acordes entre corchetes (`"[G]Amazing [C]grace..."`). |
| **`originalKey`** | `String?` | `'C'` | Tonalidad original de la canción. Sirve como referencia base para la transposición automática al Círculo de Quintas. |
| **`initialTransposeSemitones`** | `int` | `0` | Desplazamiento inicial de transposición en semitonos (`-11` a `+11`). |
| **`targetKey`** | `String?` | `null` | Tonalidad objetivo externa sincronizada con el Círculo de Quintas (ej: `'G'`, `'Eb'`). Calcula automáticamente los semitonos y la enarmonía. |
| **`showChords`** | `bool` | `true` | Determina si se muestran los acordes encima de las letras. Si es `false`, oculta los badges, los espaciados superiores y la barra de transposición. |
| **`showTranspositionBar`** | `bool` | `true` | Muestra u oculta la barra superior de herramientas con controles de semitonos (`-`, `0`, `+`) y selector de tonalidad. |
| **`showChordSummaryBar`** | `bool` | `true` | Muestra una fila deslizable con los botones de todos los acordes únicos presentes en la canción. |
| **`showDiagramModalOnTap`** | `bool` | `true` | Si es `true`, al pulsar cualquier acorde se abre el modal con las digitaciones de Guitarra, Ukelele y Piano. |
| **`defaultInstrument`** | `InstrumentType` | `InstrumentType.guitar` | Instrumento seleccionado por defecto al abrir el inspector modal (`guitar`, `ukulele`, `piano`). |
| **`labels`** | `CircleOfFifthsLabels` | `CircleOfFifthsLabels()` | Instancia de traducción y personalización de textos. Puede pasarse `CircleOfFifthsLabels.spanish`. |
| **`lineSpacing`** | `double` | `8.0` | Espacio vertical entre líneas o versos consecutivos dentro de una misma estrofa. |
| **`stanzaSpacing`** | `double` | `16.0` | Espacio vertical entre estrofas (grupos de versos divididos por un salto de línea en blanco). |
| **`chordToLyricSpacing`** | `double` | `2.0` | Distancia vertical entre la parte inferior de la pastilla del acorde y la sílaba de la letra. |
| **`wordSpacing`** | `double` | `4.0` | Espaciado horizontal entre palabras o bloques de acorde-letra en la misma línea. |
| **`lineRunSpacing`** | `double` | `8.0` | Espaciado vertical si un verso muy largo debe envolverse (*wrap*) en la siguiente línea física de la pantalla. |
| **`lyricStyle`** | `TextStyle?` | `fontSize: 16, height: 1.2` | Estilo tipográfico para las letras de la canción. |
| **`chordStyle`** | `TextStyle?` | `fontSize: 13, bold, primaryColor` | Estilo tipográfico para las pastillas y nombres de los acordes. |
| **`sectionStyle`** | `TextStyle?` | `fontSize: 13, bold, secondaryColor` | Estilo para títulos de secciones (`[Intro]`, `[Chorus]`, etc.). |
| **`onTapChord`** | `ValueChanged<ChordInfo>?` | `null` | Callback ejecutado al presionar un acorde, entregando el objeto `ChordInfo` con sus datos armónicos. |
| **`onTransposeChanged`** | `ValueChanged<int>?` | `null` | Callback que notifica cada vez que el usuario cambia la transposición (devuelve el offset en semitonos). |

---

## 💻 Ejemplos de Uso

### 1. Uso Básico

```dart
import 'package:flutter/material.dart';
import 'package:flutter_circle_of_fifths/flutter_circle_of_fifths.dart';

class MySongPage extends StatelessWidget {
  const MySongPage({super.key});

  final String song = '''
[G]Amazing grace, how [C]sweet the [G]sound
That saved a wretch like [D]me!
I [G]once was lost, but [C]now am [G]found,
Was [Em]blind, but [D]now I [G]see.
''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Visor de Canción')),
      body: ChordSheetViewer(
        songText: song,
        originalKey: 'G',
      ),
    );
  }
}
```

---

### 2. Personalización de Interlineado y Separación de Estrofas

Si deseas un diseño compacto o más aireado entre estrofas:

```dart
ChordSheetViewer(
  songText: song,
  originalKey: 'C',
  lineSpacing: 6.0,          // Espacio entre versos contiguos
  stanzaSpacing: 24.0,       // Separación marcada entre estrofas
  chordToLyricSpacing: 3.0,  // Distancia del acorde a la letra
  wordSpacing: 6.0,
)
```

---

### 3. Modo Solo Letra (`showChords: false`)

Ideal cuando el usuario prefiere leer o cantar la letra sin la distracción visual de los acordes ni la barra de transposición:

```dart
ChordSheetViewer(
  songText: song,
  originalKey: 'C',
  showChords: false,         // Oculta acordes y barras accesorias
  lineSpacing: 8.0,
  stanzaSpacing: 20.0,
  lyricStyle: const TextStyle(
    fontSize: 18,
    height: 1.4,
    color: Colors.black87,
  ),
)
```

---

### 4. Sincronización con el Círculo de Quintas y Localización en Español

```dart
ChordSheetViewer(
  songText: song,
  originalKey: 'C',
  targetKey: 'Eb', // Se transporta automáticamente a Mi bemol
  labels: CircleOfFifthsLabels.spanish,
  defaultInstrument: InstrumentType.piano,
  onTransposeChanged: (semitones) {
    debugPrint('Transpuesto en $semitones semitonos');
  },
  onTapChord: (chord) {
    debugPrint('Acorde presionado: ${chord.name}');
  },
)
```
