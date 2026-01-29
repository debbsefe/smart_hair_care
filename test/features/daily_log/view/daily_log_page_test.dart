import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smart_hair_care/core/database/database.dart';
import 'package:smart_hair_care/features/daily_log/view/daily_log_page.dart';

import '../../../helpers/helpers.dart';

void main() {
  late MockDailyLogsDao mockDao;

  setUp(() {
    mockDao = MockDailyLogsDao();
  });

  group('DailyLogPage', () {
    testWidgets('shows empty state when no logs this month', (tester) async {
      when(() => mockDao.getAllLogs()).thenAnswer((_) async => []);

      await tester.pumpApp(
        const DailyLogPage(),
        overrides: [dailyLogsDaoProvider.overrideWithValue(mockDao)],
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.calendar_today_outlined), findsOneWidget);
    });

    testWidgets('has floating action button', (tester) async {
      when(() => mockDao.getAllLogs()).thenAnswer((_) async => []);

      await tester.pumpApp(
        const DailyLogPage(),
        overrides: [dailyLogsDaoProvider.overrideWithValue(mockDao)],
      );
      await tester.pumpAndSettle();

      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('shows app bar with title', (tester) async {
      when(() => mockDao.getAllLogs()).thenAnswer((_) async => []);

      await tester.pumpApp(
        const DailyLogPage(),
        overrides: [dailyLogsDaoProvider.overrideWithValue(mockDao)],
      );
      await tester.pumpAndSettle();

      expect(find.text('Daily Log'), findsOneWidget);
    });

    testWidgets('shows logs when they exist for current month', (tester) async {
      // Create a log for current month
      final now = DateTime.now();
      final log = DailyLog(
        id: 1,
        date: DateTime(now.year, now.month, 15),
        routineType: 'wash_day',
        createdAt: now,
      );
      when(() => mockDao.getAllLogs()).thenAnswer((_) async => [log]);

      await tester.pumpApp(
        const DailyLogPage(),
        overrides: [dailyLogsDaoProvider.overrideWithValue(mockDao)],
      );
      await tester.pumpAndSettle();

      // Should not show empty state icon
      expect(find.byIcon(Icons.calendar_today_outlined), findsNothing);
    });
  });
}
