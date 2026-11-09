# 🎼 ProgressionBuilderWidget

El widget **`ProgressionBuilderWidget`** es un laboratorio interactivo para el análisis, construcción y reproducción rítmica de progresiones armónicas en números romanos diatónicos (`I`, `ii`, `IV`, `V`, etc.), totalmente conectado con la tonalidad activa.

---

## 🎯 Características Principales

1. **Plantillas Armónicas Populares Incluidas**:
   * *Axis of Awesome / Pop Pop*: `I - V - vi - IV`
   * *Jazz Estándar*: `ii - V - I`
   * *12-Bar Blues*: Estructura tradicional de blues de 12 compases con acordes dominantes 7ma.
   * *Canon de Pachelbel*: `I - V - vi - iii - IV - I - IV - V`
   * *Doo-Wop 50s*: `I - vi - IV - V`
   * *Cadencia Andaluza / Flamenco*: `i - VII - VI - V`
2. **Análisis en Números Romanos**:
   * Traduce automáticamente cada grado numérico al acorde real correspondiente a la tonalidad activa (ejemplo: en `C`, `I` = `C`, `V` = `G`; en `G`, `I` = `G`, `V` = `D`).
3. **Acordes de Paso y Modulaciones Sugeridas**:
   * Sugiere acordes de intercambio modal y dominantes secundarios (`V/V`, `V/vi`, acordes prestados).
4. **Reproductor Rítmico Secuencial**:
   * Incluye controles para reproducir la progresión compás a compás con síntesis de audio integrada, permitiendo escuchar cómo resuelve armónicamente.
5. **Inspección de Digitaciones al Tocar**:
   * Cada acorde de la progresión puede tocarse para abrir sus diagramas de digitación para Guitarra, Ukelele y Piano.
6. **Localización e Idioma (i18n)**:
   * Totalmente compatible con [`CircleOfFifthsLabels`](file:///C:/Users/ingej/StudioProjects/flutter_circle_of_fifths/lib/src/theme/circle_of_fifths_labels.dart) para traducir las sugerencias, categorías y botones.

---

## ⚙️ Tabla de Propiedades

| Parámetro | Tipo | Valor por Defecto | Descripción |
| :--- | :--- | :--- | :--- |
| **`activeKey`** | `String` | `'C'` | Tonalidad armónica de referencia para calcular los acordes (ej: `'C'`, `'G'`, `'Eb'`). |
| **`showKeySelector`** | `bool` | `true` | Muestra un selector desplegable para cambiar la tonalidad directamente desde el widget. |
| **`labels`** | `CircleOfFifthsLabels` | `CircleOfFifthsLabels()` | Configuración de etiquetas y traducciones de la interfaz. |
| **`onChordTap`** | `ValueChanged<String>?` | `null` | Callback ejecutado cuando el usuario pulsa un acorde específico de la progresión. |

---

## 💻 Ejemplos de Uso

### 1. Integración en Pantalla de Composición

```dart
import 'package:flutter/material.dart';
import 'package:flutter_circle_of_fifths/flutter_circle_of_fifths.dart';

class ProgressionDemoPage extends StatelessWidget {
  const ProgressionDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Creador de Progresiones')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: ProgressionBuilderWidget(
          activeKey: 'D',
          labels: CircleOfFifthsLabels.spanish,
          onChordTap: (chord) {
            debugPrint('Acorde presionado: $chord');
          },
        ),
      ),
    );
  }
}
```
