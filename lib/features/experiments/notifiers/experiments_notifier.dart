import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_hair_care/core/database/daos/experiments_dao.dart';
import 'package:smart_hair_care/core/database/database.dart';
import 'package:smart_hair_care/core/models/models.dart';

/// Notifier for managing experiments (Riverpod 3 AsyncNotifier)
class ExperimentsNotifier extends AsyncNotifier<List<Experiment>> {
  late final ExperimentsDao _dao;

  @override
  Future<List<Experiment>> build() async {
    _dao = ref.watch(experimentsDaoProvider);
    return _dao.getAllExperiments();
  }

  Future<void> addExperiment({
    required String name,
    required DateTime startDate,
    String? hypothesis,
    String? method,
    String? variables,
  }) async {
    await _dao.insertExperiment(
      ExperimentsCompanion(
        name: Value(name),
        startDate: Value(startDate),
        hypothesis: Value(hypothesis),
        method: Value(method),
        variables: Value(variables),
        status: const Value('active'),
      ),
    );
    ref.invalidateSelf();
  }

  Future<void> updateExperiment(Experiment experiment) async {
    await _dao.updateExperiment(experiment);
    ref.invalidateSelf();
  }

  Future<void> addObservation(int id, String observation) async {
    final experiment = await _dao.getExperimentById(id);
    if (experiment != null) {
      final existingObs = experiment.observations ?? '';
      final timestamp = DateTime.now().toIso8601String().split('T')[0];
      final newObs = existingObs.isEmpty
          ? '[$timestamp] $observation'
          : '$existingObs\n[$timestamp] $observation';

      await _dao.updateExperiment(
        experiment.copyWith(observations: Value(newObs)),
      );
      ref.invalidateSelf();
    }
  }

  Future<void> completeExperiment({
    required int id,
    required String results,
    required String conclusion,
    int? successRating,
  }) async {
    await _dao.completeExperiment(
      id,
      results: results,
      conclusion: conclusion,
      successRating: successRating,
    );
    ref.invalidateSelf();
  }

  Future<void> abandonExperiment(int id) async {
    await _dao.updateStatus(id, 'abandoned');
    ref.invalidateSelf();
  }

  Future<void> deleteExperiment(int id) async {
    await _dao.deleteExperiment(id);
    ref.invalidateSelf();
  }
}

/// Provider for experiments
final experimentsProvider =
    AsyncNotifierProvider<ExperimentsNotifier, List<Experiment>>(
  ExperimentsNotifier.new,
);

/// Provider for a single experiment by ID
final experimentByIdProvider = FutureProvider.family<Experiment?, int>((
  ref,
  id,
) async {
  final dao = ref.watch(experimentsDaoProvider);
  return dao.getExperimentById(id);
});

/// Provider for current filter status
final experimentsFilterProvider =
    NotifierProvider<ExperimentsFilterNotifier, ExperimentStatus>(
  ExperimentsFilterNotifier.new,
);

/// Simple notifier for filter state
class ExperimentsFilterNotifier extends Notifier<ExperimentStatus> {
  @override
  ExperimentStatus build() => ExperimentStatus.active;

  ExperimentStatus get filter => state;
  set filter(ExperimentStatus value) => state = value;
}

/// Provider for filtered experiments based on current filter
final filteredExperimentsProvider = Provider<List<Experiment>>((ref) {
  final experimentsAsync = ref.watch(experimentsProvider);
  final filter = ref.watch(experimentsFilterProvider);
  return experimentsAsync.when(
    data: (experiments) =>
        experiments.where((e) => e.status == filter.value).toList(),
    loading: () => [],
    error: (_, _) => [],
  );
});

/// Provider for active experiments count
final activeExperimentsCountProvider = Provider<int>((ref) {
  final experimentsAsync = ref.watch(experimentsProvider);
  return experimentsAsync.when(
    data: (experiments) =>
        experiments.where((e) => e.status == 'active').length,
    loading: () => 0,
    error: (_, _) => 0,
  );
});
