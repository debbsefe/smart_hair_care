import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smart_hair_care/core/database/database.dart';
import 'package:smart_hair_care/features/daily_log/notifiers/daily_logs_notifier.dart';

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
    });

    test('loads logs successfully', () async {
      final logs = DailyLogFixtures.sampleLogs();
      when(() => mockDao.getAllLogs()).thenAnswer((_) async => logs);

      final result = await container.read(dailyLogsProvider.future);

      expect(result, equals(logs));
    });

    test('handles load error', () async {
      when(
        () => mockDao.getAllLogs(),
      ).thenThrow(Exception('Database error'));

      container.read(dailyLogsProvider);
      await Future<void>.delayed(const Duration(milliseconds: 100));

      final state = container.read(dailyLogsProvider);
      expect(state.hasError, isTrue);
    });

    test('adds log successfully', () async {
      when(() => mockDao.getAllLogs()).thenAnswer((_) async => []);
      when(() => mockDao.insertLog(any())).thenAnswer((_) async => 1);

      await container.read(dailyLogsProvider.future);

      await container.read(dailyLogsProvider.notifier).addLog(
            date: DateTime.now(),
            routineType: 'wash_day',
          );

      verify(() => mockDao.insertLog(any())).called(1);
    });

    test('updates log successfully', () async {
      final logs = DailyLogFixtures.sampleLogs();
      when(() => mockDao.getAllLogs()).thenAnswer((_) async => logs);
      when(() => mockDao.updateLog(any())).thenAnswer((_) async => true);

      await container.read(dailyLogsProvider.future);

      final updatedLog = logs.first.copyWith(routineType: 'refresh_day');
      await container.read(dailyLogsProvider.notifier).updateLog(updatedLog);

      verify(() => mockDao.updateLog(any())).called(1);
    });

    test('deletes log successfully', () async {
      when(() => mockDao.getAllLogs()).thenAnswer((_) async => []);
      when(() => mockDao.deleteLog(any())).thenAnswer((_) async => 1);

      await container.read(dailyLogsProvider.future);

      await container.read(dailyLogsProvider.notifier).deleteLog(1);

      verify(() => mockDao.deleteLog(1)).called(1);
    });
  });

  group('Derived Providers', () {
    test('logsGroupedByDateProvider groups logs by date', () async {
      final logs = DailyLogFixtures.sampleLogs();
      when(() => mockDao.getAllLogs()).thenAnswer((_) async => logs);

      await container.read(dailyLogsProvider.future);

      final logsByDate = container.read(logsGroupedByDateProvider);
      expect(logsByDate.keys.length, equals(2));
    });
  });
}
