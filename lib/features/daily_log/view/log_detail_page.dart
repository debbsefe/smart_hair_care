import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_hair_care/core/database/database.dart';
import 'package:smart_hair_care/core/models/models.dart';
import 'package:smart_hair_care/features/daily_log/notifiers/notifiers.dart';
import 'package:smart_hair_care/features/daily_log/view/add_edit_log_page.dart';
import 'package:smart_hair_care/features/daily_log/widgets/widgets.dart';
import 'package:smart_hair_care/features/shared/utils/date_formatter.dart';
import 'package:smart_hair_care/l10n/l10n.dart';

/// Page displaying detailed information about a single daily log entry
class LogDetailPage extends ConsumerWidget {
  const LogDetailPage({
    required this.logId,
    super.key,
  });

  final int logId;

  /// Returns a [MaterialPageRoute] for Navigator 1.0 navigation
  static Route<void> getRoute({required int logId}) {
    return MaterialPageRoute<void>(
      builder: (_) => LogDetailPage(logId: logId),
      settings: RouteSettings(name: '/daily-log/$logId'),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logAsync = ref.watch(dailyLogByIdProvider(logId));
    final l10n = context.l10n;

    return logAsync.when(
      data: (log) {
        if (log == null) {
          return Scaffold(
            appBar: AppBar(title: Text(l10n.logDetailTitle)),
            body: const Center(child: Text('Log entry not found')),
          );
        }
        return _LogDetailView(log: log);
      },
      loading: () => Scaffold(
        appBar: AppBar(title: Text(l10n.logDetailTitle)),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        appBar: AppBar(title: Text(l10n.logDetailTitle)),
        body: Center(child: Text('Error: $error')),
      ),
    );
  }
}

class _LogDetailView extends ConsumerWidget {
  const _LogDetailView({required this.log});

  final DailyLog log;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final routineType = RoutineType.fromValue(log.routineType);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.logDetailTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => Navigator.push(
              context,
              AddEditLogPage.getRoute(log: log),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _confirmDelete(context, ref),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with date and routine type
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _getRoutineIcon(routineType),
                          size: 32,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          routineType.label,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${DateFormatter.weekdayLong(log.date)}, '
                      '${DateFormatter.long(log.date)}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Hair condition rating
            if (log.hairConditionRating != null)
              _DetailCard(
                title: l10n.logHairConditionLabel,
                child: Row(
                  children: List.generate(
                    5,
                    (index) => Icon(
                      index < log.hairConditionRating!
                          ? Icons.star
                          : Icons.star_border,
                      size: 32,
                      color: Colors.amber.shade600,
                    ),
                  ),
                ),
              ),

            // Weather conditions
            if (log.weather != null || log.humidityLevel != null)
              _DetailCard(
                title: l10n.logWeatherLabel,
                child: Row(
                  children: [
                    if (log.weather != null) ...[
                      Icon(
                        Icons.cloud_outlined,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(log.weather!, style: theme.textTheme.bodyLarge),
                      const SizedBox(width: 24),
                    ],
                    if (log.humidityLevel != null) ...[
                      Icon(
                        Icons.water_drop_outlined,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${log.humidityLevel}% humidity',
                        style: theme.textTheme.bodyLarge,
                      ),
                    ],
                  ],
                ),
              ),

            // Products used
            if (log.productsUsed != null && log.productsUsed!.isNotEmpty)
              _DetailCard(
                title: l10n.logProductsUsedLabel,
                child: ProductNamesDisplay(
                  productIds: log.productsUsed!,
                  style: theme.textTheme.bodyLarge,
                ),
              ),

            // Techniques
            if (log.techniques != null && log.techniques!.isNotEmpty)
              _DetailCard(
                title: l10n.logTechniquesLabel,
                child: Text(
                  log.techniques!,
                  style: theme.textTheme.bodyLarge,
                ),
              ),

            // Notes
            if (log.notes != null && log.notes!.isNotEmpty)
              _DetailCard(
                title: l10n.logNotesLabel,
                child: Text(
                  log.notes!,
                  style: theme.textTheme.bodyLarge,
                ),
              ),
          ],
        ),
      ),
    );
  }

  IconData _getRoutineIcon(RoutineType type) {
    return switch (type) {
      RoutineType.washDay => Icons.shower,
      RoutineType.refresh => Icons.refresh,
      RoutineType.protectiveStyle => Icons.shield_outlined,
      RoutineType.treatment => Icons.spa_outlined,
      RoutineType.other => Icons.calendar_today,
    };
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Log Entry'),
        content: const Text('Are you sure you want to delete this log entry?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if ((confirmed ?? false) && context.mounted) {
      await ref.read(dailyLogsProvider.notifier).deleteLog(log.id);
      if (context.mounted) Navigator.pop(context);
    }
  }
}

class _DetailCard extends StatelessWidget {
  const _DetailCard({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }
}
