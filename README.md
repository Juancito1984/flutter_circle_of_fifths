# flutter_circle_of_fifths

An interactive, customizable, Material 3 **Circle of Fifths** widget library for Flutter. Supports Major and Minor modes, diatonic scale breakdown, dark/light theme adaptation, and touch-based circular navigation.

[![pub package](https://img.shields.io/pub/v/flutter_circle_of_fifths.svg)](https://pub.dev/packages/flutter_circle_of_fifths)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

---

## 🌟 Features

- **Interactive 12-Sector Wheel**: Tap outer ring for Major keys or inner ring for Relative Minor keys.
- **Dynamic 12:00 Rotation**: Smoothly centers the active key at top.
- **Material 3 Theme Adaptive**: Automatically inherits application Light & Dark theme colors.
- **Diatonic Scale Breakdown**: Shows Major and Natural Minor scale formulas (`2-2-1-2-2-2-1` and `2-1-2-2-1-2-2`).
- **Degree Highlight Colors**: Distinct semantic highlights for Tonic ($I / i$), Subdominant ($IV / iv$), Dominant ($V / v$), and Diminished ($vii^\circ / ii^\circ$).
- **Customizable Center Logo**: Brand text (e.g. `'NyK'`) or custom colors via `CircleOfFifthsTheme`.

---

## 🚀 Getting Started

Add the dependency to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_circle_of_fifths: ^1.0.0
```

Run:

```bash
flutter pub get
```

---

## 💻 Usage

### 1. Show as a Modal BottomSheet (One Line)

```dart
import 'package:flutter/material.dart';
import 'package:flutter_circle_of_fifths/flutter_circle_of_fifths.dart';

void openCircleOfFifths(BuildContext context) {
  CircleOfFifthsSheet.show(
    context,
    customTheme: const CircleOfFifthsTheme(
      centerLabel: 'NyK',
    ),
  );
}
```

---

### 2. Standalone Interactive Wheel Widget

```dart
import 'package:flutter/material.dart';
import 'package:flutter_circle_of_fifths/flutter_circle_of_fifths.dart';

class MyPage extends StatefulWidget {
  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  int _selectedIndex = 0; // 0 = 'C'
  bool _isMinorMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Circle of Fifths')),
      body: Column(
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
          ScaleDetailCard(
            model: CircleOfFifthsModel.defaultKeys[_selectedIndex],
            isMinorMode: _isMinorMode,
          ),
        ],
      ),
    );
  }
}
```

---

## 🎨 Custom Theme Configuration

Customize colors and brand center text:

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

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
