import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smart_hair_care/core/database/database.dart';
import 'package:smart_hair_care/features/experiments/view/experiments_page.dart';

import '../../../helpers/helpers.dart';

void main() {
  late MockExperimentsDao mockDao;

  setUp(() {
    mockDao = MockExperimentsDao();
  });

  group('ExperimentsPage', () {
    testWidgets('shows empty state when no experiments', (tester) async {
      when(() => mockDao.getAllExperiments()).thenAnswer((_) async => []);

      await tester.pumpApp(
        const ExperimentsPage(),
        overrides: [experimentsDaoProvider.overrideWithValue(mockDao)],
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.science_outlined), findsOneWidget);
    });

    testWidgets('shows FAB', (tester) async {
      when(() => mockDao.getAllExperiments()).thenAnswer((_) async => []);

      await tester.pumpApp(
        const ExperimentsPage(),
        overrides: [experimentsDaoProvider.overrideWithValue(mockDao)],
      );
      await tester.pumpAndSettle();

      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('shows app bar with title', (tester) async {
      when(() => mockDao.getAllExperiments()).thenAnswer((_) async => []);

      await tester.pumpApp(
        const ExperimentsPage(),
        overrides: [experimentsDaoProvider.overrideWithValue(mockDao)],
      );
      await tester.pumpAndSettle();

      expect(find.text('Experiments'), findsOneWidget);
    });

    testWidgets('shows experiments when data exists', (tester) async {
      final experiments = ExperimentFixtures.sampleExperiments();
      when(
        () => mockDao.getAllExperiments(),
      ).thenAnswer((_) async => experiments);

      await tester.pumpApp(
        const ExperimentsPage(),
        overrides: [experimentsDaoProvider.overrideWithValue(mockDao)],
      );
      await tester.pumpAndSettle();

      // Should show experiment titles
      expect(find.text('Protein vs Moisture Balance'), findsOneWidget);
    });

    testWidgets('shows experiment status chip', (tester) async {
      final experiments = [ExperimentFixtures.activeExperiment()];
      when(
        () => mockDao.getAllExperiments(),
      ).thenAnswer((_) async => experiments);

      await tester.pumpApp(
        const ExperimentsPage(),
        overrides: [experimentsDaoProvider.overrideWithValue(mockDao)],
      );
      await tester.pumpAndSettle();

      // Experiment list should show active experiments
      expect(find.textContaining('Active'), findsAtLeast(1));
    });
  });
}
