import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_hair_care/core/database/daos/hair_profiles_dao.dart';
import 'package:smart_hair_care/core/database/database.dart';

/// Notifier for managing hair profile (Riverpod 3 AsyncNotifier)
class HairProfileNotifier extends AsyncNotifier<HairProfile?> {
  late final HairProfilesDao _dao;

  @override
  Future<HairProfile?> build() async {
    _dao = ref.watch(hairProfilesDaoProvider);
    return _dao.getProfile();
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
    ref.invalidateSelf();
  }

  Future<void> updateProfile(HairProfile profile) async {
    await _dao.updateProfile(profile);
    ref.invalidateSelf();
  }
}

/// Provider for hair profile
final hairProfileProvider =
    AsyncNotifierProvider<HairProfileNotifier, HairProfile?>(
      HairProfileNotifier.new,
    );

/// Provider for checking if profile exists
final hasHairProfileProvider = Provider<bool>((ref) {
  final profileAsync = ref.watch(hairProfileProvider);
  return profileAsync.when(
    data: (profile) => profile != null,
    loading: () => false,
    error: (_, _) => false,
  );
});
