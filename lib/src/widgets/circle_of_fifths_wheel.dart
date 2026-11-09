import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/circle_of_fifths_model.dart';
import '../theme/circle_of_fifths_theme.dart';

/// Interactive Circle of Fifths wheel widget.
/// Rotates the selected key to the 12:00 position and highlights its 7 diatonic degrees.
class CircleOfFifthsWheelWidget extends StatefulWidget {
  /// Index of the currently selected key (0 = 'C', 1 = 'G', etc.).
  final int selectedIndex;

  /// Whether Minor mode (Relative Minor) is selected instead of Major mode.
  final bool isMinorMode;

  /// Callback triggered when a key sector or mode ring is tapped.
  final Function(int index, bool isMinor) onKeySelected;

  /// Custom theme configuration for colors and center brand label.
  final CircleOfFifthsTheme customTheme;

  /// Creates a [CircleOfFifthsWheelWidget] canvas wheel widget.
  const CircleOfFifthsWheelWidget({
    super.key,
    required this.selectedIndex,
    required this.isMinorMode,
    required this.onKeySelected,
    this.customTheme = const CircleOfFifthsTheme(),
  });

  @override
  State<CircleOfFifthsWheelWidget> createState() =>
      _CircleOfFifthsWheelWidgetState();
}

class _CircleOfFifthsWheelWidgetState extends State<CircleOfFifthsWheelWidget> {
  void _handleTap(Offset localPosition, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final dx = localPosition.dx - center.dx;
    final dy = localPosition.dy - center.dy;

    final r = math.sqrt(dx * dx + dy * dy);
    final radius = size.width / 2;
    final midRadius = radius * 0.70;
    final innerRadius = radius * 0.45;

    // Ignore taps outside the wheel or inside the center core
    if (r > radius || r < innerRadius) return;

    final isMinorTap = (r <= midRadius);

    final sectorAngle = (2 * math.pi) / 12;

    // Tap angle relative to top (12:00 position = -pi/2)
    double angleFromTop =
        math.atan2(dy, dx) - (-math.pi / 2) + (sectorAngle / 2);
    while (angleFromTop < 0) {
      angleFromTop += 2 * math.pi;
    }
    angleFromTop %= (2 * math.pi);

    final visSector = (angleFromTop / sectorAngle).floor() % 12;
    final targetIndex = (visSector + widget.selectedIndex) % 12;

    widget.onKeySelected(targetIndex, isMinorTap);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AspectRatio(
      aspectRatio: 1,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = Size(constraints.maxWidth, constraints.maxHeight);
          return GestureDetector(
            onTapDown: (details) => _handleTap(details.localPosition, size),
            child: CustomPaint(
              size: size,
              painter: _CircleOfFifthsPainter(
                selectedIndex: widget.selectedIndex,
                isMinorMode: widget.isMinorMode,
                colorScheme: colorScheme,
                customTheme: widget.customTheme,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CircleOfFifthsPainter extends CustomPainter {
  final int selectedIndex;
  final bool isMinorMode;
  final ColorScheme colorScheme;
  final CircleOfFifthsTheme customTheme;

  _CircleOfFifthsPainter({
    required this.selectedIndex,
    required this.isMinorMode,
    required this.colorScheme,
    required this.customTheme,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final sectorAngle = (2 * math.pi) / 12;
    final rotationOffset = -math.pi / 2 - (sectorAngle / 2);

    final isDark = colorScheme.brightness == Brightness.dark;

    final paint = Paint()..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = colorScheme.outlineVariant.withValues(alpha: 0.6);

    // Color palette with fallback to Theme defaults
    final Color tonicaColor = customTheme.tonicColor ??
        (isDark ? const Color(0xFFFFB74D) : const Color(0xFFF57C00));
    final Color gradosCuartoQuintoColor =
        customTheme.subdominantDominantColor ??
            (isDark ? const Color(0xFFE57373) : const Color(0xFFC62828));
    final Color acordesMenoresColor = customTheme.minorChordsColor ??
        (isDark ? const Color(0xFF81C784) : const Color(0xFF2E7D32));
    final Color disminuidoColor = customTheme.diminishedColor ??
        (isDark ? const Color(0xFF64B5F6) : const Color(0xFF1565C0));

    // Draw the 12 sectors rotated so selectedIndex is at 12:00
    for (int visIndex = 0; visIndex < 12; visIndex++) {
      final actualIndex = (visIndex + selectedIndex) % 12;
      final item = CircleOfFifthsModel.defaultKeys[actualIndex];

      final startAngle = rotationOffset + (visIndex * sectorAngle);

      Color outerSectorColor = colorScheme.surfaceContainerHigh;
      Color innerSectorColor = colorScheme.surfaceContainerHigh;
      Color textColorOnOuter = colorScheme.onSurface;
      Color textColorOnInner = colorScheme.onSurface;

      if (!isMinorMode) {
        // MAJOR MODE
        if (visIndex == 0) {
          outerSectorColor = tonicaColor;
          textColorOnOuter = isDark ? Colors.black : Colors.white;
          innerSectorColor = acordesMenoresColor;
          textColorOnInner = Colors.white;
        } else if (visIndex == 11) {
          outerSectorColor = gradosCuartoQuintoColor;
          textColorOnOuter = Colors.white;
          innerSectorColor = acordesMenoresColor;
          textColorOnInner = Colors.white;
        } else if (visIndex == 1) {
          outerSectorColor = gradosCuartoQuintoColor;
          textColorOnOuter = Colors.white;
          innerSectorColor = acordesMenoresColor;
          textColorOnInner = Colors.white;
        } else if (visIndex == 2) {
          innerSectorColor = disminuidoColor;
          textColorOnInner = Colors.white;
        }
      } else {
        // MINOR MODE
        if (visIndex == 0) {
          innerSectorColor = tonicaColor;
          textColorOnInner = isDark ? Colors.black : Colors.white;
          outerSectorColor = acordesMenoresColor;
          textColorOnOuter = Colors.white;
        } else if (visIndex == 11) {
          innerSectorColor = gradosCuartoQuintoColor;
          textColorOnInner = Colors.white;
          outerSectorColor = acordesMenoresColor;
          textColorOnOuter = Colors.white;
        } else if (visIndex == 1) {
          innerSectorColor = gradosCuartoQuintoColor;
          textColorOnInner = Colors.white;
          outerSectorColor = acordesMenoresColor;
          textColorOnOuter = Colors.white;
        } else if (visIndex == 2) {
          innerSectorColor = disminuidoColor;
          textColorOnInner = Colors.white;
        }
      }

      // 1. Outer Ring (Major)
      paint.color = outerSectorColor;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sectorAngle,
        true,
        paint,
      );
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sectorAngle,
        true,
        borderPaint,
      );

      // 2. Middle Ring (Relative Minor)
      final midRadius = radius * 0.70;
      paint.color = innerSectorColor;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: midRadius),
        startAngle,
        sectorAngle,
        true,
        paint,
      );
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: midRadius),
        startAngle,
        sectorAngle,
        true,
        borderPaint,
      );

      // 3. Inner Ring (Key Signature)
      final innerRadius = radius * 0.45;
      paint.color = colorScheme.surfaceContainerLowest;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: innerRadius),
        startAngle,
        sectorAngle,
        true,
        paint,
      );
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: innerRadius),
        startAngle,
        sectorAngle,
        true,
        borderPaint,
      );

      // --- TEXT LABELS ---
      final textAngle = startAngle + (sectorAngle / 2);

      // Major Key Text
      _drawText(
        canvas,
        item.major,
        Offset(
          center.dx + (radius * 0.84) * math.cos(textAngle),
          center.dy + (radius * 0.84) * math.sin(textAngle),
        ),
        TextStyle(
          color: textColorOnOuter,
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      );

      // Minor Key Text
      _drawText(
        canvas,
        item.minor,
        Offset(
          center.dx + (radius * 0.57) * math.cos(textAngle),
          center.dy + (radius * 0.57) * math.sin(textAngle),
        ),
        TextStyle(
          color: textColorOnInner,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      );

      // Key Signature Text
      _drawText(
        canvas,
        item.keySignature,
        Offset(
          center.dx + (radius * 0.35) * math.cos(textAngle),
          center.dy + (radius * 0.35) * math.sin(textAngle),
        ),
        TextStyle(
          color: colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w500,
          fontSize: 10,
        ),
      );
    }

    // --- CENTER CORE WITH BRAND ---
    final coreRadius = radius * 0.25;
    paint.color = colorScheme.surfaceContainerHigh;
    canvas.drawCircle(center, coreRadius, paint);
    canvas.drawCircle(center, coreRadius, borderPaint);

    if (customTheme.centerLabel.isNotEmpty) {
      _drawText(
        canvas,
        customTheme.centerLabel,
        center,
        TextStyle(
          color: colorScheme.primary,
          fontWeight: FontWeight.bold,
          fontSize: 18,
          letterSpacing: 1.5,
        ),
      );
    }
  }

  void _drawText(
    Canvas canvas,
    String text,
    Offset position,
    TextStyle style,
  ) {
    if (text.isEmpty) return;
    final textSpan = TextSpan(text: text, style: style);
    final textPainter = TextPainter(
      text: textSpan,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    final offset = Offset(
      position.dx - (textPainter.width / 2),
      position.dy - (textPainter.height / 2),
    );
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant _CircleOfFifthsPainter oldDelegate) {
    return oldDelegate.selectedIndex != selectedIndex ||
        oldDelegate.isMinorMode != isMinorMode ||
        oldDelegate.colorScheme != colorScheme ||
        oldDelegate.customTheme != customTheme;
  }
}
