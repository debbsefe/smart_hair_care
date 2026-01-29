import 'package:drift/drift.dart';

/// User's hair profile information
class HairProfiles extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().nullable()(); // User's name
  TextColumn get hairType => text().nullable()(); // 1a-4c
  TextColumn get porosity => text().nullable()(); // low, medium, high
  TextColumn get density => text().nullable()(); // low, medium, high
  TextColumn get thickness => text().nullable()(); // fine, medium, coarse
  TextColumn get scalpType => text().nullable()(); // dry, normal, oily
  RealColumn get hairLength => real().nullable()(); // in cm
  TextColumn get concerns =>
      text().nullable()(); // Comma-separated: breakage, frizz
  TextColumn get goals => text().nullable()(); // Comma-separated goals
  BoolColumn get isColorTreated =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get isHeatDamaged =>
      boolean().withDefault(const Constant(false))();
  DateTimeColumn get lastUpdated =>
      dateTime().withDefault(currentDateAndTime)();
}
