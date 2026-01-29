import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hair_care/core/database/daos/daily_logs_dao.dart';
import 'package:smart_hair_care/core/database/database.dart';

void main() {
  late AppDatabase db;
  late DailyLogsDao dao;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    dao = DailyLogsDao(db);
  });

  tearDown(() async {
    await db.close();
  });

  DailyLogsCompanion createTestLog({
    DateTime? date,
    String routineType = 'wash_day',
  }) {
    return DailyLogsCompanion.insert(
      date: date ?? DateTime.now(),
      routineType: routineType,
    );
  }

  group('DailyLogsDao', () {
    test('insertLog returns new id', () async {
      final id = await dao.insertLog(createTestLog());

      expect(id, isPositive);
    });

    test('getAllLogs returns empty list initially', () async {
      final logs = await dao.getAllLogs();

      expect(logs, isEmpty);
    });

    test('getAllLogs returns inserted logs ordered by date desc', () async {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final today = DateTime.now();

      await dao.insertLog(createTestLog(date: yesterday));
      await dao.insertLog(createTestLog(date: today));

      final logs = await dao.getAllLogs();

      expect(logs.length, 2);
      expect(logs.first.date.isAfter(logs.last.date), isTrue);
    });

    test('getLogById returns log when exists', () async {
      final id = await dao.insertLog(
        createTestLog(routineType: 'deep_condition'),
      );

      final log = await dao.getLogById(id);

      expect(log, isNotNull);
      expect(log!.routineType, 'deep_condition');
    });

    test('getLogById returns null when not exists', () async {
      final log = await dao.getLogById(999);

      expect(log, isNull);
    });

    test('getLogsByDateRange returns filtered logs', () async {
      final now = DateTime.now();
      final weekAgo = now.subtract(const Duration(days: 7));
      final twoWeeksAgo = now.subtract(const Duration(days: 14));

      await dao.insertLog(createTestLog(date: now));
      await dao.insertLog(createTestLog(date: weekAgo));
      await dao.insertLog(createTestLog(date: twoWeeksAgo));

      final logs = await dao.getLogsByDateRange(
        weekAgo.subtract(const Duration(days: 1)),
        now.add(const Duration(days: 1)),
      );

      expect(logs.length, 2);
    });

    test('updateLog modifies log', () async {
      final id = await dao.insertLog(createTestLog());
      final log = await dao.getLogById(id);

      final updated = log!.copyWith(routineType: 'refresh_day');
      await dao.updateLog(updated);

      final result = await dao.getLogById(id);
      expect(result!.routineType, 'refresh_day');
    });

    test('deleteLog removes log', () async {
      final id = await dao.insertLog(createTestLog());

      await dao.deleteLog(id);

      final log = await dao.getLogById(id);
      expect(log, isNull);
    });

    test('watchAllLogs streams updates', () async {
      final stream = dao.watchAllLogs();

      final firstEmission = await stream.first;
      expect(firstEmission, isEmpty);

      await dao.insertLog(createTestLog());

      final secondEmission = await stream.first;
      expect(secondEmission.length, 1);
    });
  });
}
