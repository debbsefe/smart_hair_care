import 'package:intl/intl.dart';

/// Date formatting utilities for consistent date display across the app
class DateFormatter {
  DateFormatter._();

  static final _shortDate = DateFormat.yMMMd(); // Jan 29, 2026
  static final _longDate = DateFormat.yMMMMd(); // January 29, 2026
  static final _monthDay = DateFormat.MMMd(); // Jan 29
  static final _monthYear = DateFormat.yMMM(); // Jan 2026
  static final _weekdayShort = DateFormat.E(); // Wed
  static final _weekdayLong = DateFormat.EEEE(); // Wednesday
  static final _time = DateFormat.jm(); // 5:08 PM

  /// Format as "Jan 29, 2026"
  static String short(DateTime date) => _shortDate.format(date);

  /// Format as "January 29, 2026"
  static String long(DateTime date) => _longDate.format(date);

  /// Format as "Jan 29"
  static String monthDay(DateTime date) => _monthDay.format(date);

  /// Format as "Jan 2026"
  static String monthYear(DateTime date) => _monthYear.format(date);

  /// Format as "Wed"
  static String weekdayShort(DateTime date) => _weekdayShort.format(date);

  /// Format as "Wednesday"
  static String weekdayLong(DateTime date) => _weekdayLong.format(date);

  /// Format as "5:08 PM"
  static String time(DateTime date) => _time.format(date);

  /// Format as "Wed, Jan 29"
  static String weekdayMonthDay(DateTime date) =>
      '${weekdayShort(date)}, ${monthDay(date)}';
}
