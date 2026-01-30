import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smart_hair_care/core/database/database.dart';
import 'package:smart_hair_care/core/models/models.dart';
import 'package:smart_hair_care/features/experiments/notifiers/experiments_notifier.dart';

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
    });

    test('loads experiments successfully', () async {
      final experiments = ExperimentFixtures.sampleExperiments();
      when(
        () => mockDao.getAllExperiments(),
      ).thenAnswer((_) async => experiments);

      final result = await container.read(experimentsProvider.future);

      expect(result, equals(experiments));
    });

    test('handles load error', () async {
      when(
        () => mockDao.getAllExperiments(),
      ).thenThrow(Exception('Database error'));

      container.read(experimentsProvider);
      await Future<void>.delayed(const Duration(milliseconds: 100));

      final state = container.read(experimentsProvider);
      expect(state.hasError, isTrue);
    });

    test('adds experiment successfully', () async {
      when(() => mockDao.getAllExperiments()).thenAnswer((_) async => []);
      when(() => mockDao.insertExperiment(any())).thenAnswer((_) async => 1);

      await container.read(experimentsProvider.future);

      await container
          .read(experimentsProvider.notifier)
          .addExperiment(
            name: 'New Experiment',
            startDate: DateTime.now(),
          );

      verify(() => mockDao.insertExperiment(any())).called(1);
    });

    test('updates experiment successfully', () async {
      final experiments = ExperimentFixtures.sampleExperiments();
      when(
        () => mockDao.getAllExperiments(),
      ).thenAnswer((_) async => experiments);
      when(() => mockDao.updateExperiment(any())).thenAnswer((_) async => true);

      await container.read(experimentsProvider.future);

      final updatedExperiment = experiments.first.copyWith(
        name: 'Updated Name',
      );
      await container
          .read(experimentsProvider.notifier)
          .updateExperiment(
            updatedExperiment,
          );

      verify(() => mockDao.updateExperiment(any())).called(1);
    });

    test('completes experiment successfully', () async {
      final experiments = ExperimentFixtures.sampleExperiments();
      when(
        () => mockDao.getAllExperiments(),
      ).thenAnswer((_) async => experiments);
      when(
        () => mockDao.completeExperiment(
          any(),
          results: any(named: 'results'),
          conclusion: any(named: 'conclusion'),
          successRating: any(named: 'successRating'),
        ),
      ).thenAnswer((_) async => 1);

      await container.read(experimentsProvider.future);

      await container
          .read(experimentsProvider.notifier)
          .completeExperiment(
            id: 1,
            results: 'Good results',
            conclusion: 'Success',
            successRating: 5,
          );

      verify(
        () => mockDao.completeExperiment(
          any(),
          results: any(named: 'results'),
          conclusion: any(named: 'conclusion'),
          successRating: any(named: 'successRating'),
        ),
      ).called(1);
    });

    test('deletes experiment successfully', () async {
      when(() => mockDao.getAllExperiments()).thenAnswer((_) async => []);
      when(() => mockDao.deleteExperiment(any())).thenAnswer((_) async => 1);

      await container.read(experimentsProvider.future);

      await container.read(experimentsProvider.notifier).deleteExperiment(1);

      verify(() => mockDao.deleteExperiment(1)).called(1);
    });
  });

  group('ExperimentsFilterNotifier', () {
    test('initial state is active', () {
      final filter = container.read(experimentsFilterProvider);
      expect(filter, equals(ExperimentStatus.active));
    });

    test('can change filter', () {
      container.read(experimentsFilterProvider.notifier).filter =
          ExperimentStatus.completed;

      final filter = container.read(experimentsFilterProvider);
      expect(filter, equals(ExperimentStatus.completed));
    });
  });

  group('Derived Providers', () {
    test('filteredExperimentsProvider filters by status', () async {
      final experiments = ExperimentFixtures.sampleExperiments();
      when(
        () => mockDao.getAllExperiments(),
      ).thenAnswer((_) async => experiments);

      await container.read(experimentsProvider.future);

      // Default filter is active
      final filtered = container.read(filteredExperimentsProvider);
      expect(filtered.every((e) => e.status == 'active'), isTrue);
    });

    test('filteredExperimentsProvider responds to filter change', () async {
      final experiments = ExperimentFixtures.sampleExperiments();
      when(
        () => mockDao.getAllExperiments(),
      ).thenAnswer((_) async => experiments);

      await container.read(experimentsProvider.future);

      // Change filter to completed
      container.read(experimentsFilterProvider.notifier).filter =
          ExperimentStatus.completed;

      final filtered = container.read(filteredExperimentsProvider);
      expect(filtered.every((e) => e.status == 'completed'), isTrue);
    });

    test('activeExperimentsCountProvider returns count of active', () async {
      final experiments = ExperimentFixtures.sampleExperiments();
      when(
        () => mockDao.getAllExperiments(),
      ).thenAnswer((_) async => experiments);

      await container.read(experimentsProvider.future);

      final count = container.read(activeExperimentsCountProvider);
      expect(count, equals(1)); // One active experiment in fixtures
    });
  });
}
