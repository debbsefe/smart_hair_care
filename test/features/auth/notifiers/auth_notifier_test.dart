import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smart_hair_care/features/auth/notifiers/auth_notifier.dart';
import 'package:smart_hair_care/features/auth/notifiers/auth_state.dart';
import 'package:smart_hair_care/features/auth/repositories/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../helpers.dart';

void main() {
  late MockAuthRepository mockRepo;
  late StreamController<AuthState> authStreamController;

  setUp(() {
    mockRepo = MockAuthRepository();
    authStreamController = StreamController<AuthState>.broadcast();

    when(
      () => mockRepo.onAuthStateChange,
    ).thenAnswer((_) => authStreamController.stream);
  });

  tearDown(() async {
    await authStreamController.close();
  });

  ProviderContainer createContainer() {
    return ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(mockRepo),
      ],
    );
  }

  group('AuthNotifier', () {
    test('initial state is unauthenticated when no user', () async {
      when(() => mockRepo.currentUser).thenReturn(null);

      final container = createContainer();
      addTearDown(container.dispose);

      // Wait for the async build
      final status = await container.read(authNotifierProvider.future);
      expect(status, isA<Unauthenticated>());
    });

    test('initial state is authenticated when user exists', () async {
      when(() => mockRepo.currentUser).thenReturn(FakeUser());

      final container = createContainer();
      addTearDown(container.dispose);

      final status = await container.read(authNotifierProvider.future);
      expect(status, isA<Authenticated>());
      expect((status as Authenticated).user.email, 'test@example.com');
    });

    test('signIn transitions to awaitingMagicLink on success', () async {
      when(() => mockRepo.currentUser).thenReturn(null);
      when(
        () => mockRepo.signInWithMagicLink(
          email: any(named: 'email'),
          redirectTo: any(named: 'redirectTo'),
        ),
      ).thenAnswer((_) async {});

      final container = createContainer();
      addTearDown(container.dispose);

      // Wait for initial build
      await container.read(authNotifierProvider.future);

      // Sign in
      await container
          .read(authNotifierProvider.notifier)
          .signIn('test@example.com');

      final status = container.read(authNotifierProvider).value;
      expect(status, isA<AwaitingMagicLink>());
      expect((status! as AwaitingMagicLink).email, 'test@example.com');
    });

    test('signIn shows error for invalid email', () async {
      when(() => mockRepo.currentUser).thenReturn(null);

      final container = createContainer();
      addTearDown(container.dispose);

      await container.read(authNotifierProvider.future);

      await container
          .read(authNotifierProvider.notifier)
          .signIn('not-an-email');

      final status = container.read(authNotifierProvider).value;
      expect(status, isA<InvalidEmailAddress>());
    });

    test('signIn shows error for empty email', () async {
      when(() => mockRepo.currentUser).thenReturn(null);

      final container = createContainer();
      addTearDown(container.dispose);

      await container.read(authNotifierProvider.future);

      await container.read(authNotifierProvider.notifier).signIn('');

      final status = container.read(authNotifierProvider).value;
      expect(status, isA<InvalidEmailAddress>());
    });

    test('signIn shows error on network failure', () async {
      when(() => mockRepo.currentUser).thenReturn(null);
      when(
        () => mockRepo.signInWithMagicLink(
          email: any(named: 'email'),
          redirectTo: any(named: 'redirectTo'),
        ),
      ).thenThrow(Exception('Network error'));

      final container = createContainer();
      addTearDown(container.dispose);

      await container.read(authNotifierProvider.future);

      await container
          .read(authNotifierProvider.notifier)
          .signIn('test@example.com');

      final status = container.read(authNotifierProvider).value;
      expect(status, isA<AuthError>());
    });

    test('signOut transitions to unauthenticated', () async {
      when(() => mockRepo.currentUser).thenReturn(FakeUser());
      when(() => mockRepo.signOut()).thenAnswer((_) async {});

      final container = createContainer();
      addTearDown(container.dispose);

      await container.read(authNotifierProvider.future);

      await container.read(authNotifierProvider.notifier).signOut();

      final status = container.read(authNotifierProvider).value;
      expect(status, isA<Unauthenticated>());
    });

    test('auth stream signedIn event updates state to authenticated', () async {
      when(() => mockRepo.currentUser).thenReturn(null);

      final container = createContainer();
      addTearDown(container.dispose);

      await container.read(authNotifierProvider.future);

      // Simulate magic link callback
      when(() => mockRepo.currentUser).thenReturn(FakeUser());
      authStreamController.add(
        const AuthState(AuthChangeEvent.signedIn, null),
      );

      // Give the stream listener a chance to fire
      await Future<void>.delayed(Duration.zero);

      final status = container.read(authNotifierProvider).value;
      expect(status, isA<Authenticated>());
    });

    test(
      'auth stream signedOut event updates state to unauthenticated',
      () async {
        when(() => mockRepo.currentUser).thenReturn(FakeUser());

        final container = createContainer();
        addTearDown(container.dispose);

        await container.read(authNotifierProvider.future);

        authStreamController.add(
          const AuthState(AuthChangeEvent.signedOut, null),
        );

        await Future<void>.delayed(Duration.zero);

        final status = container.read(authNotifierProvider).value;
        expect(status, isA<Unauthenticated>());
      },
    );
  });
}
