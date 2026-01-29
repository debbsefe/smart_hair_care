import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smart_hair_care/core/database/database.dart';
import 'package:smart_hair_care/features/daily_log/providers/daily_logs_provider.dart';

import '../../../fixtures/fixtures.dart';
import '../../../helpers/helpers.dart';

void main() {
  late MockDailyLogsDao mockDao;
  late ProviderContainer container;

  setUpAll(registerFallbackValues);

  setUp(() {
    mockDao = MockDailyLogsDao();
    container = ProviderContainer(
      overrides: [
        dailyLogsDaoProvider.overrideWithValue(mockDao),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('DailyLogsNotifier', () {
    test('initial state is loading', () {
      when(() => mockDao.getAllLogs()).thenAnswer((_) async => []);

      final state = container.read(dailyLogsProvider);

      expect(state.isLoading, isTrue);
      expect(state.logs, isEmpty);
      expect(state.error, isNull);
    });

    test('loads logs successfully', () async {
      final logs = DailyLogFixtures.sampleLogs();
      when(() => mockDao.getAllLogs()).thenAnswer((_) async => logs);

      container.read(dailyLogsProvider);
      await Future<void>.delayed(const Duration(milliseconds: 100));

      final state = container.read(dailyLogsProvider);
      expect(state.isLoading, isFalse);
      expect(state.logs, equals(logs));
      expect(state.error, isNull);
    });

    test('handles load error', () async {
      when(() => mockDao.getAllLogs()).thenThrow(Exception('Database error'));

      container.read(dailyLogsProvider);
      await Future<void>.delayed(const Duration(milliseconds: 100));

      final state = container.read(dailyLogsProvider);
      expect(state.isLoading, isFalse);
      expect(state.error, isNotNull);
    });

    test('adds log successfully', () async {
      when(() => mockDao.getAllLogs()).thenAnswer((_) async => []);
      when(() => mockDao.insertLog(any())).thenAnswer((_) async => 1);

      container.read(dailyLogsProvider);
      await Future<void>.delayed(const Duration(milliseconds: 100));

      await container.read(dailyLogsProvider.notifier).addLog(
            date: DailyLogFixtures.today,
            routineType: 'wash_day',
            productsUsed: '1,2',
            techniques: 'Squish to condish',
          );

      verify(() => mockDao.insertLog(any())).called(1);
      verify(() => mockDao.getAllLogs()).called(greaterThanOrEqualTo(2));
    });

    test('deletes log successfully', () async {
      final log = DailyLogFixtures.washDay();
      when(() => mockDao.getAllLogs()).thenAnswer((_) async => [log]);
      when(() => mockDao.deleteLog(log.id)).thenAnswer((_) async => 1);

      container.read(dailyLogsProvider);
      await Future<void>.delayed(const Duration(milliseconds: 100));

      await container.read(dailyLogsProvider.notifier).deleteLog(log.id);

      verify(() => mockDao.deleteLog(log.id)).called(1);
    });

    test('loads logs for specific month', () async {
      final logs = DailyLogFixtures.sampleLogs();
      when(() => mockDao.getAllLogs()).thenAnswer((_) async => []);
      when(() => mockDao.getLogsByDateRange(any(), any()))
          .thenAnswer((_) async => logs);

      container.read(dailyLogsProvider);
      await Future<void>.delayed(const Duration(milliseconds: 100));

      await container
          .read(dailyLogsProvider.notifier)
          .loadLogsForMonth(DateTime(2026));

      verify(() => mockDao.getLogsByDateRange(any(), any())).called(1);
    });

    test('clearError clears error state', () async {
      when(() => mockDao.getAllLogs()).thenThrow(Exception('Database error'));

      container.read(dailyLogsProvider);
      await Future<void>.delayed(const Duration(milliseconds: 100));

      expect(container.read(dailyLogsProvider).error, isNotNull);

      container.read(dailyLogsProvider.notifier).clearError();

      expect(container.read(dailyLogsProvider).error, isNull);
    });
  });

  group('DailyLogsState', () {
    test('copyWith creates new state with updated values', () {
      const state = DailyLogsState();
      final newState = state.copyWith(isLoading: true);

      expect(newState.isLoading, isTrue);
      expect(state.isLoading, isFalse);
    });

    test('equality works correctly', () {
      const state1 = DailyLogsState();
      const state2 = DailyLogsState();

      expect(state1, equals(state2));
    });

    test('selectedMonth can be set', () {
      const state = DailyLogsState();
      final month = DateTime(2026, 2);
      final newState = state.copyWith(selectedMonth: month);

      expect(newState.selectedMonth, month);
    });
  });
}
