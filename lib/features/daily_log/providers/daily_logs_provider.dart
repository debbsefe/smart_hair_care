import 'dart:async';

import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_hair_care/core/database/daos/daily_logs_dao.dart';
import 'package:smart_hair_care/core/database/database.dart';

/// State class for daily logs
class DailyLogsState extends Equatable {
  const DailyLogsState({
    this.logs = const [],
    this.isLoading = false,
    this.error,
    this.selectedMonth,
  });

  final List<DailyLog> logs;
  final bool isLoading;
  final String? error;
  final DateTime? selectedMonth;

  @override
  List<Object?> get props => [logs, isLoading, error, selectedMonth];

  DailyLogsState copyWith({
    List<DailyLog>? logs,
    bool? isLoading,
    String? error,
    DateTime? selectedMonth,
  }) {
    return DailyLogsState(
      logs: logs ?? this.logs,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      selectedMonth: selectedMonth ?? this.selectedMonth,
    );
  }
}

/// Notifier for managing daily logs state (Riverpod 3)
class DailyLogsNotifier extends Notifier<DailyLogsState> {
  late final DailyLogsDao _dao;

  @override
  DailyLogsState build() {
    _dao = ref.watch(dailyLogsDaoProvider);
    // ignore: discarded_futures, load data after build completes
    Future.microtask(_loadLogs);
    return const DailyLogsState(isLoading: true);
  }

  Future<void> _loadLogs() async {
    state = state.copyWith(isLoading: true);
    try {
      final logs = await _dao.getAllLogs();
      state = state.copyWith(logs: logs, isLoading: false);
    } on Exception catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> loadLogs() => _loadLogs();

  /// Clears any error state
  void clearError() {
    if (state.error != null) {
      // ignore: avoid_redundant_argument_values, null clears existing error
      state = state.copyWith(error: null);
    }
  }

  Future<void> loadLogsForMonth(DateTime month) async {
    state = state.copyWith(isLoading: true, selectedMonth: month);
    try {
      final startOfMonth = DateTime(month.year, month.month);
      final endOfMonth = DateTime(month.year, month.month + 1, 0, 23, 59, 59);
      final logs = await _dao.getLogsByDateRange(startOfMonth, endOfMonth);
      state = state.copyWith(logs: logs, isLoading: false);
    } on Exception catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
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
    try {
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
      await _loadLogs();
    } on Exception catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> updateLog(DailyLog log) async {
    try {
      await _dao.updateLog(log);
      await _loadLogs();
    } on Exception catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> deleteLog(int id) async {
    try {
      await _dao.deleteLog(id);
      await _loadLogs();
    } on Exception catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}

/// Provider for daily logs state
final dailyLogsProvider = NotifierProvider<DailyLogsNotifier, DailyLogsState>(
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
  final state = ref.watch(dailyLogsProvider);
  final grouped = <DateTime, List<DailyLog>>{};

  for (final log in state.logs) {
    final dateKey = DateTime(log.date.year, log.date.month, log.date.day);
    grouped.putIfAbsent(dateKey, () => []).add(log);
  }

  return grouped;
});
