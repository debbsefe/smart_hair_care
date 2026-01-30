import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_hair_care/core/core.dart';
import 'package:smart_hair_care/features/experiments/experiments.dart';
import 'package:smart_hair_care/features/shared/utils/date_formatter.dart';
import 'package:smart_hair_care/l10n/l10n.dart';

/// Page displaying detailed information about a single experiment
class ExperimentDetailPage extends ConsumerWidget {
  const ExperimentDetailPage({
    required this.experimentId,
    super.key,
  });

  final int experimentId;

  /// Returns a [MaterialPageRoute] for Navigator 1.0 navigation
  static Route<void> getRoute({required int experimentId}) {
    return MaterialPageRoute<void>(
      builder: (_) => ExperimentDetailPage(experimentId: experimentId),
      settings: RouteSettings(name: '/experiments/$experimentId'),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final experimentAsync = ref.watch(experimentByIdProvider(experimentId));
    final l10n = context.l10n;

    return experimentAsync.when(
      data: (experiment) {
        if (experiment == null) {
          return Scaffold(
            appBar: AppBar(title: Text(l10n.experimentDetailTitle)),
            body: const Center(child: Text('Experiment not found')),
          );
        }
        return _ExperimentDetailView(experiment: experiment);
      },
      loading: () => Scaffold(
        appBar: AppBar(title: Text(l10n.experimentDetailTitle)),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        appBar: AppBar(title: Text(l10n.experimentDetailTitle)),
        body: Center(child: Text('Error: $error')),
      ),
    );
  }
}

class _ExperimentDetailView extends ConsumerWidget {
  const _ExperimentDetailView({required this.experiment});

  final Experiment experiment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final status = ExperimentStatus.fromValue(experiment.status);
    final isActive = status == ExperimentStatus.active;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.experimentDetailTitle),
        actions: [
          if (isActive)
            PopupMenuButton<String>(
              onSelected: (value) async {
                switch (value) {
                  case 'complete':
                    await _showCompleteDialog(context, ref);
                  case 'abandon':
                    await _confirmAbandon(context, ref);
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'complete',
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle_outline),
                      const SizedBox(width: 8),
                      Text(l10n.experimentComplete),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'abandon',
                  child: Row(
                    children: [
                      Icon(
                        Icons.cancel_outlined,
                        color: theme.colorScheme.error,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        l10n.experimentAbandon,
                        style: TextStyle(color: theme.colorScheme.error),
                      ),
                    ],
                  ),
                ),
              ],
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
            // Header
            Card(
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
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        _buildStatusBadge(status, theme),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 18,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Started: '
                          '${DateFormatter.short(experiment.startDate)}',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    if (experiment.endDate != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.event_available,
                            size: 18,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Ended: '
                            '${DateFormatter.short(experiment.endDate!)}',
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ],
                    if (experiment.successRating != null) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text('Success: ', style: theme.textTheme.bodyMedium),
                          ...List.generate(
                            5,
                            (index) => Icon(
                              index < experiment.successRating!
                                  ? Icons.star
                                  : Icons.star_border,
                              size: 24,
                              color: Colors.amber.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Hypothesis
            if (experiment.hypothesis != null &&
                experiment.hypothesis!.isNotEmpty)
              _DetailSection(
                title: l10n.experimentHypothesisLabel,
                icon: Icons.lightbulb_outline,
                content: experiment.hypothesis!,
              ),

            // Method
            if (experiment.method != null && experiment.method!.isNotEmpty)
              _DetailSection(
                title: l10n.experimentMethodLabel,
                icon: Icons.list_alt,
                content: experiment.method!,
              ),

            // Variables
            if (experiment.variables != null &&
                experiment.variables!.isNotEmpty)
              _DetailSection(
                title: l10n.experimentVariablesLabel,
                icon: Icons.tune,
                content: experiment.variables!,
              ),

            // Observations
            _ObservationsSection(
              observations: experiment.observations,
              isActive: isActive,
              onAddObservation: () => _showAddObservationDialog(context, ref),
            ),

            // Results (for completed experiments)
            if (experiment.results != null && experiment.results!.isNotEmpty)
              _DetailSection(
                title: l10n.experimentResultsLabel,
                icon: Icons.analytics_outlined,
                content: experiment.results!,
              ),

            // Conclusion
            if (experiment.conclusion != null &&
                experiment.conclusion!.isNotEmpty)
              _DetailSection(
                title: l10n.experimentConclusionLabel,
                icon: Icons.check_circle_outline,
                content: experiment.conclusion!,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(ExperimentStatus status, ThemeData theme) {
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          color: color,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Future<void> _showAddObservationDialog(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final controller = TextEditingController();
    final l10n = context.l10n;

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.experimentAddObservation),
        content: TextField(
          controller: controller,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: l10n.experimentObservationHint,
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancelButton),
          ),
          FilledButton(
            onPressed: () async {
              if (controller.text.trim().isNotEmpty) {
                await ref
                    .read(experimentsProvider.notifier)
                    .addObservation(experiment.id, controller.text.trim());
                if (context.mounted) Navigator.pop(context);
              }
            },
            child: Text(l10n.addButton),
          ),
        ],
      ),
    );
  }

  Future<void> _showCompleteDialog(BuildContext context, WidgetRef ref) async {
    final resultsController = TextEditingController();
    final conclusionController = TextEditingController();
    int? rating;
    final l10n = context.l10n;

    await showDialog<void>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(l10n.experimentCompleteTitle),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: resultsController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: l10n.experimentResultsLabel,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: conclusionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: l10n.experimentConclusionLabel,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                Text(l10n.experimentSuccessRating),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    final starRating = index + 1;
                    return IconButton(
                      icon: Icon(
                        rating != null && starRating <= rating!
                            ? Icons.star
                            : Icons.star_border,
                        color: Colors.amber.shade600,
                        size: 32,
                      ),
                      onPressed: () => setState(() => rating = starRating),
                    );
                  }),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancelButton),
            ),
            FilledButton(
              onPressed: () async {
                await ref
                    .read(experimentsProvider.notifier)
                    .completeExperiment(
                      id: experiment.id,
                      results: resultsController.text.trim(),
                      conclusion: conclusionController.text.trim(),
                      successRating: rating,
                    );
                if (context.mounted) Navigator.pop(context);
              },
              child: Text(l10n.experimentComplete),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmAbandon(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.experimentAbandonTitle),
        content: Text(l10n.experimentAbandonMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancelButton),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(l10n.experimentAbandon),
          ),
        ],
      ),
    );

    if (confirmed ?? false) {
      await ref
          .read(experimentsProvider.notifier)
          .abandonExperiment(experiment.id);
    }
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.experimentDeleteTitle),
        content: Text(l10n.experimentDeleteMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancelButton),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(l10n.deleteButton),
          ),
        ],
      ),
    );

    if ((confirmed ?? false) && context.mounted) {
      await ref
          .read(experimentsProvider.notifier)
          .deleteExperiment(experiment.id);
      if (context.mounted) Navigator.pop(context);
    }
  }
}

class _DetailSection extends StatelessWidget {
  const _DetailSection({
    required this.title,
    required this.icon,
    required this.content,
  });

  final String title;
  final IconData icon;
  final String content;

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
            Row(
              children: [
                Icon(icon, size: 20, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(content, style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

class _ObservationsSection extends StatelessWidget {
  const _ObservationsSection({
    required this.observations,
    required this.isActive,
    required this.onAddObservation,
  });

  final String? observations;
  final bool isActive;
  final VoidCallback onAddObservation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
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
                      Icons.visibility_outlined,
                      size: 20,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l10n.experimentObservationsLabel,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                if (isActive)
                  TextButton.icon(
                    onPressed: onAddObservation,
                    icon: const Icon(Icons.add, size: 18),
                    label: Text(l10n.addButton),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            if (observations != null && observations!.isNotEmpty)
              Text(observations!, style: theme.textTheme.bodyMedium)
            else
              Text(
                l10n.experimentNoObservations,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontStyle: FontStyle.italic,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
