# 📜 CircleOfFifthsSheet

The **`CircleOfFifthsSheet`** widget is a turnkey Draggable Modal Bottom Sheet combining the interactive wheel ([`CircleOfFifthsWheelWidget`](circle_of_fifths_wheel.md)), diatonic scale overview card ([`ScaleDetailCard`](scale_detail_card.md)), and a structured summary grid.

---

## 🎯 Key Features

1. **One-Line Static Opener**:
   * Open the sheet effortlessly from any widget context using `CircleOfFifthsSheet.show(context)`.
2. **Segmented Tab Views**:
   * **Interactive Wheel**: Rotatable canvas for visual harmonic discovery.
   * **Summary View**: Structured 12-key grid with accidentals and relative minors for rapid reference.
3. **Integrated Scale Card**:
   * Seamlessly embeds the degree breakdown, Roman numerals, and piano keybed below the wheel.
4. **Localization-Ready (i18n)**:
   * Pass custom titles and tab labels directly or provide a complete [`CircleOfFifthsLabels`](../../lib/src/theme/circle_of_fifths_labels.dart) instance.

---

## ⚙️ Properties Table

### Constructor & `CircleOfFifthsSheet.show(...)` Parameters

| Parameter | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| **`customTheme`** | `CircleOfFifthsTheme` | `CircleOfFifthsTheme()` | Styling configuration for wheel colors and center branding. |
| **`labels`** | `CircleOfFifthsLabels` | `CircleOfFifthsLabels()` | Localization instance for all labels and button strings. |
| **`title`** | `String?` | `null` | Header title of the bottom sheet. Defaults to `labels.title`. |
| **`interactiveWheelLabel`** | `String?` | `null` | Tab label for the interactive wheel. Defaults to `labels.interactiveWheelLabel`. |
| **`summaryViewLabel`** | `String?` | `null` | Tab label for the summary grid. Defaults to `labels.summaryViewLabel`. |
| **`onKeySelected`** | `ValueChanged<String>?` | `null` | Callback notifying key selection (e.g., `'C'`, `'G'`, `'Am'`). |

---

## 💻 Code Examples

### 1. Show Modal Sheet from an Action

```dart
import 'package:flutter/material.dart';
import 'package:flutter_circle_of_fifths/flutter_circle_of_fifths.dart';

void openCircleSheet(BuildContext context) {
  CircleOfFifthsSheet.show(
    context,
    title: 'Circle of Fifths',
    onKeySelected: (selectedKey) {
      debugPrint('Key chosen: $selectedKey');
    },
  );
}
```
