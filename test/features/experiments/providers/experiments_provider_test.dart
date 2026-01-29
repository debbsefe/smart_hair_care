import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smart_hair_care/core/database/database.dart';
import 'package:smart_hair_care/core/models/experiment_status.dart';
import 'package:smart_hair_care/features/experiments/providers/experiments_provider.dart';

import '../../../fixtures/fixtures.dart';
import '../../../helpers/helpers.dart';

void main() {
  late MockExperimentsDao mockDao;
  late ProviderContainer container;

  setUpAll(registerFallbackValues);

  setUp(() {
    mockDao = MockExperimentsDao();
    container = ProviderContainer(
      overrides: [
        experimentsDaoProvider.overrideWithValue(mockDao),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('ExperimentsNotifier', () {
    test('initial state is loading', () {
      when(() => mockDao.getAllExperiments()).thenAnswer((_) async => []);

      final state = container.read(experimentsProvider);

      expect(state.isLoading, isTrue);
      expect(state.experiments, isEmpty);
      expect(state.error, isNull);
    });

    test('loads experiments successfully', () async {
      final experiments = ExperimentFixtures.sampleExperiments();
      when(() => mockDao.getAllExperiments())
          .thenAnswer((_) async => experiments);

      container.read(experimentsProvider);
      await Future<void>.delayed(const Duration(milliseconds: 100));

      final state = container.read(experimentsProvider);
      expect(state.isLoading, isFalse);
      expect(state.experiments, equals(experiments));
      expect(state.error, isNull);
    });

    test('handles load error', () async {
      when(() => mockDao.getAllExperiments())
          .thenThrow(Exception('Database error'));

      container.read(experimentsProvider);
      await Future<void>.delayed(const Duration(milliseconds: 100));

      final state = container.read(experimentsProvider);
      expect(state.isLoading, isFalse);
      expect(state.error, isNotNull);
    });

    test('adds experiment successfully', () async {
      when(() => mockDao.getAllExperiments()).thenAnswer((_) async => []);
      when(() => mockDao.insertExperiment(any())).thenAnswer((_) async => 1);

      container.read(experimentsProvider);
      await Future<void>.delayed(const Duration(milliseconds: 100));

      await container.read(experimentsProvider.notifier).addExperiment(
            name: 'New Experiment',
            hypothesis: 'Testing new products',
            startDate: DateTime(2026, 2),
          );

      verify(() => mockDao.insertExperiment(any())).called(1);
      verify(() => mockDao.getAllExperiments()).called(greaterThanOrEqualTo(2));
    });

    test('deletes experiment successfully', () async {
      final experiment = ExperimentFixtures.activeExperiment();
      when(() => mockDao.getAllExperiments())
          .thenAnswer((_) async => [experiment]);
      when(() => mockDao.deleteExperiment(experiment.id))
          .thenAnswer((_) async => 1);

      container.read(experimentsProvider);
      await Future<void>.delayed(const Duration(milliseconds: 100));

      await container
          .read(experimentsProvider.notifier)
          .deleteExperiment(experiment.id);

      verify(() => mockDao.deleteExperiment(experiment.id)).called(1);
    });

    test('completes experiment successfully', () async {
      final experiment = ExperimentFixtures.activeExperiment();
      when(() => mockDao.getAllExperiments())
          .thenAnswer((_) async => [experiment]);
      when(
        () => mockDao.completeExperiment(
          experiment.id,
          results: any(named: 'results'),
          conclusion: any(named: 'conclusion'),
          successRating: any(named: 'successRating'),
        ),
      ).thenAnswer((_) async => 1);

      container.read(experimentsProvider);
      await Future<void>.delayed(const Duration(milliseconds: 100));

      await container.read(experimentsProvider.notifier).completeExperiment(
            id: experiment.id,
            results: 'Great results!',
            conclusion: 'It worked perfectly',
            successRating: 5,
          );

      verify(
        () => mockDao.completeExperiment(
          experiment.id,
          results: 'Great results!',
          conclusion: 'It worked perfectly',
          successRating: 5,
        ),
      ).called(1);
    });

    test('abandons experiment successfully', () async {
      final experiment = ExperimentFixtures.activeExperiment();
      when(() => mockDao.getAllExperiments())
          .thenAnswer((_) async => [experiment]);
      when(() => mockDao.updateStatus(experiment.id, 'abandoned'))
          .thenAnswer((_) async => 1);

      container.read(experimentsProvider);
      await Future<void>.delayed(const Duration(milliseconds: 100));

      await container
          .read(experimentsProvider.notifier)
          .abandonExperiment(experiment.id);

      verify(() => mockDao.updateStatus(experiment.id, 'abandoned')).called(1);
    });

    test('sets filter correctly', () async {
      when(() => mockDao.getAllExperiments()).thenAnswer((_) async => []);

      container.read(experimentsProvider);
      await Future<void>.delayed(const Duration(milliseconds: 100));

      container
          .read(experimentsProvider.notifier)
          .setFilter(ExperimentStatus.completed);

      final state = container.read(experimentsProvider);
      expect(state.filter, ExperimentStatus.completed);
    });

    test('clearError clears error state', () async {
      when(() => mockDao.getAllExperiments())
          .thenThrow(Exception('Database error'));

      container.read(experimentsProvider);
      await Future<void>.delayed(const Duration(milliseconds: 100));

      expect(container.read(experimentsProvider).error, isNotNull);

      container.read(experimentsProvider.notifier).clearError();

      expect(container.read(experimentsProvider).error, isNull);
    });
  });

  group('ExperimentsState', () {
    test('copyWith creates new state with updated values', () {
      const state = ExperimentsState();
      final newState = state.copyWith(isLoading: true);

      expect(newState.isLoading, isTrue);
      expect(state.isLoading, isFalse);
    });

    test('equality works correctly', () {
      const state1 = ExperimentsState();
      const state2 = ExperimentsState();

      expect(state1, equals(state2));
    });

    test('filter defaults to active', () {
      const state = ExperimentsState();
      expect(state.filter, ExperimentStatus.active);
    });
  });

  group('filteredExperimentsProvider', () {
    test('returns active experiments by default', () async {
      final experiments = ExperimentFixtures.sampleExperiments();
      when(() => mockDao.getAllExperiments())
          .thenAnswer((_) async => experiments);

      container.read(experimentsProvider);
      await Future<void>.delayed(const Duration(milliseconds: 100));

      final filtered = container.read(filteredExperimentsProvider);
      expect(filtered.every((e) => e.status == 'active'), isTrue);
    });

    test('returns only completed experiments when filter is completed',
        () async {
      final experiments = ExperimentFixtures.sampleExperiments();
      when(() => mockDao.getAllExperiments())
          .thenAnswer((_) async => experiments);

      container.read(experimentsProvider);
      await Future<void>.delayed(const Duration(milliseconds: 100));

      container
          .read(experimentsProvider.notifier)
          .setFilter(ExperimentStatus.completed);

      final filtered = container.read(filteredExperimentsProvider);
      expect(filtered.every((e) => e.status == 'completed'), isTrue);
    });
  });
}
