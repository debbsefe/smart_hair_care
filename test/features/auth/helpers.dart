import 'package:mocktail/mocktail.dart';
import 'package:smart_hair_care/features/auth/repositories/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class FakeUser extends Fake implements User {
  @override
  String get id => 'test-user-id';

  @override
  String get email => 'test@example.com';

  @override
  Map<String, dynamic> get appMetadata => {};

  @override
  Map<String, dynamic> get userMetadata => {};

  @override
  String get aud => 'authenticated';

  @override
  String get createdAt => '2026-01-01T00:00:00.000Z';
}
