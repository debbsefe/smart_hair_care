import 'package:drift/drift.dart';

/// Daily hair care routine logs
class DailyLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  TextColumn get routineType => text()(); // wash_day, refresh, protective_style
  TextColumn get productsUsed =>
      text().nullable()(); // Comma-separated product IDs
  TextColumn get techniques =>
      text().nullable()(); // Comma-separated techniques
  IntColumn get hairConditionRating => integer().nullable()(); // 1-5 scale
  TextColumn get weather => text().nullable()();
  IntColumn get humidityLevel => integer().nullable()(); // 0-100 percentage
  TextColumn get notes => text().nullable()();
  TextColumn get photoUrls => text().nullable()(); // Comma-separated URLs
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
