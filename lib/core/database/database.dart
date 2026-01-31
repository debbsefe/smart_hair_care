import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_hair_care/core/database/converters/specific_patterns_converter.dart';
import 'package:smart_hair_care/core/database/daos/daos.dart';
import 'package:smart_hair_care/core/database/tables/tables.dart';

part 'database.g.dart';

/// Main database class for the Smart Hair Care app
@DriftDatabase(
  tables: [Products, DailyLogs, HairProfiles],
  daos: [ProductsDao, DailyLogsDao, HairProfilesDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// Constructor for testing with custom query executor
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 2;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'smart_hair_care.db');
  }

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // During active development, drop and recreate all tables
        for (final table in allTables) {
          await m.deleteTable(table.actualTableName);
        }
        await m.createAll();
      },
      beforeOpen: (details) async {
        // Enable foreign keys
        await customStatement('PRAGMA foreign_keys = ON');
      },
    );
  }
}

/// Riverpod provider for the database instance
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

/// Convenience providers for DAOs
final productsDaoProvider = Provider<ProductsDao>((ref) {
  return ref.watch(databaseProvider).productsDao;
});

final dailyLogsDaoProvider = Provider<DailyLogsDao>((ref) {
  return ref.watch(databaseProvider).dailyLogsDao;
});

final hairProfilesDaoProvider = Provider<HairProfilesDao>((ref) {
  return ref.watch(databaseProvider).hairProfilesDao;
});
