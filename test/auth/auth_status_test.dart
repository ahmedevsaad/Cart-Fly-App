import 'package:cartfly/features/auth/auth_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('initial status is loading', () {
    final s = AuthState.initial();
    expect(s.status, AuthStatus.loading);
    expect(s.user, isNull);
  });

  test('signedOut clears user', () {
    final s = AuthState.signedOut();
    expect(s.status, AuthStatus.unauthenticated);
    expect(s.user, isNull);
  });

  test('pendingOtp keeps email', () {
    final s = AuthState.pendingOtp(email: 'a@b.com');
    expect(s.status, AuthStatus.pendingOtp);
    expect(s.pendingEmail, 'a@b.com');
  });
}
