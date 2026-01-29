import 'package:flutter/material.dart';
import 'package:smart_hair_care/core/database/database.dart';
import 'package:smart_hair_care/core/models/models.dart';
import 'package:smart_hair_care/features/shared/utils/date_formatter.dart';

/// A card widget displaying experiment information
class ExperimentTile extends StatelessWidget {
  const ExperimentTile({
    required this.experiment,
    this.onTap,
    super.key,
  });

  final Experiment experiment;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final status = ExperimentStatus.fromValue(experiment.status);
    final daysSinceStart = DateTime.now()
        .difference(experiment.startDate)
        .inDays;

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
                children: [
                  Expanded(
                    child: Text(
                      experiment.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _StatusBadge(status: status),
                ],
              ),
              if (experiment.hypothesis != null &&
                  experiment.hypothesis!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  experiment.hypothesis!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 16,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    DateFormatter.short(experiment.startDate),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.timer_outlined,
                    size: 16,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$daysSinceStart days',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (experiment.successRating != null) ...[
                    const Spacer(),
                    ...List.generate(
                      5,
                      (index) => Icon(
                        index < experiment.successRating!
                            ? Icons.star
                            : Icons.star_border,
                        size: 16,
                        color: Colors.amber.shade600,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final ExperimentStatus status;

  @override
  Widget build(BuildContext context) {
    final (color, bgColor) = switch (status) {
      ExperimentStatus.active => (
        Colors.blue.shade700,
        Colors.blue.shade50,
      ),
      ExperimentStatus.completed => (
        Colors.green.shade700,
        Colors.green.shade50,
      ),
      ExperimentStatus.abandoned => (
        Colors.grey.shade700,
        Colors.grey.shade200,
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
