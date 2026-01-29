import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hair_care/core/database/daos/hair_profiles_dao.dart';
import 'package:smart_hair_care/core/database/database.dart';

void main() {
  late AppDatabase db;
  late HairProfilesDao dao;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    dao = HairProfilesDao(db);
  });

  tearDown(() async {
    await db.close();
  });

  HairProfilesCompanion createTestProfile({
    String? name,
    String? hairType,
  }) {
    return HairProfilesCompanion.insert(
      name: name != null ? Value(name) : const Value.absent(),
      hairType: hairType != null ? Value(hairType) : const Value.absent(),
    );
  }

  group('HairProfilesDao', () {
    test('insertProfile returns new id', () async {
      final id = await dao.insertProfile(createTestProfile(name: 'My Hair'));

      expect(id, isPositive);
    });

    test('getProfile returns null initially', () async {
      final profile = await dao.getProfile();

      expect(profile, isNull);
    });

    test('getProfile returns profile when exists', () async {
      await dao.insertProfile(createTestProfile(name: 'My Curly Hair'));

      final profile = await dao.getProfile();

      expect(profile, isNotNull);
      expect(profile!.name, 'My Curly Hair');
    });

    test('updateProfile modifies profile', () async {
      await dao.insertProfile(createTestProfile(name: 'Original'));
      final profile = await dao.getProfile();

      final updated = profile!.copyWith(name: const Value('Updated'));
      await dao.updateProfile(updated);

      final result = await dao.getProfile();
      expect(result!.name, 'Updated');
    });

    test('upsertProfile inserts when no profile exists', () async {
      await dao.upsertProfile(createTestProfile(name: 'New Profile'));

      final profile = await dao.getProfile();
      expect(profile, isNotNull);
      expect(profile!.name, 'New Profile');
    });

    test('upsertProfile updates when profile exists', () async {
      await dao.insertProfile(createTestProfile(name: 'Original'));

      await dao.upsertProfile(
        const HairProfilesCompanion(name: Value('Updated')),
      );

      final profile = await dao.getProfile();
      expect(profile!.name, 'Updated');
    });

    test('deleteProfile removes profile', () async {
      final id = await dao.insertProfile(createTestProfile());

      await dao.deleteProfile(id);

      final profile = await dao.getProfile();
      expect(profile, isNull);
    });

    test('watchProfile streams updates', () async {
      final stream = dao.watchProfile();

      final firstEmission = await stream.first;
      expect(firstEmission, isNull);

      await dao.insertProfile(createTestProfile(name: 'Streamed'));

      final secondEmission = await stream.first;
      expect(secondEmission, isNotNull);
      expect(secondEmission!.name, 'Streamed');
    });
  });
}
