import 'package:supabase_flutter/supabase_flutter.dart' show User;

/// Represents the authentication state of the app.
sealed class AuthStatus {
  const AuthStatus();
}

/// No user is signed in.
final class Unauthenticated extends AuthStatus {
  const Unauthenticated();
}

/// An OTP code has been sent; waiting for user to enter it.
final class AwaitingOtp extends AuthStatus {
  const AwaitingOtp({required this.email});

  final String email;
}

/// User is signed in.
final class Authenticated extends AuthStatus {
  const Authenticated({required this.user});

  final User user;
}

/// An auth error occurred.
final class AuthError extends AuthStatus {
  const AuthError({required this.message});

  final String message;
}

final class InvalidEmailAddress extends AuthStatus {
  const InvalidEmailAddress();
}
