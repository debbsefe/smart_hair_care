import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hair_care/core/database/daos/experiments_dao.dart';
import 'package:smart_hair_care/core/database/database.dart';

void main() {
  late AppDatabase db;
  late ExperimentsDao dao;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    dao = ExperimentsDao(db);
  });

  tearDown(() async {
    await db.close();
  });

  ExperimentsCompanion createTestExperiment({
    String name = 'Test Experiment',
    DateTime? startDate,
  }) {
    return ExperimentsCompanion.insert(
      name: name,
      startDate: startDate ?? DateTime.now(),
    );
  }

  group('ExperimentsDao', () {
    test('insertExperiment returns new id', () async {
      final id = await dao.insertExperiment(createTestExperiment());

      expect(id, isPositive);
    });

    test('getAllExperiments returns empty list initially', () async {
      final experiments = await dao.getAllExperiments();

      expect(experiments, isEmpty);
    });

    test('getAllExperiments returns inserted experiments', () async {
      await dao.insertExperiment(createTestExperiment(name: 'First'));
      await dao.insertExperiment(createTestExperiment(name: 'Second'));

      final experiments = await dao.getAllExperiments();

      expect(experiments.length, 2);
    });

    test('getExperimentById returns experiment when exists', () async {
      final id = await dao.insertExperiment(
        createTestExperiment(name: 'My Experiment'),
      );

      final experiment = await dao.getExperimentById(id);

      expect(experiment, isNotNull);
      expect(experiment!.name, 'My Experiment');
    });

    test('getExperimentById returns null when not exists', () async {
      final experiment = await dao.getExperimentById(999);

      expect(experiment, isNull);
    });

    test('getExperimentsByStatus returns filtered experiments', () async {
      await dao.insertExperiment(createTestExperiment(name: 'Active'));
      final completedId = await dao.insertExperiment(
        createTestExperiment(name: 'Completed'),
      );
      await dao.updateStatus(completedId, 'completed');

      final active = await dao.getExperimentsByStatus('active');

      expect(active.length, 1);
      expect(active.first.name, 'Active');
    });

    test('getActiveExperiments returns only active', () async {
      await dao.insertExperiment(createTestExperiment(name: 'Active'));
      final completedId = await dao.insertExperiment(
        createTestExperiment(name: 'Completed'),
      );
      await dao.updateStatus(completedId, 'completed');

      final active = await dao.getActiveExperiments();

      expect(active.length, 1);
    });

    test('getCompletedExperiments returns only completed', () async {
      await dao.insertExperiment(createTestExperiment(name: 'Active'));
      final completedId = await dao.insertExperiment(
        createTestExperiment(name: 'Completed'),
      );
      await dao.updateStatus(completedId, 'completed');

      final completed = await dao.getCompletedExperiments();

      expect(completed.length, 1);
      expect(completed.first.name, 'Completed');
    });

    test('updateExperiment modifies experiment', () async {
      final id = await dao.insertExperiment(
        createTestExperiment(name: 'Original'),
      );
      final experiment = await dao.getExperimentById(id);

      final updated = experiment!.copyWith(name: 'Updated');
      await dao.updateExperiment(updated);

      final result = await dao.getExperimentById(id);
      expect(result!.name, 'Updated');
    });

    test('updateStatus changes experiment status', () async {
      final id = await dao.insertExperiment(createTestExperiment());

      await dao.updateStatus(id, 'abandoned');

      final experiment = await dao.getExperimentById(id);
      expect(experiment!.status, 'abandoned');
    });

    test('completeExperiment sets all completion fields', () async {
      final id = await dao.insertExperiment(createTestExperiment());

      await dao.completeExperiment(
        id,
        results: 'Great results',
        conclusion: 'It worked',
        successRating: 5,
      );

      final experiment = await dao.getExperimentById(id);
      expect(experiment!.status, 'completed');
      expect(experiment.results, 'Great results');
      expect(experiment.conclusion, 'It worked');
      expect(experiment.successRating, 5);
      expect(experiment.endDate, isNotNull);
    });

    test('deleteExperiment removes experiment', () async {
      final id = await dao.insertExperiment(createTestExperiment());

      await dao.deleteExperiment(id);

      final experiment = await dao.getExperimentById(id);
      expect(experiment, isNull);
    });

    test('watchAllExperiments streams updates', () async {
      final stream = dao.watchAllExperiments();

      final firstEmission = await stream.first;
      expect(firstEmission, isEmpty);

      await dao.insertExperiment(createTestExperiment());

      final secondEmission = await stream.first;
      expect(secondEmission.length, 1);
    });
  });
}
