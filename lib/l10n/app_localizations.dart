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

  /// No description provided for @welcomeUser.
  ///
  /// In en, this message translates to:
  /// **'welcome,'**
  String get welcomeUser;

  /// No description provided for @myOrder.
  ///
  /// In en, this message translates to:
  /// **'My order:'**
  String get myOrder;

  /// No description provided for @ourServices.
  ///
  /// In en, this message translates to:
  /// **'Our services:'**
  String get ourServices;

  /// No description provided for @serviceWarehouses.
  ///
  /// In en, this message translates to:
  /// **'Our\nwarehouses'**
  String get serviceWarehouses;

  /// No description provided for @serviceLockers.
  ///
  /// In en, this message translates to:
  /// **'Locker\nlocations'**
  String get serviceLockers;

  /// No description provided for @servicePlans.
  ///
  /// In en, this message translates to:
  /// **'subscription\nplans'**
  String get servicePlans;

  /// No description provided for @serviceCalculator.
  ///
  /// In en, this message translates to:
  /// **'Cart\ncalculator'**
  String get serviceCalculator;

  /// No description provided for @yourCartFlyAddress.
  ///
  /// In en, this message translates to:
  /// **'Your CartFly address'**
  String get yourCartFlyAddress;

  /// No description provided for @copyAddress.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copyAddress;

  /// No description provided for @addressCopied.
  ///
  /// In en, this message translates to:
  /// **'Address copied'**
  String get addressCopied;

  /// No description provided for @recipient.
  ///
  /// In en, this message translates to:
  /// **'Recipient'**
  String get recipient;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @statusOrderPlaced.
  ///
  /// In en, this message translates to:
  /// **'Order Placed'**
  String get statusOrderPlaced;

  /// No description provided for @statusShipped.
  ///
  /// In en, this message translates to:
  /// **'Shipped'**
  String get statusShipped;

  /// No description provided for @statusInTransit.
  ///
  /// In en, this message translates to:
  /// **'In Transit'**
  String get statusInTransit;

  /// No description provided for @statusDelivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get statusDelivered;

  /// No description provided for @ourPlans.
  ///
  /// In en, this message translates to:
  /// **'Our Plans'**
  String get ourPlans;

  /// No description provided for @tapPlanHint.
  ///
  /// In en, this message translates to:
  /// **'Tap a plan to see what\'s included.'**
  String get tapPlanHint;

  /// No description provided for @planBasicName.
  ///
  /// In en, this message translates to:
  /// **'Basic cart'**
  String get planBasicName;

  /// No description provided for @planSmartName.
  ///
  /// In en, this message translates to:
  /// **'Smart cart'**
  String get planSmartName;

  /// No description provided for @planPrimeName.
  ///
  /// In en, this message translates to:
  /// **'Prime cart'**
  String get planPrimeName;

  /// No description provided for @planBasicDesc.
  ///
  /// In en, this message translates to:
  /// **'Get started with CartFly at no cost. Access warehouse addresses and basic order management features'**
  String get planBasicDesc;

  /// No description provided for @planBasicPrice.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get planBasicPrice;

  /// No description provided for @planSmartDesc.
  ///
  /// In en, this message translates to:
  /// **'Unlock exclusive vouchers and enjoy our built-in order calculator for fast, accurate online shopping estimates.'**
  String get planSmartDesc;

  /// No description provided for @planSmartFeatures.
  ///
  /// In en, this message translates to:
  /// **'• Discount vouchers\n• Instant order cost calculator\n• Easy online checkout support'**
  String get planSmartFeatures;

  /// No description provided for @planSmartPrice.
  ///
  /// In en, this message translates to:
  /// **'12.33 USD/per month'**
  String get planSmartPrice;

  /// No description provided for @planPrimeDesc.
  ///
  /// In en, this message translates to:
  /// **'Save more on every order with premium discounts, liquid offers, and instant price calculations.'**
  String get planPrimeDesc;

  /// No description provided for @planPrimeFeatures.
  ///
  /// In en, this message translates to:
  /// **'• Higher discount rates\n• Discounts on liquid products\n• Smart calculator service'**
  String get planPrimeFeatures;

  /// No description provided for @planPrimePrice.
  ///
  /// In en, this message translates to:
  /// **'19.99 USD/per month'**
  String get planPrimePrice;

  /// No description provided for @subscribeNow.
  ///
  /// In en, this message translates to:
  /// **'Subscribe now'**
  String get subscribeNow;

  /// No description provided for @calcTitle.
  ///
  /// In en, this message translates to:
  /// **'Shipping Calculator'**
  String get calcTitle;

  /// No description provided for @calcSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the details below to calculate your shipping cost.'**
  String get calcSubtitle;

  /// No description provided for @calcStep1.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get calcStep1;

  /// No description provided for @calcStep2.
  ///
  /// In en, this message translates to:
  /// **'Calculate'**
  String get calcStep2;

  /// No description provided for @calcStep3.
  ///
  /// In en, this message translates to:
  /// **'Result'**
  String get calcStep3;

  /// No description provided for @calcCountryFrom.
  ///
  /// In en, this message translates to:
  /// **'Country From'**
  String get calcCountryFrom;

  /// No description provided for @calcCountryTo.
  ///
  /// In en, this message translates to:
  /// **'Country To'**
  String get calcCountryTo;

  /// No description provided for @calcCountryChina.
  ///
  /// In en, this message translates to:
  /// **'China'**
  String get calcCountryChina;

  /// No description provided for @calcCountryEgypt.
  ///
  /// In en, this message translates to:
  /// **'Egypt'**
  String get calcCountryEgypt;

  /// No description provided for @calcWeight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get calcWeight;

  /// No description provided for @calcWeightUnit.
  ///
  /// In en, this message translates to:
  /// **'KG'**
  String get calcWeightUnit;

  /// No description provided for @calcProductCategory.
  ///
  /// In en, this message translates to:
  /// **'Product Category'**
  String get calcProductCategory;

  /// No description provided for @calcCatElectronics.
  ///
  /// In en, this message translates to:
  /// **'Electronics'**
  String get calcCatElectronics;

  /// No description provided for @calcCatFashion.
  ///
  /// In en, this message translates to:
  /// **'Fashion'**
  String get calcCatFashion;

  /// No description provided for @calcCatAccessories.
  ///
  /// In en, this message translates to:
  /// **'Accessories'**
  String get calcCatAccessories;

  /// No description provided for @calcCalculate.
  ///
  /// In en, this message translates to:
  /// **'Calculate'**
  String get calcCalculate;

  /// No description provided for @calcEstimatedCost.
  ///
  /// In en, this message translates to:
  /// **'Estimated Cost'**
  String get calcEstimatedCost;

  /// No description provided for @calcShippingCost.
  ///
  /// In en, this message translates to:
  /// **'Shipping Cost'**
  String get calcShippingCost;

  /// No description provided for @calcCustomsFee.
  ///
  /// In en, this message translates to:
  /// **'Customs Fee'**
  String get calcCustomsFee;

  /// No description provided for @calcServiceFee.
  ///
  /// In en, this message translates to:
  /// **'Service Fee'**
  String get calcServiceFee;

  /// No description provided for @calcTotalEstimated.
  ///
  /// In en, this message translates to:
  /// **'Total Estimated Cost'**
  String get calcTotalEstimated;

  /// No description provided for @calcShippingVal.
  ///
  /// In en, this message translates to:
  /// **'\$12.00'**
  String get calcShippingVal;

  /// No description provided for @calcCustomsVal.
  ///
  /// In en, this message translates to:
  /// **'\$8.00'**
  String get calcCustomsVal;

  /// No description provided for @calcServiceVal.
  ///
  /// In en, this message translates to:
  /// **'\$3.00'**
  String get calcServiceVal;

  /// No description provided for @calcTotalVal.
  ///
  /// In en, this message translates to:
  /// **'\$23.00'**
  String get calcTotalVal;

  /// No description provided for @calcEstimatedDelivery.
  ///
  /// In en, this message translates to:
  /// **'Estimated Delivery'**
  String get calcEstimatedDelivery;

  /// No description provided for @calcDeliveryDays.
  ///
  /// In en, this message translates to:
  /// **'7 – 10 Days'**
  String get calcDeliveryDays;

  /// No description provided for @checkoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkoutTitle;

  /// No description provided for @checkoutSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm your subscription & pay securely.'**
  String get checkoutSubtitle;

  /// No description provided for @checkoutPlanName.
  ///
  /// In en, this message translates to:
  /// **'Prime cart'**
  String get checkoutPlanName;

  /// No description provided for @checkoutBilledMonthly.
  ///
  /// In en, this message translates to:
  /// **'Billed monthly'**
  String get checkoutBilledMonthly;

  /// No description provided for @checkoutPlanPrice.
  ///
  /// In en, this message translates to:
  /// **'\$19.99'**
  String get checkoutPlanPrice;

  /// No description provided for @checkoutPerMonth.
  ///
  /// In en, this message translates to:
  /// **'/month'**
  String get checkoutPerMonth;

  /// No description provided for @paymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment method'**
  String get paymentMethod;

  /// No description provided for @payMethodCard.
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get payMethodCard;

  /// No description provided for @payMethodPaypal.
  ///
  /// In en, this message translates to:
  /// **'PayPal'**
  String get payMethodPaypal;

  /// No description provided for @payMethodApple.
  ///
  /// In en, this message translates to:
  /// **'Apple'**
  String get payMethodApple;

  /// No description provided for @cardHolderName.
  ///
  /// In en, this message translates to:
  /// **'Card holder name'**
  String get cardHolderName;

  /// No description provided for @orderConfirmButton.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get orderConfirmButton;

  /// No description provided for @cardNumber.
  ///
  /// In en, this message translates to:
  /// **'Card number'**
  String get cardNumber;

  /// No description provided for @cardNumberHint.
  ///
  /// In en, this message translates to:
  /// **'4242 4242 4242 4242'**
  String get cardNumberHint;

  /// No description provided for @cardExpiry.
  ///
  /// In en, this message translates to:
  /// **'Expiry'**
  String get cardExpiry;

  /// No description provided for @cardExpiryHint.
  ///
  /// In en, this message translates to:
  /// **'08 / 28'**
  String get cardExpiryHint;

  /// No description provided for @cardCvv.
  ///
  /// In en, this message translates to:
  /// **'CVV'**
  String get cardCvv;

  /// No description provided for @totalToday.
  ///
  /// In en, this message translates to:
  /// **'Total today'**
  String get totalToday;

  /// No description provided for @payButton.
  ///
  /// In en, this message translates to:
  /// **'Pay \$19.99'**
  String get payButton;

  /// No description provided for @securedEncryption.
  ///
  /// In en, this message translates to:
  /// **'Secured by 256-bit encryption'**
  String get securedEncryption;

  /// No description provided for @planConfirmedThankYou.
  ///
  /// In en, this message translates to:
  /// **'Thank you!'**
  String get planConfirmedThankYou;

  /// No description provided for @planConfirmedBody.
  ///
  /// In en, this message translates to:
  /// **'Your payment was successful and your {plan} plan is now active.'**
  String planConfirmedBody(Object plan);

  /// No description provided for @planConfirmedBodyPrefix.
  ///
  /// In en, this message translates to:
  /// **'Your payment was successful and your '**
  String get planConfirmedBodyPrefix;

  /// No description provided for @planConfirmedBodySuffix.
  ///
  /// In en, this message translates to:
  /// **' plan is now active.'**
  String get planConfirmedBodySuffix;

  /// No description provided for @receiptPlan.
  ///
  /// In en, this message translates to:
  /// **'Plan'**
  String get receiptPlan;

  /// No description provided for @receiptBilling.
  ///
  /// In en, this message translates to:
  /// **'Billing'**
  String get receiptBilling;

  /// No description provided for @receiptBillingMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get receiptBillingMonthly;

  /// No description provided for @receiptNextRenewal.
  ///
  /// In en, this message translates to:
  /// **'Next renewal'**
  String get receiptNextRenewal;

  /// No description provided for @receiptRenewalDate.
  ///
  /// In en, this message translates to:
  /// **'Jul 12, 2026'**
  String get receiptRenewalDate;

  /// No description provided for @receiptAmountPaid.
  ///
  /// In en, this message translates to:
  /// **'Amount paid'**
  String get receiptAmountPaid;

  /// No description provided for @receiptAmountVal.
  ///
  /// In en, this message translates to:
  /// **'\$19.99'**
  String get receiptAmountVal;

  /// No description provided for @backToHome.
  ///
  /// In en, this message translates to:
  /// **'Back to home'**
  String get backToHome;

  /// No description provided for @viewSubscription.
  ///
  /// In en, this message translates to:
  /// **'View my subscription'**
  String get viewSubscription;

  /// No description provided for @myOrderTitle.
  ///
  /// In en, this message translates to:
  /// **'My order:'**
  String get myOrderTitle;

  /// No description provided for @orderDetailTrack.
  ///
  /// In en, this message translates to:
  /// **'Track order'**
  String get orderDetailTrack;

  /// No description provided for @hubWarehouses.
  ///
  /// In en, this message translates to:
  /// **'Our warehouses'**
  String get hubWarehouses;

  /// No description provided for @hubLockers.
  ///
  /// In en, this message translates to:
  /// **'Locker locations'**
  String get hubLockers;

  /// No description provided for @hubPlans.
  ///
  /// In en, this message translates to:
  /// **'Subscription plans'**
  String get hubPlans;

  /// No description provided for @confirmOrderTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm your order'**
  String get confirmOrderTitle;

  /// No description provided for @confirmCustomerName.
  ///
  /// In en, this message translates to:
  /// **'Customer name:'**
  String get confirmCustomerName;

  /// No description provided for @confirmCustomerPhone.
  ///
  /// In en, this message translates to:
  /// **'Customer phone no.:'**
  String get confirmCustomerPhone;

  /// No description provided for @confirmCustomerEmail.
  ///
  /// In en, this message translates to:
  /// **'Customer email:'**
  String get confirmCustomerEmail;

  /// No description provided for @trackOrderTitle.
  ///
  /// In en, this message translates to:
  /// **'Track your order'**
  String get trackOrderTitle;

  /// No description provided for @trackCurrentStatus.
  ///
  /// In en, this message translates to:
  /// **'current status'**
  String get trackCurrentStatus;

  /// No description provided for @trackExpectedDelivery.
  ///
  /// In en, this message translates to:
  /// **'Expected Delivery'**
  String get trackExpectedDelivery;

  /// No description provided for @trackExpectedDate.
  ///
  /// In en, this message translates to:
  /// **'15 June 2026'**
  String get trackExpectedDate;

  /// No description provided for @trackHistory.
  ///
  /// In en, this message translates to:
  /// **'Tracking History'**
  String get trackHistory;

  /// No description provided for @trackStepConfirmed.
  ///
  /// In en, this message translates to:
  /// **'order\nconfirmed'**
  String get trackStepConfirmed;

  /// No description provided for @trackStepShipped.
  ///
  /// In en, this message translates to:
  /// **'order\nshipped'**
  String get trackStepShipped;

  /// No description provided for @trackStepOutForDelivery.
  ///
  /// In en, this message translates to:
  /// **'out for\ndelivery'**
  String get trackStepOutForDelivery;

  /// No description provided for @trackHistoryOrderConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Order confirmed'**
  String get trackHistoryOrderConfirmed;

  /// No description provided for @trackHistoryPackageReceived.
  ///
  /// In en, this message translates to:
  /// **'Package Received'**
  String get trackHistoryPackageReceived;

  /// No description provided for @trackHistoryInTransit.
  ///
  /// In en, this message translates to:
  /// **'In transit'**
  String get trackHistoryInTransit;

  /// No description provided for @trackHistoryCustomClearance.
  ///
  /// In en, this message translates to:
  /// **'Custom clearance'**
  String get trackHistoryCustomClearance;

  /// No description provided for @trackHistoryOutForDelivery.
  ///
  /// In en, this message translates to:
  /// **'Out for Delivery'**
  String get trackHistoryOutForDelivery;

  /// No description provided for @trackHistoryDelivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get trackHistoryDelivered;

  /// No description provided for @statusAtWarehouse.
  ///
  /// In en, this message translates to:
  /// **'At Warehouse'**
  String get statusAtWarehouse;

  /// No description provided for @statusOrderConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Order Confirmed'**
  String get statusOrderConfirmed;

  /// No description provided for @statusOutForDelivery.
  ///
  /// In en, this message translates to:
  /// **'Out for Delivery'**
  String get statusOutForDelivery;

  /// No description provided for @statusPackagingMsg.
  ///
  /// In en, this message translates to:
  /// **'Your package is at our warehouse and being prepared.'**
  String get statusPackagingMsg;

  /// No description provided for @statusShippedMsg.
  ///
  /// In en, this message translates to:
  /// **'Your package is on the way to the destination country.'**
  String get statusShippedMsg;

  /// No description provided for @statusPlacedMsg.
  ///
  /// In en, this message translates to:
  /// **'Your order has been confirmed and is awaiting pickup.'**
  String get statusPlacedMsg;

  /// No description provided for @statusDeliveredMsg.
  ///
  /// In en, this message translates to:
  /// **'Your package has been delivered successfully.'**
  String get statusDeliveredMsg;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get profileTitle;

  /// No description provided for @profileName.
  ///
  /// In en, this message translates to:
  /// **'Name:'**
  String get profileName;

  /// No description provided for @profileEmail.
  ///
  /// In en, this message translates to:
  /// **'Email address:'**
  String get profileEmail;

  /// No description provided for @profilePhone.
  ///
  /// In en, this message translates to:
  /// **'Phone number:'**
  String get profilePhone;

  /// No description provided for @profileCountry.
  ///
  /// In en, this message translates to:
  /// **'Country:'**
  String get profileCountry;

  /// No description provided for @profilePlan.
  ///
  /// In en, this message translates to:
  /// **'Your plan:'**
  String get profilePlan;

  /// No description provided for @profileCurrency.
  ///
  /// In en, this message translates to:
  /// **'Currency:'**
  String get profileCurrency;

  /// No description provided for @profileSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get profileSignOut;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsAccountSection.
  ///
  /// In en, this message translates to:
  /// **'Account settings:'**
  String get settingsAccountSection;

  /// No description provided for @settingsSavedAddresses.
  ///
  /// In en, this message translates to:
  /// **'Saved addresses'**
  String get settingsSavedAddresses;

  /// No description provided for @settingsEditProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit profiles'**
  String get settingsEditProfile;

  /// No description provided for @settingsChangePassword.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get settingsChangePassword;

  /// No description provided for @settingsAppPrefsSection.
  ///
  /// In en, this message translates to:
  /// **'App Preferences:'**
  String get settingsAppPrefsSection;

  /// No description provided for @settingsLanguages.
  ///
  /// In en, this message translates to:
  /// **'Languages'**
  String get settingsLanguages;

  /// No description provided for @settingsCurrency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get settingsCurrency;

  /// No description provided for @settingsNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notification settings'**
  String get settingsNotifications;

  /// No description provided for @settingsSupportSection.
  ///
  /// In en, this message translates to:
  /// **'Support & Help:'**
  String get settingsSupportSection;

  /// No description provided for @settingsHelpCenter.
  ///
  /// In en, this message translates to:
  /// **'Help center'**
  String get settingsHelpCenter;

  /// No description provided for @settingsHaveAnIssue.
  ///
  /// In en, this message translates to:
  /// **'Have an issue'**
  String get settingsHaveAnIssue;

  /// No description provided for @settingsReportProblem.
  ///
  /// In en, this message translates to:
  /// **'Report a problem'**
  String get settingsReportProblem;

  /// No description provided for @settingsAboutUs.
  ///
  /// In en, this message translates to:
  /// **'About us'**
  String get settingsAboutUs;

  /// No description provided for @settingsPolicy.
  ///
  /// In en, this message translates to:
  /// **'Policy'**
  String get settingsPolicy;

  /// No description provided for @settingsContactUs.
  ///
  /// In en, this message translates to:
  /// **'contact us:'**
  String get settingsContactUs;

  /// No description provided for @settingsContactEmail.
  ///
  /// In en, this message translates to:
  /// **'cartflylog@gmail.com'**
  String get settingsContactEmail;

  /// No description provided for @settingsSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get settingsSignOut;

  /// No description provided for @currencyScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get currencyScreenTitle;

  /// No description provided for @currencyEGP.
  ///
  /// In en, this message translates to:
  /// **'EGP'**
  String get currencyEGP;

  /// No description provided for @currencyUSD.
  ///
  /// In en, this message translates to:
  /// **'USD'**
  String get currencyUSD;

  /// No description provided for @currencySAR.
  ///
  /// In en, this message translates to:
  /// **'SAR'**
  String get currencySAR;

  /// No description provided for @langScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get langScreenTitle;

  /// No description provided for @langEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get langEnglish;

  /// No description provided for @langArabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get langArabic;

  /// No description provided for @aboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About us'**
  String get aboutTitle;

  /// No description provided for @aboutBody.
  ///
  /// In en, this message translates to:
  /// **'We are a trusted international shipping service connecting Egypt, the USA, the UAE, China, and Saudi Arabia through one seamless platform. Our goal is to simplify cross-border delivery by providing reliable shipping solutions, transparent pricing, real-time tracking, and efficient order management to ensure every shipment reaches its destination safely and on time.'**
  String get aboutBody;

  /// No description provided for @aboutContactLabel.
  ///
  /// In en, this message translates to:
  /// **'contact us:'**
  String get aboutContactLabel;

  /// No description provided for @aboutContactEmail.
  ///
  /// In en, this message translates to:
  /// **'cartflylog@gmail.com'**
  String get aboutContactEmail;

  /// No description provided for @supportIssueTitle.
  ///
  /// In en, this message translates to:
  /// **'Have an issue?'**
  String get supportIssueTitle;

  /// No description provided for @supportIssueBody.
  ///
  /// In en, this message translates to:
  /// **'If you are experiencing any problem while using the application, we\'re here to help.\n\nWhether it\'s an issue with selecting warehouses, loading data, or anything not working as expected, please let us know.\n\nKindly provide a clear description of the issue, and if possible, include the warehouse you were trying to access and a screenshot to help us understand the problem better.\n\nOur team will review your request and get back to you as soon as possible.'**
  String get supportIssueBody;

  /// No description provided for @supportContactLabel.
  ///
  /// In en, this message translates to:
  /// **'contact us:'**
  String get supportContactLabel;

  /// No description provided for @supportContactEmail.
  ///
  /// In en, this message translates to:
  /// **'cartflylog@gmail.com'**
  String get supportContactEmail;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get navAccount;

  /// No description provided for @navOrders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get navOrders;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;
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
