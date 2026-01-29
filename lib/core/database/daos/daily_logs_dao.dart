import 'package:drift/drift.dart';
import 'package:smart_hair_care/core/database/database.dart';
import 'package:smart_hair_care/core/database/tables/daily_logs_table.dart';

part 'daily_logs_dao.g.dart';

/// Data Access Object for DailyLogs table
@DriftAccessor(tables: [DailyLogs])
class DailyLogsDao extends DatabaseAccessor<AppDatabase>
    with _$DailyLogsDaoMixin {
  DailyLogsDao(super.attachedDatabase);

  // Read operations
  Future<List<DailyLog>> getAllLogs() =>
      (select(dailyLogs)..orderBy([(l) => OrderingTerm.desc(l.date)])).get();

  Stream<List<DailyLog>> watchAllLogs() =>
      (select(dailyLogs)..orderBy([(l) => OrderingTerm.desc(l.date)])).watch();

  Future<List<DailyLog>> getLogsByDateRange(DateTime start, DateTime end) =>
      (select(dailyLogs)
            ..where((l) => l.date.isBetweenValues(start, end))
            ..orderBy([(l) => OrderingTerm.desc(l.date)]))
          .get();

  Future<DailyLog?> getLogByDate(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    return (select(dailyLogs)
          ..where((l) => l.date.isBetweenValues(startOfDay, endOfDay)))
        .getSingleOrNull();
  }

  Future<DailyLog?> getLogById(int id) =>
      (select(dailyLogs)..where((l) => l.id.equals(id))).getSingleOrNull();

  // Create operations
  Future<int> insertLog(DailyLogsCompanion log) => into(dailyLogs).insert(log);

  // Update operations
  Future<bool> updateLog(DailyLog log) => update(dailyLogs).replace(log);

  // Delete operations
  Future<int> deleteLog(int id) =>
      (delete(dailyLogs)..where((l) => l.id.equals(id))).go();
}
