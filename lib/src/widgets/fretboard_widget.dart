import 'package:flutter/material.dart';
import '../models/chord_model.dart';

/// Vector Fretboard diagram widget for Guitar (6 strings) and Ukulele (4 strings).
/// Displays nut, frets, strings, barres (cejillas), open/muted strings, and finger numbers.
class FretboardWidget extends StatelessWidget {
  /// The [ChordVoicing] to render on the fretboard.
  final ChordVoicing voicing;

  /// Optional chord name title displayed above the diagram.
  final String? chordTitle;

  /// Number of visible frets in the diagram. Defaults to `5`.
  final int fretCount;

  /// Width of the fretboard diagram.
  final double width;

  /// Height of the fretboard diagram.
  final double height;

  /// Creates a [FretboardWidget] from a precomputed [ChordVoicing].
  const FretboardWidget({
    super.key,
    required this.voicing,
    this.chordTitle,
    this.fretCount = 5,
    this.width = 200,
    this.height = 230,
  });

  /// Creates a [FretboardWidget] directly from a chord symbol (e.g., `"G7"`, `"F#m"`)
  /// for either [InstrumentType.guitar] or [InstrumentType.ukulele].
  factory FretboardWidget.fromChord({
    Key? key,
    required String chordSymbol,
    InstrumentType instrument = InstrumentType.guitar,
    bool showTitle = false,
    double width = 200,
    double height = 230,
  }) {
    final info = ChordTransposer.parseChord(chordSymbol);
    final voicing = instrument == InstrumentType.ukulele
        ? info.ukuleleVoicing
        : info.guitarVoicing;
    return FretboardWidget(
      key: key,
      voicing: voicing,
      chordTitle: showTitle ? info.symbol : null,
      width: width,
      height: height,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      width: width,
      height: height,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (chordTitle != null && chordTitle!.isNotEmpty) ...[
            Text(
              chordTitle!,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 6),
          ],
          Expanded(
            child: CustomPaint(
              size: Size(width, height),
              painter: _FretboardPainter(
                voicing: voicing,
                fretCount: fretCount,
                colorScheme: colorScheme,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FretboardPainter extends CustomPainter {
  final ChordVoicing voicing;
  final int fretCount;
  final ColorScheme colorScheme;

  _FretboardPainter({
    required this.voicing,
    required this.fretCount,
    required this.colorScheme,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final stringCount = voicing.frets.length;
    if (stringCount < 2) return;

    final leftPadding = voicing.baseFret > 1 ? 34.0 : 24.0;
    const rightPadding = 22.0;
    const topPadding = 26.0;
    const bottomPadding = 26.0;

    final gridWidth = size.width - leftPadding - rightPadding;
    final gridHeight = size.height - topPadding - bottomPadding;

    final stringSpacing = gridWidth / (stringCount - 1);
    final fretSpacing = gridHeight / fretCount;

    final linePaint = Paint()
      ..color = colorScheme.onSurfaceVariant.withValues(alpha: 0.7)
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke;

    // 1. Draw Nut (thick top bar if baseFret == 1)
    if (voicing.baseFret == 1) {
      final nutPaint = Paint()
        ..color = colorScheme.onSurface
        ..strokeWidth = 5.0
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(
        Offset(leftPadding, topPadding),
        Offset(leftPadding + gridWidth, topPadding),
        nutPaint,
      );
    } else {
      // Draw baseFret label on the left of the first fret space
      _drawText(
        canvas,
        '${voicing.baseFret}fr',
        Offset(leftPadding / 2, topPadding + fretSpacing * 0.5),
        TextStyle(
          color: colorScheme.primary,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      );
    }

    // 2. Draw Horizontal Fret Lines
    for (int f = 0; f <= fretCount; f++) {
      final y = topPadding + f * fretSpacing;
      canvas.drawLine(
        Offset(leftPadding, y),
        Offset(leftPadding + gridWidth, y),
        linePaint,
      );
    }

    // 3. Draw Vertical String Lines & Bottom Tuning Labels
    for (int s = 0; s < stringCount; s++) {
      final x = leftPadding + s * stringSpacing;
      // Slightly thicker bass strings
      final thickness = 1.1 + ((stringCount - 1 - s) * 0.22);
      canvas.drawLine(
        Offset(x, topPadding),
        Offset(x, topPadding + gridHeight),
        linePaint..strokeWidth = thickness,
      );

      if (s < voicing.stringNames.length) {
        _drawText(
          canvas,
          voicing.stringNames[s],
          Offset(x, topPadding + gridHeight + 14),
          TextStyle(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
            fontSize: 11,
          ),
        );
      }
    }

    // 4. Draw Open ('O') and Muted ('X') indicators above the nut
    for (int s = 0; s < stringCount; s++) {
      final fret = voicing.frets[s];
      final x = leftPadding + s * stringSpacing;
      const y = topPadding - 13;

      if (fret == -1) {
        _drawText(
          canvas,
          '✕',
          Offset(x, y),
          TextStyle(
            color: colorScheme.error,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        );
      } else if (fret == 0) {
        final openPaint = Paint()
          ..color = colorScheme.primary
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0;
        canvas.drawCircle(Offset(x, y), 4.5, openPaint);
      }
    }

    final dotRadius = (fretSpacing * 0.34).clamp(8.0, 13.0);
    final dotPaint = Paint()
      ..color = colorScheme.primary
      ..style = PaintingStyle.fill;

    // 5. Draw Barres (Cejillas)
    for (final barre in voicing.barres) {
      if (barre.fret < 1 || barre.fret > fretCount) continue;
      final startX = leftPadding + barre.startString * stringSpacing;
      final endX = leftPadding + barre.endString * stringSpacing;
      final centerY = topPadding + (barre.fret - 0.5) * fretSpacing;

      final barreRect = RRect.fromRectAndRadius(
        Rect.fromLTRB(
          startX - dotRadius * 0.85,
          centerY - dotRadius * 0.72,
          endX + dotRadius * 0.85,
          centerY + dotRadius * 0.72,
        ),
        Radius.circular(dotRadius),
      );
      canvas.drawRRect(barreRect, dotPaint);
    }

    // 6. Draw Finger Dots and Finger Numbers
    for (int s = 0; s < stringCount; s++) {
      final fret = voicing.frets[s];
      if (fret <= 0 || fret > fretCount) continue;

      final x = leftPadding + s * stringSpacing;
      final y = topPadding + (fret - 0.5) * fretSpacing;

      canvas.drawCircle(Offset(x, y), dotRadius, dotPaint);

      final finger = (s < voicing.fingers.length) ? voicing.fingers[s] : 0;
      if (finger > 0) {
        _drawText(
          canvas,
          '$finger',
          Offset(x, y),
          TextStyle(
            color: colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
            fontSize: dotRadius * 1.15,
          ),
        );
      }
    }
  }

  void _drawText(
    Canvas canvas,
    String text,
    Offset center,
    TextStyle style,
  ) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: style),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(
      canvas,
      Offset(center.dx - tp.width / 2, center.dy - tp.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant _FretboardPainter oldDelegate) {
    return oldDelegate.voicing != voicing ||
        oldDelegate.fretCount != fretCount ||
        oldDelegate.colorScheme != colorScheme;
  }
}
