import 'dart:async';

import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_hair_care/core/database/daos/experiments_dao.dart';
import 'package:smart_hair_care/core/database/database.dart';
import 'package:smart_hair_care/core/models/models.dart';

/// State class for experiments
class ExperimentsState extends Equatable {
  const ExperimentsState({
    this.experiments = const [],
    this.isLoading = false,
    this.error,
    this.filter = ExperimentStatus.active,
  });

  final List<Experiment> experiments;
  final bool isLoading;
  final String? error;
  final ExperimentStatus filter;

  @override
  List<Object?> get props => [experiments, isLoading, error, filter];

  ExperimentsState copyWith({
    List<Experiment>? experiments,
    bool? isLoading,
    String? error,
    ExperimentStatus? filter,
  }) {
    return ExperimentsState(
      experiments: experiments ?? this.experiments,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      filter: filter ?? this.filter,
    );
  }
}

/// Notifier for managing experiments state (Riverpod 3)
class ExperimentsNotifier extends Notifier<ExperimentsState> {
  late final ExperimentsDao _dao;

  @override
  ExperimentsState build() {
    _dao = ref.watch(experimentsDaoProvider);
    // ignore: discarded_futures, load data after build completes
    Future.microtask(_loadExperiments);
    return const ExperimentsState(isLoading: true);
  }

  Future<void> _loadExperiments() async {
    state = state.copyWith(isLoading: true);
    try {
      final experiments = await _dao.getAllExperiments();
      state = state.copyWith(experiments: experiments, isLoading: false);
    } on Exception catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> loadExperiments() => _loadExperiments();

  /// Clears any error state
  void clearError() {
    if (state.error != null) {
      // ignore: avoid_redundant_argument_values, null clears existing error
      state = state.copyWith(error: null);
    }
  }

  void setFilter(ExperimentStatus filter) {
    state = state.copyWith(filter: filter);
  }

  Future<void> addExperiment({
    required String name,
    required DateTime startDate,
    String? hypothesis,
    String? method,
    String? variables,
  }) async {
    try {
      await _dao.insertExperiment(
        ExperimentsCompanion(
          name: Value(name),
          startDate: Value(startDate),
          hypothesis: Value(hypothesis),
          method: Value(method),
          variables: Value(variables),
          status: const Value('active'),
        ),
      );
      await _loadExperiments();
    } on Exception catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> updateExperiment(Experiment experiment) async {
    try {
      await _dao.updateExperiment(experiment);
      await _loadExperiments();
    } on Exception catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> addObservation(int id, String observation) async {
    try {
      final experiment = await _dao.getExperimentById(id);
      if (experiment != null) {
        final existingObs = experiment.observations ?? '';
        final timestamp = DateTime.now().toIso8601String().split('T')[0];
        final newObs = existingObs.isEmpty
            ? '[$timestamp] $observation'
            : '$existingObs\n[$timestamp] $observation';

        await _dao.updateExperiment(
          experiment.copyWith(observations: Value(newObs)),
        );
        await _loadExperiments();
      }
    } on Exception catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> completeExperiment({
    required int id,
    required String results,
    required String conclusion,
    int? successRating,
  }) async {
    try {
      await _dao.completeExperiment(
        id,
        results: results,
        conclusion: conclusion,
        successRating: successRating,
      );
      await _loadExperiments();
    } on Exception catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> abandonExperiment(int id) async {
    try {
      await _dao.updateStatus(id, 'abandoned');
      await _loadExperiments();
    } on Exception catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> deleteExperiment(int id) async {
    try {
      await _dao.deleteExperiment(id);
      await _loadExperiments();
    } on Exception catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}

/// Provider for experiments state
final experimentsProvider =
    NotifierProvider<ExperimentsNotifier, ExperimentsState>(
      ExperimentsNotifier.new,
    );

/// Provider for a single experiment by ID
final experimentByIdProvider = FutureProvider.family<Experiment?, int>((
  ref,
  id,
) async {
  final dao = ref.watch(experimentsDaoProvider);
  return dao.getExperimentById(id);
});

/// Provider for filtered experiments based on current filter
final filteredExperimentsProvider = Provider<List<Experiment>>((ref) {
  final state = ref.watch(experimentsProvider);
  return state.experiments
      .where((e) => e.status == state.filter.value)
      .toList();
});

/// Provider for active experiments count
final activeExperimentsCountProvider = Provider<int>((ref) {
  final state = ref.watch(experimentsProvider);
  return state.experiments.where((e) => e.status == 'active').length;
});
