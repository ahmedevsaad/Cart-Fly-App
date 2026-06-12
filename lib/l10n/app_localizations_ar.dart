import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'كارت فلاي';

  @override
  String get tagline => 'من السلة إلى باب البيت';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get register => 'تسجيل';

  @override
  String get dontHaveAccount => 'ليس لديك حساب';

  @override
  String get email => 'البريد الإلكتروني:';

  @override
  String get password => 'كلمة المرور:';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get fullName => 'الاسم الكامل:';

  @override
  String get phoneNumber => 'رقم الهاتف:';

  @override
  String get country => 'الدولة:';

  @override
  String get currency => 'العملة:';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get sendResetEmail => 'إرسال رابط الاستعادة';

  @override
  String get verifyEmailTitle => 'تحقق من بريدك';

  @override
  String verifyEmailBody(Object email) {
    return 'أرسلنا رابط التحقق إلى $email. اضغط عليه ثم عُد هنا وتابع.';
  }

  @override
  String get iVerified => 'تم التحقق، متابعة';

  @override
  String get welcomeTitle => 'أهلاً بك في كارت فلاي';

  @override
  String get tapToContinue => 'اضغط للمتابعة..';

  @override
  String get ourWarehouses => 'مستودعاتنا';

  @override
  String get howItWorks => 'كيف نعمل؟';

  @override
  String get haveAnIssue => 'هل لديك مشكلة؟';

  @override
  String get lockerLocations => 'مواقع الكاسات';

  @override
  String get ourLockerLocations => 'مواقع كاسّاتنا';

  @override
  String get back => 'رجوع';

  @override
  String get next => 'التالي';

  @override
  String bestFor(Object value) {
    return 'الأفضل لـ: $value';
  }

  @override
  String get whyBuyHere => 'لماذا تشتري من هنا';

  @override
  String get whyBuyLocally => 'لماذا تشتري محلياً';

  @override
  String buyFrom(Object country) {
    return 'اشترِ من $country';
  }

  @override
  String get bestWebsites => 'أفضل المواقع';

  @override
  String get language => 'اللغة';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get support => 'الدعم';

  @override
  String get supportSubject => 'الموضوع';

  @override
  String get supportMessage => 'الرسالة';

  @override
  String get send => 'إرسال';

  @override
  String get errorInvalidEmail => 'أدخل بريداً صالحاً';

  @override
  String get errorPasswordShort => 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';

  @override
  String get errorPasswordsDontMatch => 'كلمتا المرور غير متطابقتين';

  @override
  String get errorRequired => 'مطلوب';

  @override
  String get welcomeUser => 'أهلاً،';

  @override
  String get myOrder => 'طلبي:';

  @override
  String get ourServices => 'خدماتنا:';

  @override
  String get serviceWarehouses => 'مستودعاتنا';

  @override
  String get serviceLockers => 'مواقع\nالكاسات';

  @override
  String get servicePlans => 'خطط\nالاشتراك';

  @override
  String get serviceCalculator => 'حاسبة\nالسلة';

  @override
  String get yourCartFlyAddress => 'عنوان كارت فلاي الخاص بك';

  @override
  String get copyAddress => 'نسخ';

  @override
  String get addressCopied => 'تم نسخ العنوان';

  @override
  String get recipient => 'المستلم';

  @override
  String get address => 'العنوان';

  @override
  String get city => 'المدينة';

  @override
  String get statusOrderPlaced => 'تم الطلب';

  @override
  String get statusShipped => 'تم الشحن';

  @override
  String get statusInTransit => 'في الطريق';

  @override
  String get statusDelivered => 'تم التسليم';

  // Plans
  @override
  String get ourPlans => 'خططنا';

  @override
  String get tapPlanHint => 'اضغط على خطة لمعرفة ما تتضمنه.';

  @override
  String get planBasicName => 'السلة الأساسية';

  @override
  String get planSmartName => 'السلة الذكية';

  @override
  String get planPrimeName => 'السلة المميزة';

  @override
  String get planBasicDesc =>
      'ابدأ مع كارت فلاي مجاناً. اوصل إلى عناوين المستودعات وميزات إدارة الطلبات الأساسية';

  @override
  String get planBasicPrice => 'مجاناً';

  @override
  String get planSmartDesc =>
      'افتح قسائم حصرية واستمتع بحاسبة الطلبات المدمجة لتقديرات تسوق دقيقة وسريعة.';

  @override
  String get planSmartFeatures =>
      '• قسائم خصم\n• حاسبة تكلفة طلبات فورية\n• دعم سهل لإتمام الطلبات';

  @override
  String get planSmartPrice => '12.33 دولار/شهرياً';

  @override
  String get planPrimeDesc =>
      'وفّر أكثر على كل طلب بخصومات مميزة وعروض السوائل وحسابات فورية للأسعار.';

  @override
  String get planPrimeFeatures =>
      '• معدلات خصم أعلى\n• خصومات على المنتجات السائلة\n• خدمة الحاسبة الذكية';

  @override
  String get planPrimePrice => '19.99 دولار/شهرياً';

  @override
  String get subscribeNow => 'اشترك الآن';

  // Calculator
  @override
  String get calcTitle => 'حاسبة الشحن';

  @override
  String get calcSubtitle => 'أدخل التفاصيل أدناه لحساب تكلفة الشحن.';

  @override
  String get calcStep1 => 'التفاصيل';

  @override
  String get calcStep2 => 'الحساب';

  @override
  String get calcStep3 => 'النتيجة';

  @override
  String get calcCountryFrom => 'من دولة';

  @override
  String get calcCountryTo => 'إلى دولة';

  @override
  String get calcCountryChina => 'الصين';

  @override
  String get calcCountryEgypt => 'مصر';

  @override
  String get calcWeight => 'الوزن';

  @override
  String get calcWeightUnit => 'كجم';

  @override
  String get calcProductCategory => 'فئة المنتج';

  @override
  String get calcCatElectronics => 'إلكترونيات';

  @override
  String get calcCatFashion => 'موضة';

  @override
  String get calcCatAccessories => 'إكسسوارات';

  @override
  String get calcCalculate => 'احسب';

  @override
  String get calcEstimatedCost => 'التكلفة التقديرية';

  @override
  String get calcShippingCost => 'تكلفة الشحن';

  @override
  String get calcCustomsFee => 'رسوم الجمارك';

  @override
  String get calcServiceFee => 'رسوم الخدمة';

  @override
  String get calcTotalEstimated => 'إجمالي التكلفة التقديرية';

  @override
  String get calcShippingVal => r'$12.00';

  @override
  String get calcCustomsVal => r'$8.00';

  @override
  String get calcServiceVal => r'$3.00';

  @override
  String get calcTotalVal => r'$23.00';

  @override
  String get calcEstimatedDelivery => 'التسليم المتوقع';

  @override
  String get calcDeliveryDays => '7 – 10 أيام';

  // Plan checkout
  @override
  String get checkoutTitle => 'الدفع';

  @override
  String get checkoutSubtitle => 'أكّد اشتراكك وادفع بأمان.';

  @override
  String get checkoutPlanName => 'السلة المميزة';

  @override
  String get checkoutBilledMonthly => 'يُحصَّل شهرياً';

  @override
  String get checkoutPlanPrice => r'$19.99';

  @override
  String get checkoutPerMonth => '/شهر';

  @override
  String get paymentMethod => 'طريقة الدفع';

  @override
  String get payMethodCard => 'بطاقة';

  @override
  String get payMethodPaypal => 'باي بال';

  @override
  String get payMethodApple => 'آبل';

  @override
  String get cardHolderName => 'اسم صاحب البطاقة';

  @override
  String get orderConfirmButton => 'تأكيد';

  @override
  String get cardNumber => 'رقم البطاقة';

  @override
  String get cardNumberHint => '4242 4242 4242 4242';

  @override
  String get cardExpiry => 'تاريخ الانتهاء';

  @override
  String get cardExpiryHint => '08 / 28';

  @override
  String get cardCvv => 'CVV';

  @override
  String get totalToday => 'الإجمالي اليوم';

  @override
  String get payButton => r'ادفع $19.99';

  @override
  String get securedEncryption => 'مؤمَّن بتشفير 256 بت';

  // Plan confirmed
  @override
  String get planConfirmedThankYou => 'شكراً لك!';

  @override
  String planConfirmedBody(Object plan) =>
      'تمّت عملية الدفع بنجاح وخطتك $plan نشطة الآن.';

  @override
  String get planConfirmedBodyPrefix => 'تمّت عملية الدفع بنجاح وخطة ';

  @override
  String get planConfirmedBodySuffix => ' نشطة الآن.';

  @override
  String get receiptPlan => 'الخطة';

  @override
  String get receiptBilling => 'الفوترة';

  @override
  String get receiptBillingMonthly => 'شهري';

  @override
  String get receiptNextRenewal => 'التجديد القادم';

  @override
  String get receiptRenewalDate => '12 يوليو 2026';

  @override
  String get receiptAmountPaid => 'المبلغ المدفوع';

  @override
  String get receiptAmountVal => r'$19.99';

  @override
  String get backToHome => 'العودة للرئيسية';

  @override
  String get viewSubscription => 'عرض اشتراكي';

  // Profile (Frame 26)
  @override
  String get profileTitle => 'ملفي الشخصي';
  @override
  String get profileName => 'الاسم:';
  @override
  String get profileEmail => 'البريد الإلكتروني:';
  @override
  String get profilePhone => 'رقم الهاتف:';
  @override
  String get profileCountry => 'الدولة:';
  @override
  String get profilePlan => 'خطتك:';
  @override
  String get profileCurrency => 'العملة:';
  @override
  String get profileSignOut => 'تسجيل الخروج';

  // Settings (Frame 27)
  @override
  String get settingsTitle => 'الإعدادات';
  @override
  String get settingsAccountSection => 'إعدادات الحساب:';
  @override
  String get settingsSavedAddresses => 'العناوين المحفوظة';
  @override
  String get settingsEditProfile => 'تعديل الملفات الشخصية';
  @override
  String get settingsChangePassword => 'تغيير كلمة المرور';
  @override
  String get settingsAppPrefsSection => 'تفضيلات التطبيق:';
  @override
  String get settingsLanguages => 'اللغات';
  @override
  String get settingsCurrency => 'العملة';
  @override
  String get settingsNotifications => 'إعدادات الإشعارات';
  @override
  String get settingsSupportSection => 'الدعم والمساعدة:';
  @override
  String get settingsHelpCenter => 'مركز المساعدة';
  @override
  String get settingsHaveAnIssue => 'هل لديك مشكلة';
  @override
  String get settingsReportProblem => 'الإبلاغ عن مشكلة';
  @override
  String get settingsAboutUs => 'من نحن';
  @override
  String get settingsPolicy => 'السياسة';
  @override
  String get settingsContactUs => 'تواصل معنا:';
  @override
  String get settingsContactEmail => 'cartflylog@gmail.com';
  @override
  String get settingsSignOut => 'تسجيل الخروج';

  // Currency screen (Frame 28)
  @override
  String get currencyScreenTitle => 'الإعدادات';
  @override
  String get currencyEGP => 'EGP';
  @override
  String get currencyUSD => 'USD';
  @override
  String get currencySAR => 'SAR';

  // Language screen (Frame 29)
  @override
  String get langScreenTitle => 'الإعدادات';
  @override
  String get langEnglish => 'English';
  @override
  String get langArabic => 'العربية';

  // About screen (Frame 30)
  @override
  String get aboutTitle => 'من نحن';
  @override
  String get aboutBody =>
      'نحن خدمة شحن دولية موثوقة تربط مصر والولايات المتحدة والإمارات والصين والمملكة العربية السعودية عبر منصة واحدة متكاملة. هدفنا تبسيط التوصيل عبر الحدود من خلال توفير حلول شحن موثوقة وتسعير شفاف وتتبع فوري وإدارة فعّالة للطلبات لضمان وصول كل شحنة إلى وجهتها بأمان وفي الوقت المحدد.';
  @override
  String get aboutContactLabel => 'تواصل معنا:';
  @override
  String get aboutContactEmail => 'cartflylog@gmail.com';

  // Support / Have an issue (Frame 31)
  @override
  String get supportIssueTitle => 'هل لديك مشكلة؟';
  @override
  String get supportIssueBody =>
      'إذا كنت تواجه أي مشكلة أثناء استخدام التطبيق، نحن هنا للمساعدة.\n\nسواء كانت مشكلة في اختيار المستودعات أو تحميل البيانات أو أي شيء لا يعمل كما هو متوقع، يُرجى إعلامنا.\n\nيُرجى تقديم وصف واضح للمشكلة، وإن أمكن، أذكر المستودع الذي كنت تحاول الوصول إليه وأرفق لقطة شاشة لمساعدتنا على فهم المشكلة بشكل أفضل.\n\nسيراجع فريقنا طلبك ويعود إليك في أقرب وقت ممكن.';
  @override
  String get supportContactLabel => 'تواصل معنا:';
  @override
  String get supportContactEmail => 'cartflylog@gmail.com';

  // Orders hub / detail (Frames 13-15)
  @override
  String get myOrderTitle => 'طلبي:';
  @override
  String get orderDetailTrack => 'تتبع الطلب';
  @override
  String get hubWarehouses => 'مستودعاتنا';
  @override
  String get hubLockers => 'مواقع الكاسات';
  @override
  String get hubPlans => 'خطط الاشتراك';

  // Confirm order (Frame 23)
  @override
  String get confirmOrderTitle => 'تأكيد طلبك';
  @override
  String get confirmCustomerName => 'اسم العميل:';
  @override
  String get confirmCustomerPhone => 'رقم هاتف العميل:';
  @override
  String get confirmCustomerEmail => 'بريد العميل الإلكتروني:';

  // Track order (Frame 25)
  @override
  String get trackOrderTitle => 'تتبع طلبك';
  @override
  String get trackCurrentStatus => 'الحالة الحالية';
  @override
  String get trackExpectedDelivery => 'التسليم المتوقع';
  @override
  String get trackExpectedDate => '15 يونيو 2026';
  @override
  String get trackHistory => 'سجل التتبع';
  @override
  String get trackStepConfirmed => 'تم\nتأكيد الطلب';
  @override
  String get trackStepShipped => 'تم\nشحن الطلب';
  @override
  String get trackStepOutForDelivery => 'خرج\nللتسليم';
  @override
  String get trackHistoryOrderConfirmed => 'تم تأكيد الطلب';
  @override
  String get trackHistoryPackageReceived => 'تم استلام الطرد';
  @override
  String get trackHistoryInTransit => 'في الطريق';
  @override
  String get trackHistoryCustomClearance => 'التخليص الجمركي';
  @override
  String get trackHistoryOutForDelivery => 'خرج للتسليم';
  @override
  String get trackHistoryDelivered => 'تم التسليم';

  // Order status labels + messages
  @override
  String get statusAtWarehouse => 'في المستودع';
  @override
  String get statusOrderConfirmed => 'تم تأكيد الطلب';
  @override
  String get statusOutForDelivery => 'خرج للتسليم';
  @override
  String get statusPackagingMsg => 'طردك في مستودعنا ويجري تجهيزه.';
  @override
  String get statusShippedMsg => 'طردك في طريقه إلى الدولة المقصودة.';
  @override
  String get statusPlacedMsg => 'تم تأكيد طلبك وهو في انتظار الاستلام.';
  @override
  String get statusDeliveredMsg => 'تم تسليم طردك بنجاح.';
}
