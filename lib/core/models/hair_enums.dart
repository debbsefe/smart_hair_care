/// Hair type options (Andre Walker hair typing system)
enum HairType {
  type1a('1a', 'Type 1A - Straight (Fine)'),
  type1b('1b', 'Type 1B - Straight (Medium)'),
  type1c('1c', 'Type 1C - Straight (Coarse)'),
  type2a('2a', 'Type 2A - Wavy (Fine)'),
  type2b('2b', 'Type 2B - Wavy (Medium)'),
  type2c('2c', 'Type 2C - Wavy (Coarse)'),
  type3a('3a', 'Type 3A - Curly (Loose)'),
  type3b('3b', 'Type 3B - Curly (Tight)'),
  type3c('3c', 'Type 3C - Curly (Corkscrew)'),
  type4a('4a', 'Type 4A - Coily (S-pattern)'),
  type4b('4b', 'Type 4B - Coily (Z-pattern)'),
  type4c('4c', 'Type 4C - Coily (Tight)');

  const HairType(this.value, this.label);
  final String value;
  final String label;

  static HairType? fromValue(String? value) {
    if (value == null) return null;
    return HairType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => HairType.type1a,
    );
  }
}

/// Porosity level options
enum Porosity {
  low('low', 'Low Porosity'),
  medium('medium', 'Medium Porosity'),
  high('high', 'High Porosity');

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
}

/// Density level options
enum Density {
  low('low', 'Low Density'),
  medium('medium', 'Medium Density'),
  high('high', 'High Density');

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
}

/// Thickness/strand width options
enum Thickness {
  fine('fine', 'Fine'),
  medium('medium', 'Medium'),
  coarse('coarse', 'Coarse');

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
}

/// Scalp type options
enum ScalpType {
  dry('dry', 'Dry'),
  normal('normal', 'Normal'),
  oily('oily', 'Oily'),
  combination('combination', 'Combination');

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
