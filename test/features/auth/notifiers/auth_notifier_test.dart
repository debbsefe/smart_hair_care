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

    test('signIn transitions to awaitingOtp on success', () async {
      when(() => mockRepo.currentUser).thenReturn(null);
      when(
        () => mockRepo.sendOtp(email: any(named: 'email')),
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
      expect(status, isA<AwaitingOtp>());
      expect((status! as AwaitingOtp).email, 'test@example.com');
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
        () => mockRepo.sendOtp(email: any(named: 'email')),
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

    test('verifyOtp shows error on invalid code', () async {
      when(() => mockRepo.currentUser).thenReturn(null);
      when(
        () => mockRepo.verifyOtp(
          email: any(named: 'email'),
          token: any(named: 'token'),
        ),
      ).thenThrow(Exception('Invalid OTP'));

      final container = createContainer();
      addTearDown(container.dispose);

      await container.read(authNotifierProvider.future);

      await container
          .read(authNotifierProvider.notifier)
          .verifyOtp(
            email: 'test@example.com',
            token: '000000',
          );

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

      // Simulate OTP verification callback
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
