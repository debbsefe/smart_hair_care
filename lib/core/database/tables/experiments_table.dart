import 'package:drift/drift.dart';

/// Hair care experiments/tests
class Experiments extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get hypothesis => text().nullable()();
  TextColumn get method => text().nullable()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime().nullable()();
  TextColumn get status => text().withDefault(
    const Constant('active'),
  )(); // active, completed, abandoned
  TextColumn get variables => text().nullable()(); // What's being tested
  TextColumn get observations => text().nullable()(); // Dated observations
  TextColumn get results => text().nullable()();
  TextColumn get conclusion => text().nullable()();
  IntColumn get successRating => integer().nullable()(); // 1-5
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
