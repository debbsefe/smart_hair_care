import 'package:drift/drift.dart';
import 'package:smart_hair_care/core/database/database.dart';
import 'package:smart_hair_care/core/database/tables/experiments_table.dart';

part 'experiments_dao.g.dart';

/// Data Access Object for Experiments table
@DriftAccessor(tables: [Experiments])
class ExperimentsDao extends DatabaseAccessor<AppDatabase>
    with _$ExperimentsDaoMixin {
  ExperimentsDao(super.attachedDatabase);

  // Read operations
  Future<List<Experiment>> getAllExperiments() => (select(
    experiments,
  )..orderBy([(e) => OrderingTerm.desc(e.startDate)])).get();

  Stream<List<Experiment>> watchAllExperiments() => (select(
    experiments,
  )..orderBy([(e) => OrderingTerm.desc(e.startDate)])).watch();

  Future<Experiment?> getExperimentById(int id) =>
      (select(experiments)..where((e) => e.id.equals(id))).getSingleOrNull();

  Future<List<Experiment>> getExperimentsByStatus(String status) =>
      (select(experiments)
            ..where((e) => e.status.equals(status))
            ..orderBy([(e) => OrderingTerm.desc(e.startDate)]))
          .get();

  Future<List<Experiment>> getActiveExperiments() =>
      getExperimentsByStatus('active');

  Future<List<Experiment>> getCompletedExperiments() =>
      getExperimentsByStatus('completed');

  // Create operations
  Future<int> insertExperiment(ExperimentsCompanion experiment) =>
      into(experiments).insert(experiment);

  // Update operations
  Future<bool> updateExperiment(Experiment experiment) =>
      update(experiments).replace(experiment);

  Future<int> updateStatus(int id, String status) =>
      (update(experiments)..where((e) => e.id.equals(id))).write(
        ExperimentsCompanion(status: Value(status)),
      );

  Future<int> completeExperiment(
    int id, {
    required String results,
    required String conclusion,
    int? successRating,
  }) => (update(experiments)..where((e) => e.id.equals(id))).write(
    ExperimentsCompanion(
      status: const Value('completed'),
      endDate: Value(DateTime.now()),
      results: Value(results),
      conclusion: Value(conclusion),
      successRating: Value(successRating),
    ),
  );

  // Delete operations
  Future<int> deleteExperiment(int id) =>
      (delete(experiments)..where((e) => e.id.equals(id))).go();
}
