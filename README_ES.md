# flutter_circle_of_fifths (Español)

Una librería de widgets en Flutter interactiva, personalizable y adaptada a **Material 3** para representar el **Círculo de Quintas**. Soporta modos Mayor y Menor, desglose de escalas diatónicas, adaptación automática a temas claro/oscuro y navegación circular táctil.

[![pub package](https://img.shields.io/pub/v/flutter_circle_of_fifths.svg)](https://pub.dev/packages/flutter_circle_of_fifths)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Flutter](https://img.shields.io/badge/Flutter-%3E%3D3.10.0-02569B?logo=flutter)](https://flutter.dev)

---

🌐 **Idiomas / Languages**: [Español](README_ES.md) | [English](README_EN.md)

---

## ☕ Apoya el Proyecto

Si este paquete te ha sido útil y deseas apoyar su desarrollo y mantenimiento continuo, puedes contribuir a través de los siguientes enlaces:

- 💳 **PayPal**: [paypal.me/NyKservice](https://paypal.me/NyKservice)
- 🅿️ **Patreon**: [patreon.com/JuanPabloGosalvez](https://www.patreon.com/c/JuanPabloGosalvez)

¡Tu apoyo es enormemente apreciado para mantener este proyecto 100% gratuito, de código abierto y en constante evolución!

---

## 🌟 Características Principales

- 🎡 **Rueda Interactiva de 12 Sectores**: Toca el anillo exterior para tonalidades Mayores o el anillo medio para sus Menores Relativas.
- 🔄 **Rotación Dinámica a la Posición 12:00**: Centra suavemente la tonalidad activa en la parte superior.
- 🎨 **Adaptativo a Material 3**: Hereda de forma nativa la paleta de colores claro y oscuro de la aplicación utilizando la API moderna `.withValues(alpha: ...)`.
- 🎵 **Desglose de Escalas Diatónicas**: Muestra las fórmulas de tonos/semitonos de escalas Mayores y Menores Naturales (`2-2-1-2-2-2-1` y `2-1-2-2-1-2-2`), números de grado (1-8) y variaciones de acordes.
- 🌈 **Destacado Semántico de Grados**: Colores distintivos para la Tónica ($I / i$), Subdominante ($IV / iv$), Dominante ($V / v$) y Disminuido ($vii^\circ / ii^\circ$).
- 🏷️ **Personalización de Tema y Logotipo**: Configura un texto de marca en el centro (ej. `'NyK'`) o personaliza los colores mediante `CircleOfFifthsTheme`.
- 📱 **Modal BottomSheet Listo para Usar**: Se despliega como hoja modal con vista interactiva y vista en cuadrícula resumen mediante una sola línea de código.

---

## 🚀 Instalación

Agrega la dependencia en tu archivo `pubspec.yaml`:

```yaml
dependencies:
  flutter_circle_of_fifths: ^1.1.1
```

Ejecuta en la terminal:

```bash
flutter pub get
```

---

## 💻 Ejemplos de Uso

### 1. Desplegar como Modal BottomSheet (Una sola línea)

```dart
import 'package:flutter/material.dart';
import 'package:flutter_circle_of_fifths/flutter_circle_of_fifths.dart';

void abrirCirculoDeQuintas(BuildContext context) {
  CircleOfFifthsSheet.show(
    context,
    customTheme: const CircleOfFifthsTheme(
      centerLabel: 'NyK',
    ),
  );
}
```

---

### 2. Widget de Rueda Interactiva Independiente

```dart
import 'package:flutter/material.dart';
import 'package:flutter_circle_of_fifths/flutter_circle_of_fifths.dart';

class MiPagina extends StatefulWidget {
  const MiPagina({super.key});

  @override
  State<MiPagina> createState() => _MiPaginaState();
}

class _MiPaginaState extends State<MiPagina> {
  int _selectedIndex = 0; // 0 = 'C' (Do)
  bool _isMinorMode = false;

  @override
  Widget build(BuildContext context) {
    final selectedModel = CircleOfFifthsModel.defaultKeys[_selectedIndex];

    return Scaffold(
      appBar: AppBar(title: const Text('Círculo de Quintas')),
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

## 🎨 Configuración de Temas Personalizados

Puedes personalizar la paleta de colores y el texto central de la marca:

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

## 📂 Estructura del Proyecto

```
lib/
├── flutter_circle_of_fifths.dart       # Exportaciones principales del paquete
└── src/
    ├── models/
    │   └── circle_of_fifths_model.dart # Modelo teórico musical y 12 armaduras de clave
    ├── theme/
    │   └── circle_of_fifths_theme.dart # Paleta de colores y etiquetas de marca
    └── widgets/
        ├── circle_of_fifths_sheet.dart # Modal Sheet arrastrable con vista interactiva y resumen
        ├── circle_of_fifths_wheel.dart # Widget Canvas interativo de la rueda
        └── scale_detail_card.dart     # Tarjeta de desglose de escala diatónica
```

---

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Consulta el archivo [LICENSE](LICENSE) para más detalles.
