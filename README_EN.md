# flutter_circle_of_fifths (English)

An interactive, customizable, Material 3 **Circle of Fifths** widget library for Flutter. Supports Major and Minor modes, diatonic scale breakdown, dark/light theme adaptation, and touch-based circular navigation.

[![pub package](https://img.shields.io/pub/v/flutter_circle_of_fifths.svg)](https://pub.dev/packages/flutter_circle_of_fifths)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Flutter](https://img.shields.io/badge/Flutter-%3E%3D3.10.0-02569B?logo=flutter)](https://flutter.dev)

---

🌐 **Languages / Idiomas**: [Español](README_ES.md) | [English](README_EN.md)

---

## ☕ Support the Project

If this package has been helpful and you'd like to support its ongoing development and maintenance, feel free to contribute:

- 💳 **PayPal**: [paypal.me/NyKservice](https://paypal.me/NyKservice)
- 🅿️ **Patreon**: [patreon.com/JuanPabloGosalvez](https://www.patreon.com/c/JuanPabloGosalvez)

Your support is greatly appreciated to keep this project 100% free, open-source, and constantly evolving!

---

## 🌟 Features

- 🎡 **Interactive 12-Sector Wheel**: Tap outer ring for Major keys or middle ring for Relative Minor keys.
- 🔄 **Dynamic 12:00 Rotation**: Smoothly centers the active key at top position.
- 🎨 **Material 3 Theme Adaptive**: Automatically inherits application Light & Dark theme colors using modern `.withValues(alpha: ...)` API.
- 🎵 **Diatonic Scale Breakdown**: Shows Major and Natural Minor scale formulas (`2-2-1-2-2-2-1` and `2-1-2-2-1-2-2`), note degree numbers (1-8), and chord variations.
- 🌈 **Degree Highlight Colors**: Distinct semantic highlights for Tonic ($I / i$), Subdominant ($IV / iv$), Dominant ($V / v$), and Diminished ($vii^\circ / ii^\circ$).
- 🏷️ **Customizable Theme & Logo**: Set custom brand text (e.g. `'NyK'`) or degree colors via `CircleOfFifthsTheme`.
- 📱 **Modal BottomSheet Ready**: Display as a bottom sheet with interactive wheel and summary grid modes in a single function call.

---

## 🚀 Getting Started

Add the dependency to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_circle_of_fifths: ^1.1.1
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
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  int _selectedIndex = 0; // 0 = 'C'
  bool _isMinorMode = false;

  @override
  Widget build(BuildContext context) {
    final selectedModel = CircleOfFifthsModel.defaultKeys[_selectedIndex];

    return Scaffold(
      appBar: AppBar(title: const Text('Circle of Fifths')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
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
            const SizedBox(height: 20),
            ScaleDetailCard(
              model: selectedModel,
              isMinorMode: _isMinorMode,
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 🎨 Custom Theme Configuration

Customize colors and brand center text easily:

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

## 📂 Project Structure

```
lib/
├── flutter_circle_of_fifths.dart       # Main package exports
└── src/
    ├── models/
    │   └── circle_of_fifths_model.dart # Music theory model & 12 key definitions
    ├── theme/
    │   └── circle_of_fifths_theme.dart # Color palette & label configuration
    └── widgets/
        ├── circle_of_fifths_sheet.dart # Draggable Modal Sheet with Wheel & Summary Grid
        ├── circle_of_fifths_wheel.dart # Interactive Canvas Wheel widget
        └── scale_detail_card.dart     # Diatonic scale breakdown card
```

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
