# 🎡 CircleOfFifthsWheelWidget

The **`CircleOfFifthsWheelWidget`** is the core visual component of the library. It draws an interactive Circle of Fifths using high-precision vector geometry via `CustomPainter`, highlighting key signatures, diatonic degrees, and auto-rotating the active key to 12:00.

---

## 🎯 Key Features

1. **High-Precision Vector Painting**: Crisp rendering at any device pixel ratio using `CustomPainter` with zero external image assets.
2. **Major and Relative Minor Dual Rings**:
   * **Outer Ring**: 12 sectors for Major keys (`C`, `G`, `D`, etc.).
   * **Inner Ring**: 12 sectors for Relative Minor keys (`Am`, `Em`, `Bm`, etc.).
   * **Center Core**: Displays brand label or suite title configured in the theme.
3. **Diatonic Family Highlighting**:
   * Selecting any key (e.g., `C`) automatically highlights its 6 harmonic neighbor keys: Tonic (`I`), Subdominant (`IV`), Dominant (`V`), and their relative minors (`ii`, `iii`, `vi`).
4. **Auto-Rotation to 12:00 Position**:
   * The selected key smoothly rotates to the top, making fifth and fourth relationships instantly intuitive.
5. **Polar Tap Discrimination**:
   * Angular and radial calculations accurately detect whether the user tapped a Major key or its Relative Minor.

---

## ⚙️ Properties Table

| Parameter | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| **`selectedIndex`** *(required)* | `int` | — | Index of the selected key (`0` = C, `1` = G, `2` = D, ..., `11` = F). |
| **`isMinorMode`** *(required)* | `bool` | — | `false` if Major key is active; `true` if Relative Minor is active. |
| **`onKeySelected`** *(required)* | `Function(int index, bool isMinor)` | — | Callback triggered when a key sector is tapped. Returns key index and minor mode flag. |
| **`customTheme`** | `CircleOfFifthsTheme` | `CircleOfFifthsTheme()` | Styling configuration (selection colors, diatonic family accents, text colors, and center label). |

---

## 💻 Code Examples

### 1. Integration in a StatefulWidget

```dart
import 'package:flutter/material.dart';
import 'package:flutter_circle_of_fifths/flutter_circle_of_fifths.dart';

class WheelDemoPage extends StatefulWidget {
  const WheelDemoPage({super.key});

  @override
  State<WheelDemoPage> createState() => _WheelDemoPageState();
}

class _WheelDemoPageState extends State<WheelDemoPage> {
  int _currentIndex = 0; // C Major
  bool _isMinor = false;

  @override
  Widget build(BuildContext context) {
    final selectedKey = CircleOfFifthsModel.defaultKeys[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Key: ${_isMinor ? selectedKey.minor : selectedKey.major}'),
      ),
      body: Center(
        child: SizedBox(
          width: 320,
          height: 320,
          child: CircleOfFifthsWheelWidget(
            selectedIndex: _currentIndex,
            isMinorMode: _isMinor,
            onKeySelected: (index, isMinor) {
              setState(() {
                _currentIndex = index;
                _isMinor = isMinor;
              });
            },
          ),
        ),
      ),
    );
  }
}
```
