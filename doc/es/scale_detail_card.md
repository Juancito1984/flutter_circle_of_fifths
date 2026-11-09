# 🎴 ScaleDetailCard

El widget **`ScaleDetailCard`** es una tarjeta informativa completa y modular que desglosa la anatomía teórica de la escala diatónica seleccionada, sus grados, armadura de clave y acordes resultantes.

---

## 🎯 Características Principales

1. **Desglose de los 7 Grados Diatónicos**:
   * Presenta las notas numeradas del **I al VII** con la fórmula interválica en tonos y semitonos (T-T-S-T-T-T-S).
2. **Identificación de Calidad Armónica**:
   * Distingue visualmente entre acordes mayores, menores y disminuidos correspondientes a cada grado armónico.
3. **Inspección de Acordes al Tocar (`enableChordTap`)**:
   * Al pulsar sobre cualquiera de los grados, despliega automáticamente el modal de digitaciones ([`ChordInspectorSheet`](chord_inspector_sheet.md)) para Guitarra, Ukelele y Piano.
4. **Teclado de Piano Opcional (`showPianoScale`)**:
   * Puede incrustar un mini-teclado interactivo de piano que resalta las notas diatónicas de la escala y expone toques interactivos en las teclas.
5. **Soporte para Modo Menor Relativo**:
   * Al cambiar `isMinorMode: true`, adapta las notas, grados y fórmulas para la escala menor natural.

---

## ⚙️ Tabla de Propiedades

| Parámetro | Tipo | Valor por Defecto | Descripción |
| :--- | :--- | :--- | :--- |
| **`model`** *(requerido)* | `CircleOfFifthsModel` | — | Modelo de datos de la tonalidad actual (proporciona notas, tónica, relativo menor y armadura). |
| **`isMinorMode`** | `bool` | `false` | Indica si se debe mostrar la escala Mayor (`false`) o la escala Menor Relativa (`true`). |
| **`showPianoScale`** | `bool` | `false` | Renderiza un teclado visual interactivo de piano resaltando las notas de la escala. |
| **`enableChordTap`** | `bool` | `true` | Habilita pulsar los grados para inspeccionar sus diagramas de digitaciones en instrumentos. |
| **`labels`** | `CircleOfFifthsLabels` | `CircleOfFifthsLabels()` | Textos y traducciones para encabezados (ej: `labels.scaleFormula`, `labels.degreeNumbers`). |

---

## 💻 Ejemplos de Uso

### 1. Uso Estándar en Pantalla

```dart
import 'package:flutter/material.dart';
import 'package:flutter_circle_of_fifths/flutter_circle_of_fifths.dart';

class ScalePage extends StatelessWidget {
  const ScalePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Tomamos como ejemplo la tonalidad de Sol Mayor (G)
    final modelG = CircleOfFifthsModel.defaultKeys[1];

    return Scaffold(
      appBar: AppBar(title: const Text('Escala de Sol Mayor')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ScaleDetailCard(
          model: modelG,
          isMinorMode: false,
          showPianoScale: true, // Muestra el teclado con las notas iluminadas
          labels: CircleOfFifthsLabels.spanish,
        ),
      ),
    );
  }
}
```
