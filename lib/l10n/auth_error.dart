/// Maps Firebase Auth error codes (as stored in [AuthProvider.errorKey])
/// to human-readable English strings.
String authErrorText(String? key) {
  switch (key) {
    case 'errorAuth_invalid-email':
      return 'That email looks invalid.';
    case 'errorAuth_user-not-found':
    case 'errorAuth_wrong-password':
    case 'errorAuth_invalid-credential':
      return 'Wrong email or password.';
    case 'errorAuth_email-already-in-use':
      return 'That email is already registered.';
    case 'errorAuth_weak-password':
      return 'Password is too weak (min 6 chars).';
    case 'errorAuth_requires-recent-login':
      return 'Please sign in again to change your password.';
    case 'errorAuthInvalidOtp':
      return 'Invalid verification code.';
    case null:
      return '';
    default:
      return 'Something went wrong. Please try again.';
  }
}
