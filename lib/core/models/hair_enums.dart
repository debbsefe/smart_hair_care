import 'package:smart_hair_care/l10n/l10n.dart';

/// Hair pattern bucket categories (high-level grouping)
enum HairPatternBucket {
  straight('straight', 'Straight'),
  wavy('wavy', 'Wavy'),
  curly('curly', 'Curly'),
  coily('coily', 'Coily')
  ;

  const HairPatternBucket(this.value, this.label);
  final String value;
  final String label;

  /// Get sub-types for this bucket
  List<String> get subTypes {
    switch (this) {
      case HairPatternBucket.straight:
        return ['1A', '1B', '1C'];
      case HairPatternBucket.wavy:
        return ['2A', '2B', '2C'];
      case HairPatternBucket.curly:
        return ['3A', '3B', '3C'];
      case HairPatternBucket.coily:
        return ['4A', '4B', '4C'];
    }
  }

  static HairPatternBucket? fromValue(String? value) {
    if (value == null) return null;
    return HairPatternBucket.values.firstWhere(
      (e) => e.value == value,
      orElse: () => HairPatternBucket.straight,
    );
  }

  /// Get bucket from a specific pattern (e.g., "3A" -> Curly)
  static HairPatternBucket? fromPattern(String pattern) {
    final normalized = pattern.toUpperCase();
    if (normalized.startsWith('1')) return HairPatternBucket.straight;
    if (normalized.startsWith('2')) return HairPatternBucket.wavy;
    if (normalized.startsWith('3')) return HairPatternBucket.curly;
    if (normalized.startsWith('4')) return HairPatternBucket.coily;
    return null;
  }
}

/// Porosity level options
enum Porosity {
  low('low', 'Low Porosity'),
  medium('medium', 'Medium Porosity'),
  high('high', 'High Porosity')
  ;

  const Porosity(this.value, this.label);
  final String value;
  final String label;
  static Porosity? fromValue(String? value) {
    if (value == null) return null;
    return Porosity.values.firstWhere(
      (e) => e.value == value,
      orElse: () => Porosity.medium,
    );
  }

  /// Returns the symptom-first localized label for this porosity.
  String symptomLabel(AppLocalizations l10n) {
    switch (this) {
      case Porosity.low:
        return l10n.profilePorositySymptomLow;
      case Porosity.medium:
        return l10n.profilePorositySymptomMedium;
      case Porosity.high:
        return l10n.profilePorositySymptomHigh;
    }
  }

  /// Returns the human-readable localized technical label for this porosity.
  String readableLabel(AppLocalizations l10n) {
    switch (this) {
      case Porosity.low:
        return l10n.profilePorosityReadableLow;
      case Porosity.medium:
        return l10n.profilePorosityReadableMedium;
      case Porosity.high:
        return l10n.profilePorosityReadableHigh;
    }
  }
}

/// Density level options
enum Density {
  low('low', 'Low Density'),
  medium('medium', 'Medium Density'),
  high('high', 'High Density')
  ;

  const Density(this.value, this.label);
  final String value;
  final String label;

  static Density? fromValue(String? value) {
    if (value == null) return null;
    return Density.values.firstWhere(
      (e) => e.value == value,
      orElse: () => Density.medium,
    );
  }

  /// Returns the scalp-visibility symptom description for this density.
  String symptomLabel(AppLocalizations l10n) {
    switch (this) {
      case Density.low:
        return l10n.profileDensitySymptomLow;
      case Density.medium:
        return l10n.profileDensitySymptomMedium;
      case Density.high:
        return l10n.profileDensitySymptomHigh;
    }
  }

  /// Returns the human-readable localized label for this density.
  String readableLabel(AppLocalizations l10n) {
    switch (this) {
      case Density.low:
        return l10n.profileDensityReadableLow;
      case Density.medium:
        return l10n.profileDensityReadableMedium;
      case Density.high:
        return l10n.profileDensityReadableHigh;
    }
  }
}

/// Thickness/strand width options
enum Thickness {
  fine('fine', 'Fine'),
  medium('medium', 'Medium'),
  coarse('coarse', 'Coarse')
  ;

  const Thickness(this.value, this.label);
  final String value;
  final String label;

  static Thickness? fromValue(String? value) {
    if (value == null) return null;
    return Thickness.values.firstWhere(
      (e) => e.value == value,
      orElse: () => Thickness.medium,
    );
  }

  /// Returns the thread-comparison symptom description for this thickness.
  String symptomLabel(AppLocalizations l10n) {
    switch (this) {
      case Thickness.fine:
        return l10n.profileThicknessSymptomFine;
      case Thickness.medium:
        return l10n.profileThicknessSymptomMedium;
      case Thickness.coarse:
        return l10n.profileThicknessSymptomCoarse;
    }
  }

  /// Returns the human-readable localized label for this thickness.
  String readableLabel(AppLocalizations l10n) {
    switch (this) {
      case Thickness.fine:
        return l10n.profileThicknessReadableFine;
      case Thickness.medium:
        return l10n.profileThicknessReadableMedium;
      case Thickness.coarse:
        return l10n.profileThicknessReadableCoarse;
    }
  }
}

/// Scalp type options
enum ScalpType {
  dry('dry', 'Dry'),
  normal('normal', 'Normal'),
  oily('oily', 'Oily'),
  combination('combination', 'Combination')
  ;

  const ScalpType(this.value, this.label);
  final String value;
  final String label;

  static ScalpType? fromValue(String? value) {
    if (value == null) return null;
    return ScalpType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => ScalpType.normal,
    );
  }
}
