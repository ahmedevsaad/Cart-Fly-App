import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'CartFly'**
  String get appTitle;

  /// No description provided for @tagline.
  ///
  /// In en, this message translates to:
  /// **'from cart to doorstep'**
  String get tagline;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account'**
  String get dontHaveAccount;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email:'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password:'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full name:'**
  String get fullName;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone number:'**
  String get phoneNumber;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'Country:'**
  String get country;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency:'**
  String get currency;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccount;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @sendResetEmail.
  ///
  /// In en, this message translates to:
  /// **'Send reset email'**
  String get sendResetEmail;

  /// No description provided for @verifyEmailTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify your email'**
  String get verifyEmailTitle;

  /// No description provided for @verifyEmailBody.
  ///
  /// In en, this message translates to:
  /// **'We sent a verification link to {email}. Tap it, then return here and continue.'**
  String verifyEmailBody(Object email);

  /// No description provided for @iVerified.
  ///
  /// In en, this message translates to:
  /// **'I verified, continue'**
  String get iVerified;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to cartfly'**
  String get welcomeTitle;

  /// No description provided for @tapToContinue.
  ///
  /// In en, this message translates to:
  /// **'tap to continue..'**
  String get tapToContinue;

  /// No description provided for @ourWarehouses.
  ///
  /// In en, this message translates to:
  /// **'Our warehouses'**
  String get ourWarehouses;

  /// No description provided for @howItWorks.
  ///
  /// In en, this message translates to:
  /// **'How it works?'**
  String get howItWorks;

  /// No description provided for @haveAnIssue.
  ///
  /// In en, this message translates to:
  /// **'Have an issue?'**
  String get haveAnIssue;

  /// No description provided for @lockerLocations.
  ///
  /// In en, this message translates to:
  /// **'Locker locations'**
  String get lockerLocations;

  /// No description provided for @ourLockerLocations.
  ///
  /// In en, this message translates to:
  /// **'our lockers locations'**
  String get ourLockerLocations;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @bestFor.
  ///
  /// In en, this message translates to:
  /// **'Best for: {value}'**
  String bestFor(Object value);

  /// No description provided for @whyBuyHere.
  ///
  /// In en, this message translates to:
  /// **'Why buy here'**
  String get whyBuyHere;

  /// No description provided for @whyBuyLocally.
  ///
  /// In en, this message translates to:
  /// **'Why buy locally'**
  String get whyBuyLocally;

  /// No description provided for @buyFrom.
  ///
  /// In en, this message translates to:
  /// **'Buy from {country}'**
  String buyFrom(Object country);

  /// No description provided for @bestWebsites.
  ///
  /// In en, this message translates to:
  /// **'Best websites'**
  String get bestWebsites;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @supportSubject.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get supportSubject;

  /// No description provided for @supportMessage.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get supportMessage;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @errorInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get errorInvalidEmail;

  /// No description provided for @errorPasswordShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get errorPasswordShort;

  /// No description provided for @errorPasswordsDontMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get errorPasswordsDontMatch;

  /// No description provided for @errorRequired.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get errorRequired;

  String get welcomeUser;
  String get myOrder;
  String get ourServices;
  String get serviceWarehouses;
  String get serviceLockers;
  String get servicePlans;
  String get serviceCalculator;
  String get yourCartFlyAddress;
  String get copyAddress;
  String get addressCopied;
  String get recipient;
  String get address;
  String get city;
  String get statusOrderPlaced;
  String get statusShipped;
  String get statusInTransit;
  String get statusDelivered;

  // Plans
  String get ourPlans;
  String get tapPlanHint;
  String get planBasicName;
  String get planSmartName;
  String get planPrimeName;
  String get planBasicDesc;
  String get planBasicPrice;
  String get planSmartDesc;
  String get planSmartFeatures;
  String get planSmartPrice;
  String get planPrimeDesc;
  String get planPrimeFeatures;
  String get planPrimePrice;
  String get subscribeNow;

  // Calculator
  String get calcTitle;
  String get calcSubtitle;
  String get calcStep1;
  String get calcStep2;
  String get calcStep3;
  String get calcCountryFrom;
  String get calcCountryTo;
  String get calcCountryChina;
  String get calcCountryEgypt;
  String get calcWeight;
  String get calcWeightUnit;
  String get calcProductCategory;
  String get calcCatElectronics;
  String get calcCatFashion;
  String get calcCatAccessories;
  String get calcCalculate;
  String get calcEstimatedCost;
  String get calcShippingCost;
  String get calcCustomsFee;
  String get calcServiceFee;
  String get calcTotalEstimated;
  String get calcShippingVal;
  String get calcCustomsVal;
  String get calcServiceVal;
  String get calcTotalVal;
  String get calcEstimatedDelivery;
  String get calcDeliveryDays;

  // Plan checkout
  String get checkoutTitle;
  String get checkoutSubtitle;
  String get checkoutPlanName;
  String get checkoutBilledMonthly;
  String get checkoutPlanPrice;
  String get checkoutPerMonth;
  String get paymentMethod;
  String get payMethodCard;
  String get payMethodPaypal;
  String get payMethodApple;
  String get cardHolderName;
  String get orderConfirmButton;
  String get cardNumber;
  String get cardNumberHint;
  String get cardExpiry;
  String get cardExpiryHint;
  String get cardCvv;
  String get totalToday;
  String get payButton;
  String get securedEncryption;

  // Plan confirmed
  String get planConfirmedThankYou;
  String planConfirmedBody(Object plan);
  String get planConfirmedBodyPrefix;
  String get planConfirmedBodySuffix;
  String get receiptPlan;
  String get receiptBilling;
  String get receiptBillingMonthly;
  String get receiptNextRenewal;
  String get receiptRenewalDate;
  String get receiptAmountPaid;
  String get receiptAmountVal;
  String get backToHome;
  String get viewSubscription;

  // Profile (Frame 26)
  String get profileTitle;
  String get profileName;
  String get profileEmail;
  String get profilePhone;
  String get profileCountry;
  String get profilePlan;
  String get profileCurrency;
  String get profileSignOut;

  // Settings (Frame 27)
  String get settingsTitle;
  String get settingsAccountSection;
  String get settingsSavedAddresses;
  String get settingsEditProfile;
  String get settingsChangePassword;
  String get settingsAppPrefsSection;
  String get settingsLanguages;
  String get settingsCurrency;
  String get settingsNotifications;
  String get settingsSupportSection;
  String get settingsHelpCenter;
  String get settingsHaveAnIssue;
  String get settingsReportProblem;
  String get settingsAboutUs;
  String get settingsPolicy;
  String get settingsContactUs;
  String get settingsContactEmail;
  String get settingsSignOut;

  // Currency screen (Frame 28)
  String get currencyScreenTitle;
  String get currencyEGP;
  String get currencyUSD;
  String get currencySAR;

  // Language screen (Frame 29)
  String get langScreenTitle;
  String get langEnglish;
  String get langArabic;

  // About screen (Frame 30)
  String get aboutTitle;
  String get aboutBody;
  String get aboutContactLabel;
  String get aboutContactEmail;

  // Support / Have an issue (Frame 31)
  String get supportIssueTitle;
  String get supportIssueBody;
  String get supportContactLabel;
  String get supportContactEmail;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
