import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smart_hair_care/core/database/database.dart';
import 'package:smart_hair_care/features/hair_profile/view/hair_profile_page.dart';

import '../../../fixtures/fixtures.dart';
import '../../../helpers/helpers.dart';

void main() {
  late MockHairProfilesDao mockDao;

  setUp(() {
    mockDao = MockHairProfilesDao();
  });

  group('HairProfilePage', () {
    testWidgets('shows empty state when no profile', (tester) async {
      when(() => mockDao.getProfile()).thenAnswer((_) async => null);

      await tester.pumpApp(
        const HairProfilePage(),
        overrides: [hairProfilesDaoProvider.overrideWithValue(mockDao)],
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.person_outline), findsOneWidget);
    });

    testWidgets('shows app bar with title', (tester) async {
      when(() => mockDao.getProfile()).thenAnswer((_) async => null);

      await tester.pumpApp(
        const HairProfilePage(),
        overrides: [hairProfilesDaoProvider.overrideWithValue(mockDao)],
      );
      await tester.pumpAndSettle();

      expect(find.text('Hair Profile'), findsOneWidget);
    });

    testWidgets('shows profile data when profile exists', (tester) async {
      final profile = HairProfileFixtures.curlyProfile();
      when(() => mockDao.getProfile()).thenAnswer((_) async => profile);

      await tester.pumpApp(
        const HairProfilePage(),
        overrides: [hairProfilesDaoProvider.overrideWithValue(mockDao)],
      );
      await tester.pumpAndSettle();

      // Profile view should be shown, not empty state
      // Empty state has "Get Started" button
      expect(find.textContaining('Get Started'), findsNothing);
      // Should show edit button in app bar
      expect(find.byIcon(Icons.edit), findsOneWidget);
    });
  });
}
