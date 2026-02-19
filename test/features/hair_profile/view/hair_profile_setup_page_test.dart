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
    await tester.tap(find.text('Next'));
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

    testWidgets('prefills porosity from saved profile when editing', (
      tester,
    ) async {
      final profile = HairProfileFixtures.curlyProfile();
      when(() => mockDao.getProfile()).thenAnswer((_) async => profile);

      await tester.pumpApp(
        const HairProfileSetupPage(isEditing: true),
        overrides: [hairProfilesDaoProvider.overrideWithValue(mockDao)],
      );
      await tester.pumpAndSettle();

      await navigateToCharacteristicsStep(tester);

      // The prefilled value (high) should appear in the dropdown
      expect(find.text(l10n.profilePorosityReadableHigh), findsOneWidget);
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

    testWidgets('prefills density from saved profile when editing', (
      tester,
    ) async {
      final profile = HairProfileFixtures.curlyProfile();
      when(() => mockDao.getProfile()).thenAnswer((_) async => profile);

      await tester.pumpApp(
        const HairProfileSetupPage(isEditing: true),
        overrides: [hairProfilesDaoProvider.overrideWithValue(mockDao)],
      );
      await tester.pumpAndSettle();

      await navigateToCharacteristicsStep(tester);

      // The prefilled value (medium) should appear in the dropdown
      expect(find.text(l10n.profileDensityReadableMedium), findsOneWidget);
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
}
