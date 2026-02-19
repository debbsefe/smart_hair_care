// Ignore for testing purposes
// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smart_hair_care/app/app.dart';
import 'package:smart_hair_care/core/database/database.dart';
import 'package:smart_hair_care/features/home/home.dart';

import '../../fixtures/fixtures.dart';
import '../../helpers/helpers.dart';

void main() {
  late MockProductsDao mockProductsDao;
  late MockDailyLogsDao mockDailyLogsDao;
  late MockHairProfilesDao mockHairProfilesDao;

  setUp(() {
    mockProductsDao = MockProductsDao();
    mockDailyLogsDao = MockDailyLogsDao();
    mockHairProfilesDao = MockHairProfilesDao();

    // Setup default behaviors
    when(() => mockProductsDao.getAllProducts()).thenAnswer((_) async => []);
    when(() => mockDailyLogsDao.getAllLogs()).thenAnswer((_) async => []);
    when(() => mockHairProfilesDao.getProfile()).thenAnswer((_) async => null);
  });

  group('App', () {
    testWidgets('renders HomePage', (tester) async {
      await tester.pumpApp(
        App(),
        overrides: [
          productsDaoProvider.overrideWithValue(mockProductsDao),
          dailyLogsDaoProvider.overrideWithValue(mockDailyLogsDao),
          hairProfilesDaoProvider.overrideWithValue(mockHairProfilesDao),
        ],
      );
      await tester.pumpAndSettle();
      expect(find.byType(HomePage), findsOneWidget);
    });
  });
}
