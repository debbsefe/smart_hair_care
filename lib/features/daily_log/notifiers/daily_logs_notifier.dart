import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_hair_care/core/core.dart';

/// Notifier for managing daily logs (Riverpod 3 AsyncNotifier)
class DailyLogsNotifier extends AsyncNotifier<List<DailyLog>> {
  late final DailyLogsDao _dao;

  @override
  Future<List<DailyLog>> build() async {
    _dao = ref.watch(dailyLogsDaoProvider);
    return _dao.getAllLogs();
  }

  Future<void> addLog({
    required DateTime date,
    required String routineType,
    String? productsUsed,
    String? techniques,
    int? hairConditionRating,
    String? weather,
    int? humidityLevel,
    String? notes,
    String? photoUrls,
  }) async {
    await _dao.insertLog(
      DailyLogsCompanion(
        date: Value(date),
        routineType: Value(routineType),
        productsUsed: Value(productsUsed),
        techniques: Value(techniques),
        hairConditionRating: Value(hairConditionRating),
        weather: Value(weather),
        humidityLevel: Value(humidityLevel),
        notes: Value(notes),
        photoUrls: Value(photoUrls),
      ),
    );
    ref.invalidateSelf();
  }

  Future<void> updateLog(DailyLog log) async {
    await _dao.updateLog(log);
    ref.invalidateSelf();
  }

  Future<void> deleteLog(int id) async {
    await _dao.deleteLog(id);
    ref.invalidateSelf();
  }
}

/// Provider for daily logs
final dailyLogsProvider =
    AsyncNotifierProvider<DailyLogsNotifier, List<DailyLog>>(
      DailyLogsNotifier.new,
    );

/// Provider for a single log by ID
final dailyLogByIdProvider = FutureProvider.family<DailyLog?, int>((
  ref,
  id,
) async {
  final dao = ref.watch(dailyLogsDaoProvider);
  return dao.getLogById(id);
});

/// Provider for log on a specific date
final dailyLogByDateProvider = FutureProvider.family<DailyLog?, DateTime>((
  ref,
  date,
) async {
  final dao = ref.watch(dailyLogsDaoProvider);
  return dao.getLogByDate(date);
});

/// Provider for logs grouped by date (for calendar view)
final logsGroupedByDateProvider = Provider<Map<DateTime, List<DailyLog>>>((
  ref,
) {
  final logsAsync = ref.watch(dailyLogsProvider);
  return logsAsync.when(
    data: (logs) {
      final grouped = <DateTime, List<DailyLog>>{};
      for (final log in logs) {
        final dateKey = DateTime(log.date.year, log.date.month, log.date.day);
        grouped.putIfAbsent(dateKey, () => []).add(log);
      }
      return grouped;
    },
    loading: () => {},
    error: (_, _) => {},
  );
});

/// Provider for logs filtered by month
final logsForMonthProvider = FutureProvider.family<List<DailyLog>, DateTime>((
  ref,
  month,
) async {
  final dao = ref.watch(dailyLogsDaoProvider);
  final startOfMonth = DateTime(month.year, month.month);
  final endOfMonth = DateTime(month.year, month.month + 1, 0, 23, 59, 59);
  return dao.getLogsByDateRange(startOfMonth, endOfMonth);
});
