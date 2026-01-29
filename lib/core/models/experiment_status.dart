/// Experiment status options
enum ExperimentStatus {
  active('active', 'Active'),
  completed('completed', 'Completed'),
  abandoned('abandoned', 'Abandoned')
  ;

  const ExperimentStatus(this.value, this.label);
  final String value;
  final String label;

  static ExperimentStatus fromValue(String value) {
    return ExperimentStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => ExperimentStatus.active,
    );
  }
}
