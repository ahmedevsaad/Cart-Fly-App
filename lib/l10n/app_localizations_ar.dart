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
}
