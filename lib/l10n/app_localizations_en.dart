import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'CartFly';

  @override
  String get tagline => 'from cart to doorstep';

  @override
  String get login => 'Login';

  @override
  String get register => 'Register';

  @override
  String get dontHaveAccount => 'Don\'t have an account';

  @override
  String get email => 'Email:';

  @override
  String get password => 'Password:';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get fullName => 'Full name:';

  @override
  String get phoneNumber => 'Phone number:';

  @override
  String get country => 'Country:';

  @override
  String get currency => 'Currency:';

  @override
  String get createAccount => 'Create account';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get sendResetEmail => 'Send reset email';

  @override
  String get verifyEmailTitle => 'Verify your email';

  @override
  String verifyEmailBody(Object email) {
    return 'We sent a verification link to $email. Tap it, then return here and continue.';
  }

  @override
  String get iVerified => 'I verified, continue';

  @override
  String get welcomeTitle => 'Welcome to cartfly';

  @override
  String get tapToContinue => 'tap to continue..';

  @override
  String get ourWarehouses => 'Our warehouses';

  @override
  String get howItWorks => 'How it works?';

  @override
  String get haveAnIssue => 'Have an issue?';

  @override
  String get lockerLocations => 'Locker locations';

  @override
  String get ourLockerLocations => 'our lockers locations';

  @override
  String get back => 'Back';

  @override
  String get next => 'Next';

  @override
  String bestFor(Object value) {
    return 'Best for: $value';
  }

  @override
  String get whyBuyHere => 'Why buy here';

  @override
  String get whyBuyLocally => 'Why buy locally';

  @override
  String buyFrom(Object country) {
    return 'Buy from $country';
  }

  @override
  String get bestWebsites => 'Best websites';

  @override
  String get language => 'Language';

  @override
  String get logout => 'Logout';

  @override
  String get profile => 'Profile';

  @override
  String get support => 'Support';

  @override
  String get supportSubject => 'Subject';

  @override
  String get supportMessage => 'Message';

  @override
  String get send => 'Send';

  @override
  String get errorInvalidEmail => 'Enter a valid email';

  @override
  String get errorPasswordShort => 'Password must be at least 6 characters';

  @override
  String get errorPasswordsDontMatch => 'Passwords do not match';

  @override
  String get errorRequired => 'Required';
}
