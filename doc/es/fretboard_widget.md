# 🎸 FretboardWidget

El widget **`FretboardWidget`** es un componente de dibujo vectorial que genera diagramas de mástil para instrumentos de cuerda pulsada, admitiendo **Guitarra** (6 cuerdas) y **Ukelele** (4 cuerdas).

---

## 🎯 Características Principales

1. **Renderizado Vectorial Nítido con `CustomPainter`**:
   * Dibuja cejuela (*nut*), trastes, cuerdas metálicas, marcadores de cejilla (*barres*) y círculos de digitación.
2. **Representación de Cuerdas y Digitación Completa**:
   * **Números de Dedo**: Dibuja `1` (índice), `2` (medio), `3` (anular) y `4` (meñique) dentro del punto del traste.
   * **Cuerdas al Aire (`O`)**: Muestra un círculo hueco sobre las cuerdas que deben sonar sin pisar.
   * **Cuerdas Muteadas (`X`)**: Muestra una cruz sobre las cuerdas que deben silenciarse.
   * **Cejillas (`Barres`)**: Dibuja una barra curva o sólida continua cubriendo las cuerdas pisadas por el mismo dedo.
   * **Traste Inicial**: Muestra el indicador del traste en el que comienza el acorde si no está en la primera posición (por ejemplo, `3fr` o `5fr`).
3. **Constructor Directo desde Símbolo (`FretboardWidget.fromChord`)**:
   * Permite instanciar el diagrama pasando únicamente el nombre del acorde (`'Am'`, `'G7'`, etc.) sin necesidad de calcular manualmente las posiciones.
4. **Listo para Sonido Sintetizado (`SimpleAudioSynthesizer`)**:
   * Para reproducir el sonido del acorde en tu app, utiliza [`SimpleAudioSynthesizer.synthesizeWav`](../../lib/src/audio/simple_audio_synthesizer.dart) o `synthesizeChordNotes` con tu reproductor de audio preferido (`audioplayers`, `just_audio`), manteniendo la suite libre de dependencias nativas obligatorias.

---

## ⚙️ Tabla de Propiedades

| Parámetro | Tipo | Valor por Defecto | Descripción |
| :--- | :--- | :--- | :--- |
| **`voicing`** *(requerido en const)* | `ChordVoicing` | — | Modelo de datos de la posición (trastes, cejilla, dedos y afinación). |
| **`chordTitle`** | `String?` | `null` | Título o nombre del acorde mostrado arriba del diagrama. |
| **`fretCount`** | `int` | `5` | Número de trastes visibles dibujados en la cuadrícula. |
| **`width`** | `double` | `200` | Ancho del widget en píxeles lógicos. |
| **`height`** | `double` | `230` | Alto del widget en píxeles lógicos. |

### Constructor `FretboardWidget.fromChord(...)`

| Parámetro | Tipo | Valor por Defecto | Descripción |
| :--- | :--- | :--- | :--- |
| **`chordSymbol`** *(requerido)* | `String` | — | Texto del acorde (ej: `'C'`, `'Em'`, `'D7'`). |
| **`instrument`** | `InstrumentType` | `InstrumentType.guitar` | Tipo de instrumento (`InstrumentType.guitar` o `InstrumentType.ukulele`). |
| **`showTitle`** | `bool` | `false` | Determina si muestra el nombre del acorde encima del diagrama. |
| **`width`** | `double` | `200` | Ancho del diagrama. |
| **`height`** | `double` | `230` | Alto del diagrama. |

---

## 💻 Ejemplos de Uso

### 1. Diagrama de Guitarra desde Símbolo

```dart
import 'package:flutter/material.dart';
import 'package:flutter_circle_of_fifths/flutter_circle_of_fifths.dart';

class GuitarChordDemo extends StatelessWidget {
  const GuitarChordDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FretboardWidget.fromChord(
        chordSymbol: 'C',
        instrument: InstrumentType.guitar,
        showTitle: true,
        width: 180,
        height: 220,
      ),
    );
  }
}
```

---

### 2. Diagrama de Ukelele

```dart
FretboardWidget.fromChord(
  chordSymbol: 'G',
  instrument: InstrumentType.ukulele,
  showTitle: true,
  width: 160,
  height: 200,
)
```
