import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smart_hair_care/core/database/database.dart';
import 'package:smart_hair_care/features/hair_profile/providers/hair_profile_provider.dart';

import '../../../fixtures/fixtures.dart';
import '../../../helpers/helpers.dart';

void main() {
  late MockHairProfilesDao mockDao;
  late ProviderContainer container;

  setUpAll(registerFallbackValues);

  setUp(() {
    mockDao = MockHairProfilesDao();
    container = ProviderContainer(
      overrides: [
        hairProfilesDaoProvider.overrideWithValue(mockDao),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('HairProfileNotifier', () {
    test('initial state is loading', () {
      when(() => mockDao.getProfile()).thenAnswer((_) async => null);

      final state = container.read(hairProfileProvider);

      expect(state.isLoading, isTrue);
      expect(state.profile, isNull);
      expect(state.error, isNull);
    });

    test('loads profile successfully', () async {
      final profile = HairProfileFixtures.curlyProfile();
      when(() => mockDao.getProfile()).thenAnswer((_) async => profile);

      container.read(hairProfileProvider);
      await Future<void>.delayed(const Duration(milliseconds: 100));

      final state = container.read(hairProfileProvider);
      expect(state.isLoading, isFalse);
      expect(state.profile, equals(profile));
      expect(state.hasProfile, isTrue);
      expect(state.error, isNull);
    });

    test('handles no profile gracefully', () async {
      when(() => mockDao.getProfile()).thenAnswer((_) async => null);

      container.read(hairProfileProvider);
      await Future<void>.delayed(const Duration(milliseconds: 100));

      final state = container.read(hairProfileProvider);
      expect(state.isLoading, isFalse);
      expect(state.profile, isNull);
      expect(state.hasProfile, isFalse);
    });

    test('handles load error', () async {
      when(() => mockDao.getProfile()).thenThrow(Exception('Database error'));

      container.read(hairProfileProvider);
      await Future<void>.delayed(const Duration(milliseconds: 100));

      final state = container.read(hairProfileProvider);
      expect(state.isLoading, isFalse);
      expect(state.error, isNotNull);
    });

    test('saves new profile successfully', () async {
      when(() => mockDao.getProfile()).thenAnswer((_) async => null);
      when(() => mockDao.upsertProfile(any())).thenAnswer((_) async {});

      container.read(hairProfileProvider);
      await Future<void>.delayed(const Duration(milliseconds: 100));

      await container.read(hairProfileProvider.notifier).saveProfile(
            hairType: '3b',
            porosity: 'high',
            density: 'medium',
          );

      verify(() => mockDao.upsertProfile(any())).called(1);
    });

    test('updates existing profile successfully', () async {
      final profile = HairProfileFixtures.curlyProfile();
      when(() => mockDao.getProfile()).thenAnswer((_) async => profile);
      when(() => mockDao.upsertProfile(any())).thenAnswer((_) async {});

      container.read(hairProfileProvider);
      await Future<void>.delayed(const Duration(milliseconds: 100));

      await container.read(hairProfileProvider.notifier).saveProfile(
            hairType: '4a',
            porosity: 'low',
          );

      verify(() => mockDao.upsertProfile(any())).called(1);
    });

    test('clearError clears error state', () async {
      when(() => mockDao.getProfile()).thenThrow(Exception('Database error'));

      container.read(hairProfileProvider);
      await Future<void>.delayed(const Duration(milliseconds: 100));

      expect(container.read(hairProfileProvider).error, isNotNull);

      container.read(hairProfileProvider.notifier).clearError();

      expect(container.read(hairProfileProvider).error, isNull);
    });
  });

  group('HairProfileState', () {
    test('copyWith creates new state with updated values', () {
      const state = HairProfileState();
      final newState = state.copyWith(isLoading: true);

      expect(newState.isLoading, isTrue);
      expect(state.isLoading, isFalse);
    });

    test('equality works correctly', () {
      const state1 = HairProfileState();
      const state2 = HairProfileState();

      expect(state1, equals(state2));
    });

    test('hasProfile returns true when profile exists', () {
      final profile = HairProfileFixtures.curlyProfile();
      final state = HairProfileState(profile: profile, hasProfile: true);

      expect(state.hasProfile, isTrue);
    });

    test('hasProfile returns false when profile is null', () {
      const state = HairProfileState();

      expect(state.hasProfile, isFalse);
    });
  });
}
