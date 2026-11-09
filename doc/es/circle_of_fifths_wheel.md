# 🎡 CircleOfFifthsWheelWidget

El widget **`CircleOfFifthsWheelWidget`** es el componente visual central de la librería. Dibuja un Círculo de Quintas interactivo mediante un `CustomPainter` de alta precisión geométrica y vectorial, calculando los sectores cromáticos, resaltando armaduras de clave y grados armónicos, y rotando la tonalidad activa a la cúspide (posición 12:00).

---

## 🎯 Características Principales

1. **Diseño Vectorial de Alta Precisión**: Renderizado nítido en cualquier resolución mediante `CustomPainter` sin imágenes pesadas.
2. **Anillos Mayor y Menor Relativo**:
   * **Anillo Exterior**: 12 sectores para las tonalidades mayores (`C`, `G`, `D`, etc.).
   * **Anillo Intermedio**: 12 sectores para las tonalidades menores relativas (`Am`, `Em`, `Bm`, etc.).
   * **Núcleo Central**: Muestra el nombre de la suite o etiqueta personalizada configurada en el tema.
3. **Resaltado de Grados Armónicos Diatónicos**:
   * Al seleccionar una tonalidad (por ejemplo, `C`), resalta automáticamente las tonalidades vecinas que forman la familia armónica diatónica: la Tónica (`I`), Subdominante (`IV`), Dominante (`V`), y sus relativos menores (`ii`, `iii`, `vi`).
4. **Rotación Dinámica a las 12:00**:
   * La tonalidad seleccionada rota hacia la parte superior, permitiendo comprender de forma intuitiva las relaciones de quintas a la derecha y cuartas a la izquierda.
5. **Detección Geométrica de Toques**:
   * Discrimina con precisión angular y de radio si el usuario pulsó en una tonalidad mayor o en su relativo menor.

---

## ⚙️ Tabla de Propiedades

| Parámetro | Tipo | Valor por Defecto | Descripción |
| :--- | :--- | :--- | :--- |
| **`selectedIndex`** *(requerido)* | `int` | — | Índice de la tonalidad seleccionada (`0` = C, `1` = G, `2` = D, ..., `11` = F). |
| **`isMinorMode`** *(requerido)* | `bool` | — | `false` si la tonalidad principal activa es Mayor; `true` si se seleccionó el modo Menor relativo. |
| **`onKeySelected`** *(requerido)* | `Function(int index, bool isMinor)` | — | Callback invocado cuando el usuario pulsa un sector. Entrega el índice (`0`..`11`) y si es menor (`bool`). |
| **`customTheme`** | `CircleOfFifthsTheme` | `CircleOfFifthsTheme()` | Objeto de configuración estética (colores primarios, secundarios, bordes, tipografía y texto de marca central). |

---

## 💻 Ejemplos de Uso

### 1. Integración en un StatefulWidget

```dart
import 'package:flutter/material.dart';
import 'package:flutter_circle_of_fifths/flutter_circle_of_fifths.dart';

class WheelDemoPage extends StatefulWidget {
  const WheelDemoPage({super.key});

  @override
  State<WheelDemoPage> createState() => _WheelDemoPageState();
}

class _WheelDemoPageState extends State<WheelDemoPage> {
  int _currentIndex = 0; // C mayor por defecto
  bool _isMinor = false;

  @override
  Widget build(BuildContext context) {
    final selectedKey = CircleOfFifthsModel.defaultKeys[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Tonalidad: ${_isMinor ? selectedKey.minor : selectedKey.major}'),
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

---

### 2. Personalización de Colores con `CircleOfFifthsTheme`

```dart
CircleOfFifthsWheelWidget(
  selectedIndex: _currentIndex,
  isMinorMode: _isMinor,
  onKeySelected: (index, isMinor) {
    setState(() {
      _currentIndex = index;
      _isMinor = isMinor;
    });
  },
  customTheme: const CircleOfFifthsTheme(
    brandTitle: 'MI APP',
    primarySelectedColor: Colors.deepPurple,
    diatonicFamilyColor: Colors.purpleAccent,
    textColor: Colors.white,
  ),
)
```
