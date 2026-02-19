import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smart_hair_care/core/database/database.dart';
import 'package:smart_hair_care/core/models/models.dart';
import 'package:smart_hair_care/features/hair_profile/view/hair_profile_setup_page.dart';
import 'package:smart_hair_care/l10n/l10n.dart';

import '../../../fixtures/fixtures.dart';
import '../../../helpers/helpers.dart';

void main() {
  late MockHairProfilesDao mockDao;
  late AppLocalizations l10n;

  setUp(() async {
    mockDao = MockHairProfilesDao();
    l10n = await loadTranslations();
  });

  Future<void> navigateToCharacteristicsStep(WidgetTester tester) async {
    // Fill required name field
    await tester.enterText(find.byType(TextField), 'Test Name');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    // Select a hair type bucket (first card)
    await tester.tap(find.byType(InkWell).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
  }

  group('HairProfileSetupPage porosity selection', () {
    testWidgets('shows porosity dropdown with readable labels', (
      tester,
    ) async {
      when(() => mockDao.getProfile()).thenAnswer((_) async => null);

      await tester.pumpApp(
        const HairProfileSetupPage(),
        overrides: [hairProfilesDaoProvider.overrideWithValue(mockDao)],
      );
      await tester.pumpAndSettle();

      await navigateToCharacteristicsStep(tester);

      // Porosity dropdown should be present with its label
      expect(find.text(l10n.profilePorosityLabel), findsOneWidget);

      // Info icons should be present for symptom descriptions
      expect(find.byIcon(Icons.info_outline), findsWidgets);

      // Open the dropdown by tapping it
      await tester.tap(find.byType(DropdownButtonFormField<Porosity>));
      await tester.pumpAndSettle();

      // All readable labels should appear in the opened dropdown
      expect(find.text(l10n.profilePorosityReadableLow), findsWidgets);
      expect(find.text(l10n.profilePorosityReadableMedium), findsWidgets);
      expect(find.text(l10n.profilePorosityReadableHigh), findsWidgets);
    });

    testWidgets('can select a porosity value from dropdown', (
      tester,
    ) async {
      when(() => mockDao.getProfile()).thenAnswer((_) async => null);

      await tester.pumpApp(
        const HairProfileSetupPage(),
        overrides: [hairProfilesDaoProvider.overrideWithValue(mockDao)],
      );
      await tester.pumpAndSettle();

      await navigateToCharacteristicsStep(tester);

      // Open the dropdown
      await tester.tap(find.byType(DropdownButtonFormField<Porosity>));
      await tester.pumpAndSettle();

      // Select "Low Porosity"
      await tester.tap(find.text(l10n.profilePorosityReadableLow).last);
      await tester.pumpAndSettle();

      // The selected value should be shown
      expect(find.text(l10n.profilePorosityReadableLow), findsOneWidget);
    });
  });

  group('HairProfileSetupPage density selection', () {
    testWidgets('shows density dropdown with readable labels', (
      tester,
    ) async {
      when(() => mockDao.getProfile()).thenAnswer((_) async => null);

      await tester.pumpApp(
        const HairProfileSetupPage(),
        overrides: [hairProfilesDaoProvider.overrideWithValue(mockDao)],
      );
      await tester.pumpAndSettle();

      await navigateToCharacteristicsStep(tester);

      // Density dropdown should be present with its label
      expect(find.text(l10n.profileDensityLabel), findsOneWidget);

      // Open the dropdown by tapping it
      await tester.tap(find.byType(DropdownButtonFormField<Density>));
      await tester.pumpAndSettle();

      // All readable labels should appear in the opened dropdown
      expect(find.text(l10n.profileDensityReadableLow), findsWidgets);
      expect(find.text(l10n.profileDensityReadableMedium), findsWidgets);
      expect(find.text(l10n.profileDensityReadableHigh), findsWidgets);
    });

    testWidgets('can select a density value from dropdown', (
      tester,
    ) async {
      when(() => mockDao.getProfile()).thenAnswer((_) async => null);

      await tester.pumpApp(
        const HairProfileSetupPage(),
        overrides: [hairProfilesDaoProvider.overrideWithValue(mockDao)],
      );
      await tester.pumpAndSettle();

      await navigateToCharacteristicsStep(tester);

      // Open the dropdown
      await tester.tap(find.byType(DropdownButtonFormField<Density>));
      await tester.pumpAndSettle();

      // Select "Low Density"
      await tester.tap(find.text(l10n.profileDensityReadableLow).last);
      await tester.pumpAndSettle();

      // The selected value should be shown
      expect(find.text(l10n.profileDensityReadableLow), findsOneWidget);
    });
  });

  group('HairProfileSetupPage thickness selection', () {
    testWidgets('shows thickness dropdown with readable labels', (
      tester,
    ) async {
      when(() => mockDao.getProfile()).thenAnswer((_) async => null);

      await tester.pumpApp(
        const HairProfileSetupPage(),
        overrides: [hairProfilesDaoProvider.overrideWithValue(mockDao)],
      );
      await tester.pumpAndSettle();

      await navigateToCharacteristicsStep(tester);

      // Thickness dropdown should be present with its label
      expect(find.text(l10n.profileThicknessLabel), findsOneWidget);

      // Open the dropdown by tapping it
      await tester.tap(find.byType(DropdownButtonFormField<Thickness>));
      await tester.pumpAndSettle();

      // All readable labels should appear in the opened dropdown
      expect(find.text(l10n.profileThicknessReadableFine), findsWidgets);
      expect(find.text(l10n.profileThicknessReadableMedium), findsWidgets);
      expect(find.text(l10n.profileThicknessReadableCoarse), findsWidgets);
    });

    testWidgets('can select a thickness value from dropdown', (
      tester,
    ) async {
      when(() => mockDao.getProfile()).thenAnswer((_) async => null);

      await tester.pumpApp(
        const HairProfileSetupPage(),
        overrides: [hairProfilesDaoProvider.overrideWithValue(mockDao)],
      );
      await tester.pumpAndSettle();

      await navigateToCharacteristicsStep(tester);

      // Open the dropdown
      await tester.tap(find.byType(DropdownButtonFormField<Thickness>));
      await tester.pumpAndSettle();

      // Select "Fine"
      await tester.tap(find.text(l10n.profileThicknessReadableFine).last);
      await tester.pumpAndSettle();

      // The selected value should be shown
      expect(find.text(l10n.profileThicknessReadableFine), findsOneWidget);
    });
  });

  group('HairProfileSetupPage scalp type selection', () {
    testWidgets('shows scalp type dropdown with readable labels', (
      tester,
    ) async {
      when(() => mockDao.getProfile()).thenAnswer((_) async => null);

      await tester.pumpApp(
        const HairProfileSetupPage(),
        overrides: [hairProfilesDaoProvider.overrideWithValue(mockDao)],
      );
      await tester.pumpAndSettle();

      await navigateToCharacteristicsStep(tester);

      // Scalp type dropdown should be present with its label
      expect(find.text(l10n.profileScalpLabel), findsOneWidget);

      // Open the dropdown by tapping it
      await tester.tap(find.byType(DropdownButtonFormField<ScalpType>));
      await tester.pumpAndSettle();

      // All readable labels should appear in the opened dropdown
      expect(find.text(l10n.profileScalpReadableDry), findsWidgets);
      expect(find.text(l10n.profileScalpReadableNormal), findsWidgets);
      expect(find.text(l10n.profileScalpReadableOily), findsWidgets);
      expect(find.text(l10n.profileScalpReadableCombination), findsWidgets);
    });

    testWidgets('can select a scalp type value from dropdown', (
      tester,
    ) async {
      when(() => mockDao.getProfile()).thenAnswer((_) async => null);

      await tester.pumpApp(
        const HairProfileSetupPage(),
        overrides: [hairProfilesDaoProvider.overrideWithValue(mockDao)],
      );
      await tester.pumpAndSettle();

      await navigateToCharacteristicsStep(tester);

      // Open the dropdown
      await tester.tap(find.byType(DropdownButtonFormField<ScalpType>));
      await tester.pumpAndSettle();

      // Select "Oily"
      await tester.tap(find.text(l10n.profileScalpReadableOily).last);
      await tester.pumpAndSettle();

      // The selected value should be shown
      expect(find.text(l10n.profileScalpReadableOily), findsOneWidget);
    });
  });

  group('HairProfileSetupPage validation', () {
    testWidgets('blocks navigation when name is empty', (tester) async {
      when(() => mockDao.getProfile()).thenAnswer((_) async => null);

      await tester.pumpApp(
        const HairProfileSetupPage(),
        overrides: [hairProfilesDaoProvider.overrideWithValue(mockDao)],
      );
      await tester.pumpAndSettle();

      // Try to go next without entering name
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      // Should show validation error and stay on step 1
      expect(find.text(l10n.profileNameRequired), findsOneWidget);
      expect(find.text(l10n.profileBasicInfoTitle), findsOneWidget);
    });

    testWidgets('blocks navigation when hair type is not selected', (
      tester,
    ) async {
      when(() => mockDao.getProfile()).thenAnswer((_) async => null);

      await tester.pumpApp(
        const HairProfileSetupPage(),
        overrides: [hairProfilesDaoProvider.overrideWithValue(mockDao)],
      );
      await tester.pumpAndSettle();

      // Fill name and advance
      await tester.enterText(find.byType(TextField), 'Test Name');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      // Try to go next without selecting hair type
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      // Should show validation error and stay on step 2
      expect(find.text(l10n.profileHairTypeRequired), findsOneWidget);
      expect(find.text(l10n.profileHairTypeTitle), findsOneWidget);
    });

    testWidgets('allows navigation after filling required fields', (
      tester,
    ) async {
      when(() => mockDao.getProfile()).thenAnswer((_) async => null);

      await tester.pumpApp(
        const HairProfileSetupPage(),
        overrides: [hairProfilesDaoProvider.overrideWithValue(mockDao)],
      );
      await tester.pumpAndSettle();

      // Fill name and advance
      await tester.enterText(find.byType(TextField), 'Test Name');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      // Should be on hair type step
      expect(find.text(l10n.profileHairTypeTitle), findsOneWidget);

      // Select hair type bucket and advance
      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      // Should be on characteristics step
      expect(find.text(l10n.profileCharacteristicsTitle), findsOneWidget);
    });
  });
}
