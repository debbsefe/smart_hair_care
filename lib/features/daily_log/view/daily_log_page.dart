import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_hair_care/core/database/database.dart';
import 'package:smart_hair_care/features/daily_log/providers/providers.dart';
import 'package:smart_hair_care/features/daily_log/view/add_edit_log_page.dart';
import 'package:smart_hair_care/features/daily_log/view/log_detail_page.dart';
import 'package:smart_hair_care/features/daily_log/widgets/widgets.dart';
import 'package:smart_hair_care/features/shared/widgets/widgets.dart';
import 'package:smart_hair_care/l10n/l10n.dart';

/// Page displaying daily log entries with a calendar view
class DailyLogPage extends ConsumerStatefulWidget {
  const DailyLogPage({super.key});

  /// Returns a [MaterialPageRoute] for Navigator 1.0 navigation
  static Route<void> getRoute() {
    return MaterialPageRoute<void>(
      builder: (_) => const DailyLogPage(),
      settings: const RouteSettings(name: '/daily-log'),
    );
  }

  @override
  ConsumerState<DailyLogPage> createState() => _DailyLogPageState();
}

class _DailyLogPageState extends ConsumerState<DailyLogPage> {
  DateTime _selectedMonth = DateTime.now();
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dailyLogsProvider);
    final logsGrouped = ref.watch(logsGroupedByDateProvider);
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.dailyLogTitle),
      ),
      body: Column(
        children: [
          // Month navigation
          _MonthSelector(
            selectedMonth: _selectedMonth,
            onPreviousMonth: () {
              setState(() {
                _selectedMonth = DateTime(
                  _selectedMonth.year,
                  _selectedMonth.month - 1,
                );
              });
            },
            onNextMonth: () {
              setState(() {
                _selectedMonth = DateTime(
                  _selectedMonth.year,
                  _selectedMonth.month + 1,
                );
              });
            },
          ),

          // Simple calendar grid
          _CalendarGrid(
            selectedMonth: _selectedMonth,
            selectedDate: _selectedDate,
            logsGrouped: logsGrouped,
            onDateSelected: (date) {
              setState(() => _selectedDate = date);
            },
          ),

          const Divider(),

          // Logs list
          Expanded(
            child: _buildLogsList(context, state, logsGrouped),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'daily_log_fab',
        onPressed: () => Navigator.push(
          context,
          AddEditLogPage.getRoute(initialDate: _selectedDate),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildLogsList(
    BuildContext context,
    DailyLogsState state,
    Map<DateTime, List<DailyLog>> logsGrouped,
  ) {
    if (state.isLoading && state.logs.isEmpty) {
      return const LoadingView();
    }

    if (state.error != null && state.logs.isEmpty) {
      return ErrorView(
        message: state.error!,
        onRetry: () => ref.read(dailyLogsProvider.notifier).loadLogs(),
      );
    }

    // Filter logs based on selected date or show all for the month
    final displayLogs = _selectedDate != null
        ? logsGrouped[_selectedDate] ?? []
        : state.logs.where((log) {
            return log.date.year == _selectedMonth.year &&
                log.date.month == _selectedMonth.month;
          }).toList();

    if (displayLogs.isEmpty) {
      return EmptyView(
        icon: Icons.calendar_today_outlined,
        title: _selectedDate != null
            ? context.l10n.dailyLogNoEntryForDate
            : context.l10n.dailyLogEmptyMessage,
        subtitle: context.l10n.dailyLogEmptyHint,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 88),
      itemCount: displayLogs.length,
      itemBuilder: (context, index) {
        final log = displayLogs[index];
        return DailyLogTile(
          log: log,
          onTap: () => Navigator.push(
            context,
            LogDetailPage.getRoute(logId: log.id),
          ),
        );
      },
    );
  }
}

class _MonthSelector extends StatelessWidget {
  const _MonthSelector({
    required this.selectedMonth,
    required this.onPreviousMonth,
    required this.onNextMonth,
  });

  final DateTime selectedMonth;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: onPreviousMonth,
          ),
          Text(
            '${months[selectedMonth.month - 1]} ${selectedMonth.year}',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: onNextMonth,
          ),
        ],
      ),
    );
  }
}

class _CalendarGrid extends StatelessWidget {
  const _CalendarGrid({
    required this.selectedMonth,
    required this.selectedDate,
    required this.logsGrouped,
    required this.onDateSelected,
  });

  final DateTime selectedMonth;
  final DateTime? selectedDate;
  final Map<DateTime, List<DailyLog>> logsGrouped;
  final ValueChanged<DateTime> onDateSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final firstDayOfMonth = DateTime(selectedMonth.year, selectedMonth.month);
    final lastDayOfMonth = DateTime(
      selectedMonth.year,
      selectedMonth.month + 1,
      0,
    );
    final firstWeekday = firstDayOfMonth.weekday % 7; // Sunday = 0
    final daysInMonth = lastDayOfMonth.day;

    const weekdays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Weekday headers
          Row(
            children: weekdays
                .map(
                  (day) => Expanded(
                    child: Center(
                      child: Text(
                        day,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 8),

          // Calendar days
          ...List.generate(
            ((firstWeekday + daysInMonth) / 7).ceil(),
            (week) {
              return Row(
                children: List.generate(7, (weekday) {
                  final dayIndex = week * 7 + weekday - firstWeekday + 1;
                  if (dayIndex < 1 || dayIndex > daysInMonth) {
                    return const Expanded(child: SizedBox(height: 40));
                  }

                  final date = DateTime(
                    selectedMonth.year,
                    selectedMonth.month,
                    dayIndex,
                  );
                  final hasLog = logsGrouped.containsKey(date);
                  final isSelected =
                      selectedDate != null &&
                      date.year == selectedDate!.year &&
                      date.month == selectedDate!.month &&
                      date.day == selectedDate!.day;
                  final isToday = _isToday(date);

                  return Expanded(
                    child: GestureDetector(
                      onTap: () => onDateSelected(date),
                      child: Container(
                        height: 40,
                        margin: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? theme.colorScheme.primary
                              : hasLog
                              ? theme.colorScheme.primaryContainer
                              : null,
                          border: isToday
                              ? Border.all(
                                  color: theme.colorScheme.primary,
                                  width: 2,
                                )
                              : null,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            '$dayIndex',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: isSelected
                                  ? theme.colorScheme.onPrimary
                                  : hasLog
                                  ? theme.colorScheme.onPrimaryContainer
                                  : null,
                              fontWeight: isToday || isSelected
                                  ? FontWeight.bold
                                  : null,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              );
            },
          ),
        ],
      ),
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }
}
