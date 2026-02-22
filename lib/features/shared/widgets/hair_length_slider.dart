import 'package:flutter/material.dart';
import 'package:smart_hair_care/l10n/l10n.dart';

/// A reusable slider widget for selecting hair length in centimeters.
///
/// Used in both the hair profile setup and daily log form.
class HairLengthSlider extends StatelessWidget {
  const HairLengthSlider({
    required this.label,
    required this.value,
    required this.onChanged,
    super.key,
  });

  /// The display label (e.g. "Current Hair Length" or "Hair Length").
  final String label;

  /// The current hair length value, or null if not set.
  final double? value;

  /// Called when the slider value changes.
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final displayValue = value != null
        ? l10n.hairLengthValue(value!.round())
        : l10n.notSet;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: $displayValue',
          style: theme.textTheme.bodyMedium,
        ),
        Slider(
          value: value ?? 20,
          max: 100,
          divisions: 100,
          label: value != null
              ? l10n.hairLengthValue(value!.round())
              : null,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
