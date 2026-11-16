import 'package:material_ui/material_ui.dart';

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

  /// Optional text color for [centerLabel]. Defaults to [ColorScheme.primary].
  final Color? centerLabelColor;

  /// Optional background color for the inactive wheel sectors.
  /// If null, dynamically adapts to [ColorScheme.surfaceContainerLowest] (light) or [ColorScheme.surfaceContainerHigh] (dark).
  final Color? inactiveSectorColor;

  /// Optional background color for the center core/hub.
  /// If null, dynamically adapts to [ColorScheme.surface] or [ColorScheme.surfaceContainerHigh].
  final Color? centerHubColor;

  /// Optional outline/border color for wheel arcs and circles.
  /// If null, defaults to [ColorScheme.outlineVariant].
  final Color? borderColor;

  /// Creates a [CircleOfFifthsTheme] instance for wheel color and logo customization.
  const CircleOfFifthsTheme({
    this.tonicColor,
    this.subdominantDominantColor,
    this.minorChordsColor,
    this.diminishedColor,
    this.centerLabel = 'NyK',
    this.centerLabelColor,
    this.inactiveSectorColor,
    this.centerHubColor,
    this.borderColor,
  });
}
