import 'package:drift/drift.dart';
import 'package:smart_hair_care/core/database/database.dart';
import 'package:smart_hair_care/core/database/tables/hair_profiles_table.dart';

part 'hair_profiles_dao.g.dart';

/// Data Access Object for HairProfiles table
@DriftAccessor(tables: [HairProfiles])
class HairProfilesDao extends DatabaseAccessor<AppDatabase>
    with _$HairProfilesDaoMixin {
  HairProfilesDao(super.attachedDatabase);

  // Read operations - typically only one profile per user
  Future<HairProfile?> getProfile() => select(hairProfiles).getSingleOrNull();

  Stream<HairProfile?> watchProfile() =>
      select(hairProfiles).watchSingleOrNull();

  // Create/Update operations
  Future<int> insertProfile(HairProfilesCompanion profile) =>
      into(hairProfiles).insert(profile);

  Future<bool> updateProfile(HairProfile profile) =>
      update(hairProfiles).replace(profile);

  Future<void> upsertProfile(HairProfilesCompanion profile) async {
    final existing = await getProfile();
    if (existing != null) {
      await (update(
        hairProfiles,
      )..where((p) => p.id.equals(existing.id))).write(profile);
    } else {
      await into(hairProfiles).insert(profile);
    }
  }

  // Delete operations
  Future<int> deleteProfile(int id) =>
      (delete(hairProfiles)..where((p) => p.id.equals(id))).go();

  /// Update curl pattern selection (primary type + specific patterns)
  Future<void> updateCurlPatterns({
    required int profileId,
    required String? primaryType,
    required List<String> specificPatterns,
  }) async {
    final isMulti = specificPatterns.length > 1;
    await (update(hairProfiles)..where((p) => p.id.equals(profileId))).write(
      HairProfilesCompanion(
        primaryType: Value(primaryType),
        specificPatterns: Value(specificPatterns),
        isMultiTextured: Value(isMulti),
        lastUpdated: Value(DateTime.now()),
      ),
    );
  }
}
