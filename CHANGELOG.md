## 2.0.1

* **Corrección de Acordes Compuestos en `ChordSheetViewer` / `ChordSheetDocument` / `ChordTransposer`**:
  * Se corrige el renderizado de secuencias con barra separadora como `[C][/][Am]`, `[D][/][F#m]`, `[Bm/][A]` y `[Bm][/A]`, evitando que `[/]`, `[Bm/]` o `[/A]` aparezcan mezclados dentro de la letra y mostrándolos agrupados sobre la sílaba (`C/Am`, `D/F#m`, `Bm/A`).
  * Soporte directo para los cuatro formatos de entrada: `[D][/][F#m]`, `[D/F#m]`, `[Bm/][A]` y `[Bm][/A]` (manteniendo intactos los acordes con bajo invertido en un solo corchete como `[D/F#]`).
  * Cada acorde del grupo se transpone de forma independiente al subir/bajar semitonos o cambiar de tonalidad, aparece por separado en la barra de acordes únicos y es tocable individualmente para abrir su diagrama en `ChordInspectorSheet`.
  * Nuevo método [`ChordTransposer.splitCompoundChords`](lib/src/models/chord_model.dart) y propiedad [`ChordLyricSegment.chords`](lib/src/models/chord_sheet_parser.dart).
* **Mejoras de Diseño Responsivo en `ChordSheetViewer`**:
  * `_buildTranspositionToolbar` ahora ocupa todo el ancho disponible (`width: double.infinity`) y se adapta entre fila única en pantallas anchas y diseño compacto en dos filas para móviles.
  * `_buildUniqueChordsBar` ubica la etiqueta en la parte superior y la lista desplazable de acordes en la parte inferior.

## 2.0.0

> ⚠️ **Versión mayor con cambios incompatibles.** Ver la sección *Migración desde 1.x* al final de esta entrada.

* **Migración a `package:material_ui` (Flutter 3.50)** — *breaking change*:
  * Toda la librería importa ahora `package:material_ui/material_ui.dart` en lugar de `package:flutter/material.dart`, siguiendo la [deprecación oficial](https://docs.flutter.dev/release/breaking-changes/material-ui-and-cupertino-ui) de las librerías de diseño integradas en el SDK.
  * Nueva dependencia: `material_ui: ^1.11.1`.
* **Restricciones de SDK corregidas** — *breaking change*:
  * `sdk: ^3.13.0` y `flutter: ">=3.47.0"`. El rango anterior (`>=3.0.0` / `>=3.10.0`) no se podía resolver con los requisitos de `material_ui`.
* **Análisis estático más estricto**:
  * Se eliminó `deprecated_member_use: ignore` de ambos `analysis_options.yaml`. El proyecto analiza con 0 advertencias y las deprecaciones visibles.
* **App de ejemplo (`example/`)**:
  * Migración completa a Kotlin integrado de AGP 9 (`android.builtInKotlin=true`) y eliminación del Kotlin Gradle Plugin de `settings.gradle.kts`.
* **Documentación**:
  * Todos los ejemplos de `README.md`, `doc/en/` y `doc/es/` usan `material_ui`, con una nueva guía del puente de compatibilidad `MaterialUiCompatibilityBridge`.
* **Adaptabilidad Integral de `CircleOfFifthsWheelWidget` al Tema de la App**:
  * La rueda ahora se acopla dinámicamente y por defecto al `Theme.of(context).colorScheme`: la tónica toma `colorScheme.primary` y los grados dominantes/subdominantes toman `colorScheme.secondary` de forma nativa sin requerir configuración manual.
  * Los sectores inactivos y el núcleo central (`centerHub`) adaptan su brillo y fondo automáticamente (`surfaceContainerLowest` en claro y `surfaceContainerHigh` en oscuro), evitando el gris opaco desfasado de la interfaz.
  * Contraste tipográfico inteligente (`estimateBrightnessForColor`) en todos los sectores mayores y menores según el brillo del color activo.
  * Nuevas propiedades en [`CircleOfFifthsTheme`](lib/src/theme/circle_of_fifths_theme.dart): `inactiveSectorColor: Color?`, `centerHubColor: Color?` y `borderColor: Color?`.
  * En el piano de [`ScaleDetailCard`](lib/src/widgets/scale_detail_card.dart), todas las notas activas (blancas y negras) unifican ahora su color con el grado dominante/secundario (`secondaryColor`), manteniendo únicamente la tónica con el color primario (`primaryColor`), garantizando máxima armonía y legibilidad.
  * Nueva propiedad `centerLabelColor: Color?` en [`CircleOfFifthsTheme`](lib/src/theme/circle_of_fifths_theme.dart) para personalizar el color del texto central del Círculo de Quintas.
  * En modo claro, el fondo por defecto se adapta automáticamente con alto contraste dinámico (`surfaceContainerLowest` o `surface`), garantizando legibilidad total incluso dentro de modales y BottomSheets.
* **Contraste y Visibilidad en `PianoKeybedWidget` (y `ScaleDetailCard`)**:
  * Mejora sustancial en la diferenciación visual de las teclas negras seleccionadas: ahora aplican un borde con mayor grosor y acento activo, un fondo visible `colorScheme.secondary` (en lugar de `tertiary` apagado) y una barra/indicador de acento en el extremo inferior de la tecla, garantizando que las alteraciones (# / b) de cualquier escala o acorde se distingan inmediatamente de las teclas inactivas.
* **Personalización en `ChordSheetViewer`**:
  * Nueva propiedad `chordBackgroundColor: Color?` que permite personalizar libremente el fondo de las insignias (badges) de los acordes sobre las letras (por defecto `colorScheme.primaryContainer`).
* **Robustez en la Jerarquía Material 3**:
  * Los widgets modales y tarjetas ahora incluyen internamente envoltura `Material(type: MaterialType.transparency)` para garantizar renderizado libre de excepciones de ancestro en cualquier contexto de incrustación.

### Migración desde 1.x

1. Actualiza a **Flutter ≥ 3.47** (recomendado 3.50).
2. Migra los imports de tu app con `dart fix --apply --code=migrate_design_widgets` y agrega la dependencia con `flutter pub add material_ui`.
3. Si tu app (o alguna dependencia) aún usa `package:flutter/material.dart`, envuélvela con `MaterialUiCompatibilityBridge` en `MaterialApp.builder` para que los widgets de este paquete hereden tu tema y localizaciones:

   ```dart
   MaterialApp(
     builder: (context, child) => MaterialUiCompatibilityBridge(child: child!),
     home: const HomeScreen(),
   );
   ```

## 1.3.2

* **Soporte y Certificación con Flutter 3.50+ / Dart 3.14+**:
  * Compatibilidad certificada con Flutter 3.50.0 y Dart 3.14+ manteniendo un rango de SDK amplio y accesible (`sdk: ">=3.0.0 <4.0.0"` y `flutter: ">=3.10.0"`).
  * Modernización completa de la app de demostración (`example/`): Gradle Wrapper elevado a **9.5.0**, Android Gradle Plugin (AGP) a **9.3.1** y Kotlin Android a **2.4.20**.
  * Configuración optimizada de análisis estático en `analysis_options.yaml` asegurando 0 advertencias y compatibilidad hacia adelante.
  * Verificación y pase exitoso del 100% de las pruebas unitarias y de widgets.

## 1.3.1

* **Interacción Mejorada en `CircleOfFifthsWheelWidget`**:
  * El callback `onKeySelected` ahora se dispara de manera confiable en cada pulsación sobre cualquier sector, incluso si coincide con el acorde previamente seleccionado, permitiendo confirmar o reasignar la tonalidad sin necesidad de seleccionar primero otro acorde.
* **Portal de Documentación Oficial Bilingüe (`doc/`)**:
  * Nueva documentación técnica modular completa en español (`doc/es/`) e inglés (`doc/en/`) con guías individuales, tablas de propiedades y ejemplos interactivos para los 9 widgets de la suite.
  * Aclaración del funcionamiento desacoplado de la síntesis de sonido (`SimpleAudioSynthesizer`) en los widgets instrumentales para mantener 0 dependencias nativas en la librería.
* **Mejoras en la Aplicación de Ejemplo (`example/`)**:
  * Demostración en vivo de teclado de piano con reproducción sonora en tiempo real conectando `SimpleAudioSynthesizer` con `audioplayers`.
  * Corrección de desbordamiento horizontal (`RenderFlex overflow`) en la cabecera interactiva del piano.

## 1.3.0

* **Propiedad `showChords` en `ChordSheetViewer`**:
  * Permite alternar la visualización de los acordes encima de las letras (`true` por defecto).
  * Cuando `showChords: false`, oculta los badges de acordes, los espaciados superiores y la barra de transposición, mostrando la letra limpia sin interrupciones.
  * Renderizado optimizado con flujo de texto continuo y selección nativa.
* **Control Independiente de Separación entre Estrofas (`stanzaSpacing`)**:
  * Nueva propiedad `stanzaSpacing` en `ChordSheetViewer` (por defecto `16.0`). Evita que al usar valores bajos de `lineSpacing` las estrofas se junten en un solo bloque continuo.
* **Ajuste de Interlineado en `ChordSheetViewer`**:
  * Espaciado vertical entre versos (`lineSpacing`, por defecto `8.0`).
  * Distancia vertical entre acorde y letra (`chordToLyricSpacing`, por defecto `2.0`).

## 1.2.2

* **Soporte Completo de Internacionalización (i18n / Localización)**:
  * Se restauraron y ampliaron los parámetros `title`, `interactiveWheelLabel` y `summaryViewLabel` en `CircleOfFifthsSheet.show(...)` y en su constructor, permitiendo pasar directamente los strings de idioma personalizados.
  * Nueva clase `CircleOfFifthsLabels` con método `.copyWith(...)` para configurar y traducir todas las etiquetas de la suite (modos, acordes, transpositor, inspector, progresiones).
  * Incluye configuración predefinida en español con `CircleOfFifthsLabels.spanish`.
  * Integración del parámetro opcional `labels` en `ScaleDetailCard`, `ChordSheetViewer`, `ChordInspectorSheet`, `ProgressionBuilderWidget` y `ScaleModesWidget`.

## 1.2.1

* Optimized `pubspec.yaml` description length for search engines and pub.dev score guidelines.
* Updated funding links to ensure 100% reachable status on automated bot validations.
* Restored 160/160 Pub Points.

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
