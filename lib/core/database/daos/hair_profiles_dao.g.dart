// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hair_profiles_dao.dart';

// ignore_for_file: type=lint
mixin _$HairProfilesDaoMixin on DatabaseAccessor<AppDatabase> {
  $HairProfilesTable get hairProfiles => attachedDatabase.hairProfiles;
  HairProfilesDaoManager get managers => HairProfilesDaoManager(this);
}

class HairProfilesDaoManager {
  final _$HairProfilesDaoMixin _db;
  HairProfilesDaoManager(this._db);
  $$HairProfilesTableTableManager get hairProfiles =>
      $$HairProfilesTableTableManager(_db.attachedDatabase, _db.hairProfiles);
}
