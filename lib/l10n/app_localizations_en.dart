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

  @override
  String get welcomeUser => 'welcome,';

  @override
  String get myOrder => 'My order:';

  @override
  String get ourServices => 'Our services:';

  @override
  String get serviceWarehouses => 'Our\nwarehouses';

  @override
  String get serviceLockers => 'Locker\nlocations';

  @override
  String get servicePlans => 'subscription\nplans';

  @override
  String get serviceCalculator => 'Cart\ncalculator';

  @override
  String get yourCartFlyAddress => 'Your CartFly address';

  @override
  String get copyAddress => 'Copy';

  @override
  String get addressCopied => 'Address copied';

  @override
  String get recipient => 'Recipient';

  @override
  String get address => 'Address';

  @override
  String get city => 'City';

  @override
  String get statusOrderPlaced => 'Order Placed';

  @override
  String get statusShipped => 'Shipped';

  @override
  String get statusInTransit => 'In Transit';

  @override
  String get statusDelivered => 'Delivered';

  // Plans
  @override
  String get ourPlans => 'Our Plans';

  @override
  String get tapPlanHint => 'Tap a plan to see what\'s included.';

  @override
  String get planBasicName => 'Basic cart';

  @override
  String get planSmartName => 'Smart cart';

  @override
  String get planPrimeName => 'Prime cart';

  @override
  String get planBasicDesc =>
      'Get started with CartFly at no cost. Access warehouse addresses and basic order management features';

  @override
  String get planBasicPrice => 'Free';

  @override
  String get planSmartDesc =>
      'Unlock exclusive vouchers and enjoy our built-in order calculator for fast, accurate online shopping estimates.';

  @override
  String get planSmartFeatures =>
      '• Discount vouchers\n• Instant order cost calculator\n• Easy online checkout support';

  @override
  String get planSmartPrice => '12.33 USD/per month';

  @override
  String get planPrimeDesc =>
      'Save more on every order with premium discounts, liquid offers, and instant price calculations.';

  @override
  String get planPrimeFeatures =>
      '• Higher discount rates\n• Discounts on liquid products\n• Smart calculator service';

  @override
  String get planPrimePrice => '19.99 USD/per month';

  @override
  String get subscribeNow => 'Subscribe now';

  // Calculator
  @override
  String get calcTitle => 'Shipping Calculator';

  @override
  String get calcSubtitle =>
      'Enter the details below to calculate your shipping cost.';

  @override
  String get calcStep1 => 'Details';

  @override
  String get calcStep2 => 'Calculate';

  @override
  String get calcStep3 => 'Result';

  @override
  String get calcCountryFrom => 'Country From';

  @override
  String get calcCountryTo => 'Country To';

  @override
  String get calcCountryChina => 'China';

  @override
  String get calcCountryEgypt => 'Egypt';

  @override
  String get calcWeight => 'Weight';

  @override
  String get calcWeightUnit => 'KG';

  @override
  String get calcProductCategory => 'Product Category';

  @override
  String get calcCatElectronics => 'Electronics';

  @override
  String get calcCatFashion => 'Fashion';

  @override
  String get calcCatAccessories => 'Accessories';

  @override
  String get calcCalculate => 'Calculate';

  @override
  String get calcEstimatedCost => 'Estimated Cost';

  @override
  String get calcShippingCost => 'Shipping Cost';

  @override
  String get calcCustomsFee => 'Customs Fee';

  @override
  String get calcServiceFee => 'Service Fee';

  @override
  String get calcTotalEstimated => 'Total Estimated Cost';

  @override
  String get calcShippingVal => r'$12.00';

  @override
  String get calcCustomsVal => r'$8.00';

  @override
  String get calcServiceVal => r'$3.00';

  @override
  String get calcTotalVal => r'$23.00';

  @override
  String get calcEstimatedDelivery => 'Estimated Delivery';

  @override
  String get calcDeliveryDays => '7 – 10 Days';

  // Plan checkout
  @override
  String get checkoutTitle => 'Checkout';

  @override
  String get checkoutSubtitle => 'Confirm your subscription & pay securely.';

  @override
  String get checkoutPlanName => 'Prime cart';

  @override
  String get checkoutBilledMonthly => 'Billed monthly';

  @override
  String get checkoutPlanPrice => r'$19.99';

  @override
  String get checkoutPerMonth => '/month';

  @override
  String get paymentMethod => 'Payment method';

  @override
  String get payMethodCard => 'Card';

  @override
  String get payMethodPaypal => 'PayPal';

  @override
  String get payMethodApple => 'Apple';

  @override
  String get cardHolderName => 'Card holder name';

  @override
  String get orderConfirmButton => 'Confirm';

  @override
  String get cardNumber => 'Card number';

  @override
  String get cardNumberHint => '4242 4242 4242 4242';

  @override
  String get cardExpiry => 'Expiry';

  @override
  String get cardExpiryHint => '08 / 28';

  @override
  String get cardCvv => 'CVV';

  @override
  String get totalToday => 'Total today';

  @override
  String get payButton => r'Pay $19.99';

  @override
  String get securedEncryption => 'Secured by 256-bit encryption';

  // Plan confirmed
  @override
  String get planConfirmedThankYou => 'Thank you!';

  @override
  String planConfirmedBody(Object plan) =>
      'Your payment was successful and your $plan plan is now active.';

  @override
  String get planConfirmedBodyPrefix =>
      'Your payment was successful and your ';

  @override
  String get planConfirmedBodySuffix => ' plan is now active.';

  @override
  String get receiptPlan => 'Plan';

  @override
  String get receiptBilling => 'Billing';

  @override
  String get receiptBillingMonthly => 'Monthly';

  @override
  String get receiptNextRenewal => 'Next renewal';

  @override
  String get receiptRenewalDate => 'Jul 12, 2026';

  @override
  String get receiptAmountPaid => 'Amount paid';

  @override
  String get receiptAmountVal => r'$19.99';

  @override
  String get backToHome => 'Back to home';

  @override
  String get viewSubscription => 'View my subscription';

  // Profile (Frame 26)
  @override
  String get profileTitle => 'My Profile';
  @override
  String get profileName => 'Name:';
  @override
  String get profileEmail => 'Email address:';
  @override
  String get profilePhone => 'Phone number:';
  @override
  String get profileCountry => 'Country:';
  @override
  String get profilePlan => 'Your plan:';
  @override
  String get profileCurrency => 'Currency:';
  @override
  String get profileSignOut => 'Sign out';

  // Settings (Frame 27)
  @override
  String get settingsTitle => 'Settings';
  @override
  String get settingsAccountSection => 'Account settings:';
  @override
  String get settingsSavedAddresses => 'Saved addresses';
  @override
  String get settingsEditProfile => 'Edit profiles';
  @override
  String get settingsChangePassword => 'Change password';
  @override
  String get settingsAppPrefsSection => 'App Preferences:';
  @override
  String get settingsLanguages => 'Languages';
  @override
  String get settingsCurrency => 'Currency';
  @override
  String get settingsNotifications => 'Notification settings';
  @override
  String get settingsSupportSection => 'Support & Help:';
  @override
  String get settingsHelpCenter => 'Help center';
  @override
  String get settingsHaveAnIssue => 'Have an issue';
  @override
  String get settingsReportProblem => 'Report a problem';
  @override
  String get settingsAboutUs => 'About us';
  @override
  String get settingsPolicy => 'Policy';
  @override
  String get settingsContactUs => 'contact us:';
  @override
  String get settingsContactEmail => 'cartflylog@gmail.com';
  @override
  String get settingsSignOut => 'Sign out';

  // Currency screen (Frame 28)
  @override
  String get currencyScreenTitle => 'Settings';
  @override
  String get currencyEGP => 'EGP';
  @override
  String get currencyUSD => 'USD';
  @override
  String get currencySAR => 'SAR';

  // Language screen (Frame 29)
  @override
  String get langScreenTitle => 'Settings';
  @override
  String get langEnglish => 'English';
  @override
  String get langArabic => 'العربية';

  // About screen (Frame 30)
  @override
  String get aboutTitle => 'About us';
  @override
  String get aboutBody =>
      'We are a trusted international shipping service connecting Egypt, the USA, the UAE, China, and Saudi Arabia through one seamless platform. Our goal is to simplify cross-border delivery by providing reliable shipping solutions, transparent pricing, real-time tracking, and efficient order management to ensure every shipment reaches its destination safely and on time.';
  @override
  String get aboutContactLabel => 'contact us:';
  @override
  String get aboutContactEmail => 'cartflylog@gmail.com';

  // Support / Have an issue (Frame 31)
  @override
  String get supportIssueTitle => 'Have an issue?';
  @override
  String get supportIssueBody =>
      'If you are experiencing any problem while using the application, we\'re here to help.\n\nWhether it\'s an issue with selecting warehouses, loading data, or anything not working as expected, please let us know.\n\nKindly provide a clear description of the issue, and if possible, include the warehouse you were trying to access and a screenshot to help us understand the problem better.\n\nOur team will review your request and get back to you as soon as possible.';
  @override
  String get supportContactLabel => 'contact us:';
  @override
  String get supportContactEmail => 'cartflylog@gmail.com';
}
