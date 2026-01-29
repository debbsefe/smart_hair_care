/// Routine types for daily logs
enum RoutineType {
  washDay('wash_day', 'Wash Day'),
  refresh('refresh', 'Refresh'),
  protectiveStyle('protective_style', 'Protective Style'),
  treatment('treatment', 'Treatment'),
  other('other', 'Other')
  ;

  const RoutineType(this.value, this.label);
  final String value;
  final String label;

  static RoutineType fromValue(String value) {
    return RoutineType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => RoutineType.other,
    );
  }
}
