import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smart_hair_care/features/auth/repositories/auth_repository.dart';
import 'package:smart_hair_care/features/auth/view/auth_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../helpers/pump_app.dart';
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

  group('AuthPage', () {
    testWidgets('renders sign-in view when unauthenticated', (tester) async {
      when(() => mockRepo.currentUser).thenReturn(null);

      await tester.pumpApp(
        const AuthPage(),
        overrides: [
          authRepositoryProvider.overrideWithValue(mockRepo),
        ],
      );
      await tester.pumpAndSettle();

      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.byType(FilledButton), findsOneWidget);
    });

    testWidgets('shows OTP entry view after sending code', (
      tester,
    ) async {
      when(() => mockRepo.currentUser).thenReturn(null);
      when(
        () => mockRepo.sendOtp(email: any(named: 'email')),
      ).thenAnswer((_) async {});

      await tester.pumpApp(
        const AuthPage(),
        overrides: [
          authRepositoryProvider.overrideWithValue(mockRepo),
        ],
      );
      await tester.pumpAndSettle();

      // Enter email and tap send
      await tester.enterText(find.byType(TextFormField), 'test@example.com');
      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();

      // Should show the OTP entry view with the email
      expect(find.textContaining('test@example.com'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('renders authenticated view when signed in', (tester) async {
      when(() => mockRepo.currentUser).thenReturn(FakeUser());

      await tester.pumpApp(
        const AuthPage(),
        overrides: [
          authRepositoryProvider.overrideWithValue(mockRepo),
        ],
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('test@example.com'), findsOneWidget);
      expect(find.byType(OutlinedButton), findsOneWidget);
    });

    testWidgets('sign-out button shows confirmation dialog', (tester) async {
      when(() => mockRepo.currentUser).thenReturn(FakeUser());

      await tester.pumpApp(
        const AuthPage(),
        overrides: [
          authRepositoryProvider.overrideWithValue(mockRepo),
        ],
      );
      await tester.pumpAndSettle();

      // Tap sign out
      await tester.tap(find.byType(OutlinedButton));
      await tester.pumpAndSettle();

      // Should show the confirmation dialog
      expect(find.byType(AlertDialog), findsOneWidget);
    });

    testWidgets('validates empty email', (tester) async {
      when(() => mockRepo.currentUser).thenReturn(null);

      await tester.pumpApp(
        const AuthPage(),
        overrides: [
          authRepositoryProvider.overrideWithValue(mockRepo),
        ],
      );
      await tester.pumpAndSettle();

      // Tap send without entering email
      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();

      // Form validation should show error
      expect(find.byType(TextFormField), findsOneWidget);
      // The form validator should prevent sign-in
      verifyNever(
        () => mockRepo.sendOtp(email: any(named: 'email')),
      );
    });
  });
}
