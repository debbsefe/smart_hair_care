import 'package:drift/drift.dart';
import 'package:smart_hair_care/core/database/converters/specific_patterns_converter.dart';

/// User's hair profile information
class HairProfiles extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().nullable()(); // User's name
  // Straight, Wavy, Curly, Coily
  TextColumn get primaryType => text().nullable()();
  // JSON array: ["3A", "3C"]
  TextColumn get specificPatterns => text()
      .map(const SpecificPatternsConverter())
      .withDefault(const Constant('[]'))();
  // true if multiple patterns
  BoolColumn get isMultiTextured =>
      boolean().withDefault(const Constant(false))();
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
