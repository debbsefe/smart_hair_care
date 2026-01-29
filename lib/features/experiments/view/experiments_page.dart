import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_hair_care/core/database/database.dart';
import 'package:smart_hair_care/core/models/models.dart';
import 'package:smart_hair_care/features/experiments/providers/providers.dart';
import 'package:smart_hair_care/features/experiments/view/add_experiment_page.dart';
import 'package:smart_hair_care/features/experiments/view/experiment_detail_page.dart';
import 'package:smart_hair_care/features/experiments/widgets/widgets.dart';
import 'package:smart_hair_care/features/shared/widgets/widgets.dart';
import 'package:smart_hair_care/l10n/l10n.dart';

/// Page displaying the list of hair experiments
class ExperimentsPage extends ConsumerWidget {
  const ExperimentsPage({super.key});

  /// Returns a [MaterialPageRoute] for Navigator 1.0 navigation
  static Route<void> getRoute() {
    return MaterialPageRoute<void>(
      builder: (_) => const ExperimentsPage(),
      settings: const RouteSettings(name: '/experiments'),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(experimentsProvider);
    final filteredExperiments = ref.watch(filteredExperimentsProvider);
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.experimentsTitle),
      ),
      body: Column(
        children: [
          // Filter tabs
          _FilterTabs(
            currentFilter: state.filter,
            onFilterChanged: (filter) =>
                ref.read(experimentsProvider.notifier).setFilter(filter),
          ),

          // Experiments list
          Expanded(
            child: _buildBody(context, ref, state, filteredExperiments),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'experiments_fab',
        onPressed: () => Navigator.push(context, AddExperimentPage.getRoute()),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    ExperimentsState state,
    List<Experiment> experiments,
  ) {
    if (state.isLoading && state.experiments.isEmpty) {
      return const LoadingView();
    }

    if (state.error != null && state.experiments.isEmpty) {
      return ErrorView(
        message: state.error!,
        onRetry: () => ref.read(experimentsProvider.notifier).loadExperiments(),
      );
    }

    if (experiments.isEmpty) {
      return EmptyView(
        icon: Icons.science_outlined,
        title: _getEmptyMessage(context, state.filter),
        subtitle: context.l10n.experimentsEmptyHint,
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(experimentsProvider.notifier).loadExperiments(),
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 8, bottom: 88),
        itemCount: experiments.length,
        itemBuilder: (context, index) {
          final experiment = experiments[index];
          return ExperimentTile(
            experiment: experiment,
            onTap: () => Navigator.push(
              context,
              ExperimentDetailPage.getRoute(experimentId: experiment.id),
            ),
          );
        },
      ),
    );
  }

  String _getEmptyMessage(BuildContext context, ExperimentStatus filter) {
    final l10n = context.l10n;
    return switch (filter) {
      ExperimentStatus.active => l10n.experimentsNoActive,
      ExperimentStatus.completed => l10n.experimentsNoCompleted,
      ExperimentStatus.abandoned => l10n.experimentsNoAbandoned,
    };
  }
}

class _FilterTabs extends StatelessWidget {
  const _FilterTabs({
    required this.currentFilter,
    required this.onFilterChanged,
  });

  final ExperimentStatus currentFilter;
  final ValueChanged<ExperimentStatus> onFilterChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: ExperimentStatus.values.map((status) {
          final isSelected = currentFilter == status;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: ChoiceChip(
                label: Text(status.label),
                selected: isSelected,
                onSelected: (_) => onFilterChanged(status),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
