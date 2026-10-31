import 'package:flutter/material.dart';
import 'package:flutter_circle_of_fifths/flutter_circle_of_fifths.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Circle of Fifths Demo',
      themeMode: ThemeMode.system,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff216971),
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff216971),
          brightness: Brightness.dark,
        ),
      ),
      home: const DemoHomePage(),
    );
  }
}

class DemoHomePage extends StatefulWidget {
  const DemoHomePage({super.key});

  @override
  State<DemoHomePage> createState() => _DemoHomePageState();
}

class _DemoHomePageState extends State<DemoHomePage> {
  int _selectedIndex = 0;
  bool _isMinorMode = false;

  @override
  Widget build(BuildContext context) {
    final selectedModel = CircleOfFifthsModel.defaultKeys[_selectedIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Circle of Fifths'),
        centerTitle: true,
      ),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          CircleOfFifthsSheet.show(context);
        },
        icon: const Icon(Icons.adjust_rounded),
        label: const Text('Open Modal Sheet'),
      ),
    );
  }
}
