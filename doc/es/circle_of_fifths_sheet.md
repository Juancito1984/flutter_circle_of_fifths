# 📜 CircleOfFifthsSheet

El widget **`CircleOfFifthsSheet`** es un panel modal inferior deslizable (*Modal Bottom Sheet*) listo para usar que reúne la rueda interactiva ([`CircleOfFifthsWheelWidget`](file:///C:/Users/ingej/StudioProjects/flutter_circle_of_fifths/docs/circle_of_fifths_wheel.md)), la tarjeta detallada de la escala ([`ScaleDetailCard`](file:///C:/Users/ingej/StudioProjects/flutter_circle_of_fifths/docs/scale_detail_card.md)) y una vista resumen en cuadrícula.

---

## 🎯 Características Principales

1. **Apertura Rápida mediante Método Estático**:
   * Puede abrirse en cualquier momento con `CircleOfFifthsSheet.show(context)`.
2. **Selector de Vistas con Pestañas (*Segmented Tabs*)**:
   * **Rueda Interactiva**: Para rotar y explorar visualmente las relaciones armónicas.
   * **Vista Resumen**: Cuadrícula con las 12 tonalidades, sus armaduras de clave y relativos menores para consulta rápida.
3. **Tarjeta de Escala Integrada**:
   * Debajo de la rueda muestra automáticamente el desglose de grados (I al VII), acordes y piano.
4. **Localización e Idiomas Sencillos**:
   * Permite pasar directamente cadenas para `title`, `interactiveWheelLabel` y `summaryViewLabel`, o bien un objeto completo [`CircleOfFifthsLabels`](file:///C:/Users/ingej/StudioProjects/flutter_circle_of_fifths/lib/src/theme/circle_of_fifths_labels.dart) como `CircleOfFifthsLabels.spanish`.
5. **Comportamiento Deslizable Responsivo**:
   * Basado en `DraggableScrollableSheet` con tamaños configurados para pantallas de teléfonos y tabletas.

---

## ⚙️ Tabla de Propiedades

### Parámetros del Constructor y de `CircleOfFifthsSheet.show(...)`

| Parámetro | Tipo | Valor por Defecto | Descripción |
| :--- | :--- | :--- | :--- |
| **`customTheme`** | `CircleOfFifthsTheme` | `CircleOfFifthsTheme()` | Configuración estética personalizada (colores de selección, texto central de marca, etc.). |
| **`labels`** | `CircleOfFifthsLabels` | `CircleOfFifthsLabels()` | Objeto de localización con todos los textos traducibles de la suite. |
| **`title`** | `String?` | `null` | Título superior del modal. Si no se especifica, toma `labels.title`. |
| **`interactiveWheelLabel`** | `String?` | `null` | Etiqueta de la pestaña de la rueda interactiva. Si no se especifica, toma `labels.interactiveWheelLabel`. |
| **`summaryViewLabel`** | `String?` | `null` | Etiqueta de la pestaña resumen. Si no se especifica, toma `labels.summaryViewLabel`. |
| **`onKeySelected`** | `ValueChanged<String>?` | `null` | Callback que notifica la tonalidad seleccionada (ej: `'C'`, `'G'`, `'Am'`). |

---

## 💻 Ejemplos de Uso

### 1. Invocación Directa con `CircleOfFifthsSheet.show(...)`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_circle_of_fifths/flutter_circle_of_fifths.dart';

void openCircleSheet(BuildContext context) {
  CircleOfFifthsSheet.show(
    context,
    title: 'Círculo de Quintas',
    labels: CircleOfFifthsLabels.spanish,
    onKeySelected: (selectedKey) {
      debugPrint('Tonalidad seleccionada: $selectedKey');
    },
  );
}
```

---

### 2. Uso Incrustado en un Layout como Widget

```dart
CircleOfFifthsSheet(
  labels: CircleOfFifthsLabels.spanish,
  onKeySelected: (key) {
    setState(() => _currentKey = key);
  },
)
```
