import 'package:flutter/material.dart';

/// Configuration theme for customizing the appearance and colors of [CircleOfFifthsWheelWidget].
class CircleOfFifthsTheme {
  /// Color for the active tonic key (12:00 position). Defaults to theme amber/orange.
  final Color? tonicColor;

  /// Color for the 4th and 5th degrees (Subdominant IV and Dominant V). Defaults to coral/red.
  final Color? subdominantDominantColor;

  /// Color for relative minor and secondary chords (ii, iii, vi). Defaults to emerald green.
  final Color? minorChordsColor;

  /// Color for the 7th diminished degree (vii° / ii°). Defaults to cobalt blue.
  final Color? diminishedColor;

  /// Optional brand text displayed in the center of the wheel (e.g. "NyK").
  final String centerLabel;

  const CircleOfFifthsTheme({
    this.tonicColor,
    this.subdominantDominantColor,
    this.minorChordsColor,
    this.diminishedColor,
    this.centerLabel = 'NyK',
  });
}
