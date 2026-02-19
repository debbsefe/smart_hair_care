// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_logs_dao.dart';

// ignore_for_file: type=lint
mixin _$DailyLogsDaoMixin on DatabaseAccessor<AppDatabase> {
  $DailyLogsTable get dailyLogs => attachedDatabase.dailyLogs;
  DailyLogsDaoManager get managers => DailyLogsDaoManager(this);
}

class DailyLogsDaoManager {
  final _$DailyLogsDaoMixin _db;
  DailyLogsDaoManager(this._db);
  $$DailyLogsTableTableManager get dailyLogs =>
      $$DailyLogsTableTableManager(_db.attachedDatabase, _db.dailyLogs);
}
