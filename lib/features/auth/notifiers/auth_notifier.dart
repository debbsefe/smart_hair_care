import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_hair_care/features/auth/auth.dart';
import 'package:smart_hair_care/features/shared/shared.dart';
import 'package:supabase_flutter/supabase_flutter.dart'
    show AuthChangeEvent, AuthState;

/// Redirect URL for Supabase magic link deep link callback.
const _redirectUrl = String.fromEnvironment('SUPABASE_REDIRECT_URL');

/// Manages authentication state via Supabase email OTP.
class AuthNotifier extends AsyncNotifier<AuthStatus> {
  AuthRepository get _repo => ref.watch(authRepositoryProvider);
  StreamSubscription<AuthState>? _authSub;

  @override
  FutureOr<AuthStatus> build() {
    // Listen for auth state changes (magic link callback, token refresh, etc.)
    _authSub = _repo.onAuthStateChange.listen((authState) {
      final event = authState.event;
      if (event == AuthChangeEvent.signedIn ||
          event == AuthChangeEvent.tokenRefreshed) {
        final user = _repo.currentUser;
        if (user != null) {
          state = AsyncData(Authenticated(user: user));
        }
      } else if (event == AuthChangeEvent.signedOut) {
        state = const AsyncData(Unauthenticated());
      }
    });

    ref.onDispose(() => _authSub?.cancel());

    // Check if already signed in
    final user = _repo.currentUser;
    if (user != null) {
      return Authenticated(user: user);
    }
    return const Unauthenticated();
  }

  /// Send a magic link to [email].
  Future<void> signIn(String email) async {
    final trimmed = email.trim();
    if (trimmed.isEmpty || !isValidEmail(trimmed)) {
      state = const AsyncData(
        InvalidEmailAddress(),
      );
      return;
    }

    state = const AsyncLoading();
    try {
      await _repo.signInWithMagicLink(
        email: trimmed,
        redirectTo: _redirectUrl,
      );
      state = AsyncData(AwaitingMagicLink(email: trimmed));
    } on Exception catch (e) {
      state = AsyncData(AuthError(message: e.toString()));
    }
  }

  /// Sign out the current user.
  Future<void> signOut() async {
    state = const AsyncLoading();
    try {
      await _repo.signOut();
      state = const AsyncData(Unauthenticated());
    } on Exception catch (e) {
      state = AsyncData(AuthError(message: e.toString()));
    }
  }
}

/// Provider for [AuthNotifier].
final authNotifierProvider = AsyncNotifierProvider<AuthNotifier, AuthStatus>(
  AuthNotifier.new,
);
