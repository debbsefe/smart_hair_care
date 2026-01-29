import 'dart:async';

import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_hair_care/core/database/daos/hair_profiles_dao.dart';
import 'package:smart_hair_care/core/database/database.dart';

/// State class for hair profile
class HairProfileState extends Equatable {
  const HairProfileState({
    this.profile,
    this.isLoading = false,
    this.error,
    this.hasProfile = false,
  });

  final HairProfile? profile;
  final bool isLoading;
  final String? error;
  final bool hasProfile;

  @override
  List<Object?> get props => [profile, isLoading, error, hasProfile];

  HairProfileState copyWith({
    HairProfile? profile,
    bool? isLoading,
    String? error,
    bool? hasProfile,
  }) {
    return HairProfileState(
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      hasProfile: hasProfile ?? this.hasProfile,
    );
  }
}

/// Notifier for managing hair profile state (Riverpod 3)
class HairProfileNotifier extends Notifier<HairProfileState> {
  late final HairProfilesDao _dao;

  @override
  HairProfileState build() {
    _dao = ref.watch(hairProfilesDaoProvider);
    // Defer loading to avoid reading state during build
    unawaited(Future.microtask(_loadProfile));
    return const HairProfileState(isLoading: true);
  }

  Future<void> _loadProfile() async {
    state = state.copyWith(isLoading: true);
    try {
      final profile = await _dao.getProfile();
      state = state.copyWith(
        profile: profile,
        isLoading: false,
        hasProfile: profile != null,
      );
    } on Exception catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> loadProfile() => _loadProfile();

  /// Clears any error state
  void clearError() {
    if (state.error != null) {
      // ignore: avoid_redundant_argument_values, null clears existing error
      state = state.copyWith(error: null);
    }
  }

  Future<void> saveProfile({
    String? name,
    String? hairType,
    String? porosity,
    String? density,
    String? thickness,
    String? scalpType,
    double? hairLength,
    List<String>? concerns,
    List<String>? goals,
    bool? isColorTreated,
    bool? isHeatDamaged,
  }) async {
    try {
      await _dao.upsertProfile(
        HairProfilesCompanion(
          name: Value(name),
          hairType: Value(hairType),
          porosity: Value(porosity),
          density: Value(density),
          thickness: Value(thickness),
          scalpType: Value(scalpType),
          hairLength: Value(hairLength),
          concerns: Value(concerns?.join(',')),
          goals: Value(goals?.join(',')),
          isColorTreated: Value(isColorTreated ?? false),
          isHeatDamaged: Value(isHeatDamaged ?? false),
          lastUpdated: Value(DateTime.now()),
        ),
      );
      await _loadProfile();
    } on Exception catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> updateProfile(HairProfile profile) async {
    try {
      await _dao.updateProfile(profile);
      await _loadProfile();
    } on Exception catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}

/// Provider for hair profile state
final hairProfileProvider =
    NotifierProvider<HairProfileNotifier, HairProfileState>(
      HairProfileNotifier.new,
    );

/// Provider for checking if profile exists
final hasHairProfileProvider = Provider<bool>((ref) {
  return ref.watch(hairProfileProvider).hasProfile;
});
