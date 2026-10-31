import 'package:flutter/material.dart';
import 'package:flutter_circle_of_fifths/flutter_circle_of_fifths.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.dark
          ? ThemeMode.light
          : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Circle of Fifths v1.1.0 Demo',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
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
      home: DemoHomePage(onToggleTheme: _toggleTheme),
    );
  }
}

class DemoHomePage extends StatefulWidget {
  final VoidCallback onToggleTheme;

  const DemoHomePage({super.key, required this.onToggleTheme});

  @override
  State<DemoHomePage> createState() => _DemoHomePageState();
}

class _DemoHomePageState extends State<DemoHomePage> {
  int _selectedIndex = 0; // 0 = 'C'
  bool _isMinorMode = false;
  HarmonicProgression? _activeProgression;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final selectedModel = CircleOfFifthsModel.defaultKeys[_selectedIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Circle of Fifths v1.1.0'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode_rounded
                  : Icons.dark_mode_rounded,
            ),
            onPressed: widget.onToggleTheme,
            tooltip: 'Toggle Theme',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Instructions Banner
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.touch_app_rounded, color: colorScheme.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Tap any sector or drag in circles to rotate. Try selecting harmonic progressions below!',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Harmonic Progression Filter Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  FilterChip(
                    selected: _activeProgression == null,
                    label: const Text('None'),
                    onSelected: (_) {
                      setState(() {
                        _activeProgression = null;
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  ...HarmonicProgression.defaultProgressions.map((prog) {
                    final isSelected = _activeProgression?.id == prog.id;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        selected: isSelected,
                        label: Text('${prog.name} (${prog.formula})'),
                        onSelected: (selected) {
                          setState(() {
                            _activeProgression = selected ? prog : null;
                          });
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Interactive Circle of Fifths Wheel
            CircleOfFifthsWheelWidget(
              selectedIndex: _selectedIndex,
              isMinorMode: _isMinorMode,
              activeProgression: _activeProgression,
              onKeySelected: (index, isMinor) {
                setState(() {
                  _selectedIndex = index;
                  _isMinorMode = isMinor;
                });
              },
            ),
            const SizedBox(height: 20),

            // Scale Detail Card
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
