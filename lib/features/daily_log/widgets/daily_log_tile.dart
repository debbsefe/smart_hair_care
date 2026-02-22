import 'package:flutter/material.dart';
import 'package:smart_hair_care/core/database/database.dart';
import 'package:smart_hair_care/core/models/models.dart';
import 'package:smart_hair_care/features/shared/utils/date_formatter.dart';

/// A card widget displaying a daily log entry
class DailyLogTile extends StatelessWidget {
  const DailyLogTile({
    required this.log,
    this.onTap,
    this.onDelete,
    super.key,
  });

  final DailyLog log;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final routineType = RoutineType.fromValue(log.routineType);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        _getRoutineIcon(routineType),
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        routineType.label,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    DateFormatter.short(log.date),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              if (log.hairConditionRating != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      'Hair Condition: ',
                      style: theme.textTheme.bodySmall,
                    ),
                    ...List.generate(
                      5,
                      (index) => Icon(
                        index < log.hairConditionRating!
                            ? Icons.star
                            : Icons.star_border,
                        size: 16,
                        color: Colors.amber.shade600,
                      ),
                    ),
                  ],
                ),
              ],
              if (log.notes != null && log.notes!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  log.notes!,
                  style: theme.textTheme.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              if (log.hairLength != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.straighten,
                      size: 16,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${log.hairLength!.round()} cm',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
              if (log.weather != null || log.humidityLevel != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    if (log.weather != null) ...[
                      Icon(
                        Icons.cloud_outlined,
                        size: 16,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        log.weather!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(width: 16),
                    ],
                    if (log.humidityLevel != null) ...[
                      Icon(
                        Icons.water_drop_outlined,
                        size: 16,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${log.humidityLevel}%',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ],
          ),
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
}
