## 1.2.0

> [!NOTE]
> **Retrocompatibilidad 100% garantizada (No Breaking Changes)**: Todas las clases, constructores y métodos existentes (`CircleOfFifthsWheelWidget`, `CircleOfFifthsSheet`, `ScaleDetailCard`, `CircleOfFifthsModel`, `CircleOfFifthsTheme`) mantienen sus nombres y firmas intactos. Todo código previo a la versión 1.2.0 seguirá funcionando sin ninguna modificación.
> En `ScaleDetailCard`, los nuevos parámetros (`showPianoScale` y `enableChordTap`) son opcionales con valores predeterminados seguros (`false` y `true`).

### 🚀 Nuevas Funcionalidades (Musical Suite Expansion)

* **📝 Módulo 1: Visor de Canciones ChordPro y Transpositor Armónico (`ChordSheetViewer`)**:
  * Nuevo widget `ChordSheetViewer` para renderizar canciones en notación entre corchetes o ChordPro (`[C]Amazing [F]grace...`).
  * Motor `ChordTransposer`: transposición de canciones completas y acordes por semitonos (`+1` / `-1`) o directamente entre tonalidades del Círculo de Quintas, adaptando armaduras enarmónicas (`#` vs `b`).
  * Detección y parseo de acordes mayores, menores, séptimas, suspendidos, disminuidos y acordes con bajo invertido (*slash chords* como `C/G` o `D/F#`).
  * Etiquetas de acordes interactivas y barra resumen de acordes de la canción.

* **🎸 Módulo 2: Diagramas de Acordes para Instrumentos**:
  * `FretboardWidget`: diagramas de mástil dibujados por vector con `CustomPainter` para **Guitarra (6 cuerdas)** y **Ukulele (4 cuerdas)**, con soporte para cejillas curvas (`barres`), cuerdas abiertas (`O`), silenciadas (`✕`) y números de dedos (`1–4`).
  * `PianoKeybedWidget`: teclado de piano de 1 a 3 octavas con iluminación de notas del acorde o escala y tónica resaltada.
  * `ChordInspectorSheet`: modal interactivo para inspeccionar cualquier acorde en Guitarra, Ukulele y Piano con sus notas e intervalos.
  * `ScaleDetailCard`: añadido soporte para tocar cualquier grado de la escala para abrir su diagrama de acordes e integración de piano con `showPianoScale: true`.

* **🎼 Módulo 3: Constructor y Analizador de Progresiones Armónicas (`ProgressionBuilderWidget`)**:
  * `ProgressionBuilderWidget` con análisis de grados en **Numeración Romana** ($I, ii, iii, IV, V, vi, vii^\circ$).
  * Plantillas populares listas para usar: Pop/Rock (I - V - vi - IV Axis), Jazz (ii - V - I), 12-Bar Blues, Canon de Pachelbel, 50s Doo-Wop y Cadencia Andaluza.
  * Sugerencias de dominantes secundarios y modulaciones ($V7/V$, $V7/vi$, $bVII$, $iv$ menor prestado).

* **🎷 Módulo 4: Modos Gregorianos y Escalas Avanzadas (`ScaleModesWidget`)**:
  * `ScaleModesWidget` con los **7 Modos Gregorianos/Eclesiásticos**: Jónico, Dórico, Frigio, Lidio, Mixolidio, Eolio y Locrio.
  * Escalas modernas: Pentatónica Mayor, Pentatónica Menor, Escala de Blues, Menor Armónica y Menor Melódica.
  * Desglose visual de notas, fórmulas interválicas de semitonos y teclado de piano sincronizado.

* **🔊 Módulo 5: Síntesis de Sonido en Dart Puro**:
  * `SimpleAudioSynthesizer`: generador de audio PCM WAV en memoria (afinación temperada de 440Hz con armónicos y envolvente de decaimiento) sin plugins nativos externos, 100% multiplataforma.

* **📱 Rediseño de la App de Ejemplo**:
  * `example/lib/main.dart` rediseñado en un estudio musical Material 3 con barra de navegación (`NavigationBar`) de 5 pantallas.

## 1.1.1

* Actualización de documentación y enlaces oficiales.
* Optimización de rendimiento en pintado canvas del Círculo de Quintas.

## 1.1.0

* Soporte de temas adaptativos con Material 3.
* Modal `CircleOfFifthsSheet` con vista interactiva y cuadrícula resumen.
