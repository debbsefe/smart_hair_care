import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smart_hair_care/core/database/database.dart';
import 'package:smart_hair_care/features/hair_profile/notifiers/hair_profile_notifier.dart';

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
    });

    test('loads profile successfully', () async {
      final profile = HairProfileFixtures.curlyProfile();
      when(() => mockDao.getProfile()).thenAnswer((_) async => profile);

      final result = await container.read(hairProfileProvider.future);

      expect(result, equals(profile));
    });

    test('returns null when no profile exists', () async {
      when(() => mockDao.getProfile()).thenAnswer((_) async => null);

      final result = await container.read(hairProfileProvider.future);

      expect(result, isNull);
    });

    test('handles load error', () async {
      when(
        () => mockDao.getProfile(),
      ).thenThrow(Exception('Database error'));

      container.read(hairProfileProvider);
      await Future<void>.delayed(const Duration(milliseconds: 100));

      final state = container.read(hairProfileProvider);
      expect(state.hasError, isTrue);
    });

    test('saves profile successfully', () async {
      when(() => mockDao.getProfile()).thenAnswer((_) async => null);
      when(() => mockDao.upsertProfile(any())).thenAnswer((_) async => 1);

      await container.read(hairProfileProvider.future);

      await container
          .read(hairProfileProvider.notifier)
          .saveProfile(
            name: 'My Hair',
            hairType: '3b',
          );

      verify(() => mockDao.upsertProfile(any())).called(1);
    });

    test('updates profile successfully', () async {
      final profile = HairProfileFixtures.curlyProfile();
      when(() => mockDao.getProfile()).thenAnswer((_) async => profile);
      when(() => mockDao.upsertProfile(any())).thenAnswer((_) async => 1);

      await container.read(hairProfileProvider.future);

      await container
          .read(hairProfileProvider.notifier)
          .saveProfile(
            name: 'Updated Name',
            hairType: '4a',
            porosity: 'low',
          );

      verify(() => mockDao.upsertProfile(any())).called(1);
    });
  });

  group('Derived Providers', () {
    test('hasHairProfileProvider returns true when profile exists', () async {
      final profile = HairProfileFixtures.curlyProfile();
      when(() => mockDao.getProfile()).thenAnswer((_) async => profile);

      await container.read(hairProfileProvider.future);

      final hasProfile = container.read(hasHairProfileProvider);
      expect(hasProfile, isTrue);
    });

    test('hasHairProfileProvider returns false when no profile', () async {
      when(() => mockDao.getProfile()).thenAnswer((_) async => null);

      await container.read(hairProfileProvider.future);

      final hasProfile = container.read(hasHairProfileProvider);
      expect(hasProfile, isFalse);
    });
  });
}
