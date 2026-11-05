import 'package:flutter/material.dart';
import '../models/circle_of_fifths_model.dart';
import '../theme/circle_of_fifths_theme.dart';
import 'circle_of_fifths_wheel.dart';
import 'scale_detail_card.dart';

/// Ready-to-use Draggable Modal BottomSheet for displaying the Circle of Fifths.
class CircleOfFifthsSheet extends StatefulWidget {
  /// Custom theme configuration for colors and center brand label.
  final CircleOfFifthsTheme customTheme;

  /// Creates a [CircleOfFifthsSheet] bottom sheet widget.
  const CircleOfFifthsSheet({
    super.key,
    this.customTheme = const CircleOfFifthsTheme(),
  });

  /// Static helper to display the sheet easily from any BuildContext.
  static void show(
    BuildContext context, {
    CircleOfFifthsTheme customTheme = const CircleOfFifthsTheme(),
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => CircleOfFifthsSheet(customTheme: customTheme),
    );
  }

  @override
  State<CircleOfFifthsSheet> createState() => _CircleOfFifthsSheetState();
}

class _CircleOfFifthsSheetState extends State<CircleOfFifthsSheet> {
  int _selectedView = 0; // 0: Interactive Wheel, 1: Summary Grid
  int _selectedIndex = 0; // Selected Key Index (0 = 'C')
  bool _isMinorMode = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final selectedModel = CircleOfFifthsModel.defaultKeys[_selectedIndex];

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: ListView(
            controller: scrollController,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Header
              Row(
                children: [
                  Icon(
                    Icons.adjust_rounded,
                    color: colorScheme.primary,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Circle of Fifths',
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // View Selector (SegmentedButton)
              SegmentedButton<int>(
                segments: const [
                  ButtonSegment(
                    value: 0,
                    label: Text('Interactive Wheel'),
                    icon: Icon(Icons.incomplete_circle_rounded),
                  ),
                  ButtonSegment(
                    value: 1,
                    label: Text('Summary View'),
                    icon: Icon(Icons.grid_view_rounded),
                  ),
                ],
                selected: {_selectedView},
                onSelectionChanged: (newSelection) {
                  setState(() {
                    _selectedView = newSelection.first;
                  });
                },
              ),
              const SizedBox(height: 20),

              // VIEW 1: INTERACTIVE WHEEL
              if (_selectedView == 0) ...[
                CircleOfFifthsWheelWidget(
                  selectedIndex: _selectedIndex,
                  isMinorMode: _isMinorMode,
                  customTheme: widget.customTheme,
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
              ]

              // VIEW 2: SUMMARY GRID
              else ...[
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: CircleOfFifthsModel.defaultKeys.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.8,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    final item = CircleOfFifthsModel.defaultKeys[index];
                    final isSelected = index == _selectedIndex;

                    return InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        setState(() {
                          _selectedIndex = index;
                          _isMinorMode = false;
                          _selectedView = 0;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? colorScheme.primaryContainer
                              : colorScheme.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? colorScheme.primary
                                : colorScheme.outlineVariant
                                    .withValues(alpha: 0.5),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  item.major,
                                  style: textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: isSelected
                                        ? colorScheme.onPrimaryContainer
                                        : colorScheme.primary,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: colorScheme.secondaryContainer,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    item.minor,
                                    style: textTheme.labelSmall?.copyWith(
                                      color: colorScheme.onSecondaryContainer,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'IV: ${item.subdominant} | V: ${item.dominant}',
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}
