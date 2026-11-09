import 'package:flutter/material.dart';
import 'package:flutter_circle_of_fifths/flutter_circle_of_fifths.dart';

void main() {
  runApp(const CircleOfFifthsApp());
}

/// Demonstration app exhibiting all features of the [flutter_circle_of_fifths] suite.
class CircleOfFifthsApp extends StatelessWidget {
  /// Creates the root demonstration application widget.
  const CircleOfFifthsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Circle of Fifths Musical Suite',
      debugShowCheckedModeBanner: false,
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
      home: const MainMusicStudioScreen(),
    );
  }
}

/// Multi-screen musical studio demo showcasing all 5 modules.
class MainMusicStudioScreen extends StatefulWidget {
  /// Creates the main demo screen with navigation bar.
  const MainMusicStudioScreen({super.key});

  @override
  State<MainMusicStudioScreen> createState() => _MainMusicStudioScreenState();
}

class _MainMusicStudioScreenState extends State<MainMusicStudioScreen> {
  int _currentNavIndex = 0;
  int _selectedKeyIndex = 0; // 0 = 'C'
  bool _isMinorMode = false;

  static const String _sampleSong = '''
{title: Amazing Grace}
{subtitle: Traditional Hymn - Arranged in ChordPro}
{key: C}

[Verse 1]
[C]Amazing [C7]grace, how [F]sweet the [C]sound
That [C]saved a [Am]wretch like [G7]me!
I [C]once was [C7]lost, but [F]now am [C]found,
Was [Am]blind, but [G7]now I [C]see.

[Chorus]
'Twas [C]grace that [C/E]taught my [F]heart to [C]fear,
And [Dm7]grace my [G7]fears re[C]lieved;
How [C]precious [C7]did that [F]grace ap[Am]pear
The [Dm7]hour I [G7]first be[C]lieved!

[Bridge]
Through [F]many [C/E]dangers, [Dm7]toils and [C]snares
I [Am]have al[D7]ready [G7]come;
'Tis [C]grace hath [C7]brought me [F]safe thus [C]far,
And [Am]grace will [G7]lead me [C]home.
''';

  @override
  Widget build(BuildContext context) {
    final selectedModel = CircleOfFifthsModel.defaultKeys[_selectedKeyIndex];
    final activeKey =
        _isMinorMode ? selectedModel.minor.toUpperCase() : selectedModel.major;

    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitleForIndex(_currentNavIndex)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.open_in_browser_rounded),
            tooltip: 'Open Modal Circle Sheet',
            onPressed: () => CircleOfFifthsSheet.show(context),
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentNavIndex,
        children: [
          // 1. Core: Wheel & Diatonic Scale Card
          _buildWheelAndScaleScreen(selectedModel),

          // 2. Module 1: Chord Sheet Viewer & Transposition
          _buildSongSheetScreen(selectedModel),

          // 3. Module 2: Instrument Chord Diagrams (Guitar, Ukulele, Piano)
          _buildInstrumentDiagramsScreen(activeKey),

          // 4. Module 3: Harmonic Progression Builder & Roman Numerals
          _buildProgressionBuilderScreen(selectedModel.major),

          // 5. Module 4: Gregorian Modes & Advanced Scales
          _buildScaleModesScreen(selectedModel.major),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentNavIndex,
        onDestinationSelected: (idx) {
          setState(() {
            _currentNavIndex = idx;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.adjust_outlined),
            selectedIcon: Icon(Icons.adjust_rounded),
            label: 'Wheel',
          ),
          NavigationDestination(
            icon: Icon(Icons.queue_music_outlined),
            selectedIcon: Icon(Icons.queue_music_rounded),
            label: 'Song Sheet',
          ),
          NavigationDestination(
            icon: Icon(Icons.piano_outlined),
            selectedIcon: Icon(Icons.piano_rounded),
            label: 'Diagrams',
          ),
          NavigationDestination(
            icon: Icon(Icons.format_list_numbered_rtl_rounded),
            selectedIcon: Icon(Icons.format_list_numbered_rounded),
            label: 'Progression',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_awesome_outlined),
            selectedIcon: Icon(Icons.auto_awesome_rounded),
            label: 'Modes',
          ),
        ],
      ),
    );
  }

  String _getTitleForIndex(int index) {
    switch (index) {
      case 0:
        return 'Circle of Fifths';
      case 1:
        return 'Song & Transposer';
      case 2:
        return 'Instrument Diagrams';
      case 3:
        return 'Harmonic Progressions';
      case 4:
        return 'Modes & Scales';
      default:
        return 'Music Studio';
    }
  }

  // 1. Wheel Screen
  Widget _buildWheelAndScaleScreen(CircleOfFifthsModel selectedModel) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          CircleOfFifthsWheelWidget(
            customTheme: const CircleOfFifthsTheme(
              centerLabel: 'ARB',
            ),
            selectedIndex: _selectedKeyIndex,
            isMinorMode: _isMinorMode,
            onKeySelected: (index, isMinor) {
              setState(() {
                _selectedKeyIndex = index;
                _isMinorMode = isMinor;
              });
            },
          ),
          const SizedBox(height: 20),
          ScaleDetailCard(
            labels: CircleOfFifthsLabels.spanish,
            model: selectedModel,
            isMinorMode: _isMinorMode,
            showPianoScale: true,
          ),
        ],
      ),
    );
  }

  // 2. Song Sheet Screen
  Widget _buildSongSheetScreen(CircleOfFifthsModel selectedModel) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: ChordSheetViewer(
        showChords: false,
        lineSpacing: 4,
        stanzaSpacing: 20,
        songText: _sampleSong,
        originalKey: 'C',
        targetKey: selectedModel.major,
      ),
    );
  }

  // 3. Instrument Diagrams Screen
  Widget _buildInstrumentDiagramsScreen(String activeKey) {
    final chordInfo = ChordTransposer.parseChord(
      _isMinorMode ? '${activeKey}m' : activeKey,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Interactive Chord Inspector',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            'Explore full fingerings for Guitar, Ukulele, and Piano:',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 16),
          ChordInspectorSheet(
            chordInfo: chordInfo,
          ),
        ],
      ),
    );
  }

  // 4. Progression Builder Screen
  Widget _buildProgressionBuilderScreen(String activeKey) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: ProgressionBuilderWidget(
        activeKey: activeKey,
      ),
    );
  }

  // 5. Modes & Scales Screen
  Widget _buildScaleModesScreen(String activeKey) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: ScaleModesWidget(
        rootNote: activeKey,
      ),
    );
  }
}
