import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_hair_care/features/auth/auth.dart';
import 'package:smart_hair_care/features/shared/shared.dart';
import 'package:supabase_flutter/supabase_flutter.dart'
    show AuthChangeEvent, AuthState;

/// Manages authentication state via Supabase email OTP.
class AuthNotifier extends AsyncNotifier<AuthStatus> {
  AuthRepository get _repo => ref.watch(authRepositoryProvider);
  StreamSubscription<AuthState>? _authSub;

  @override
  FutureOr<AuthStatus> build() {
    // Listen for auth state changes (OTP verification, token refresh, etc.)
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

  /// Send an OTP code to [email].
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
      await _repo.sendOtp(email: trimmed);
      state = AsyncData(AwaitingOtp(email: trimmed));
    } on Exception catch (e) {
      state = AsyncData(AuthError(message: e.toString()));
    }
  }

  /// Verify the OTP [token] for [email].
  Future<void> verifyOtp({
    required String email,
    required String token,
  }) async {
    state = const AsyncLoading();
    try {
      await _repo.verifyOtp(email: email, token: token);
      // Auth state change listener will handle the transition to Authenticated
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
