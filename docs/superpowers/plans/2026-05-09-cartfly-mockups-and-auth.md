# CartFly Mockups + Auth Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replicate the 14 screens in `screenshots/` and ship a working email/password + email-verification + password-reset auth flow on top of Firebase. Bilingual EN/AR with RTL. Targets Android, iOS, Web.

**Architecture:** Single-module Flutter app, `Provider` for state, `go_router` for navigation, Firebase Auth + Firestore for users, `flutter_map` for locker maps, ARB-based localization. Static screen content (warehouses, how-it-works, locker city groups) baked into dart files.

**Tech Stack:** Flutter 3.27 / Dart 3.6, Firebase (core/auth/firestore), provider, go_router, flutter_map + latlong2, google_fonts, flutter_svg, flutter_localizations + intl, shared_preferences.

**Test policy (read this):** This is a university project. The user explicitly asked that the code not look AI-generated. Mechanical "write a test for every widget" pattern is exactly the AI tell. Tests are written for code that has real logic worth testing — `AuthProvider`, the `go_router` redirect, locale persistence. UI screens are verified by `flutter run` against the screenshots, not by widget tests. Don't add ceremonial tests just to pad the plan.

**Working directory:** `c:\Users\A\Desktop\cart-fly` (Flutter project already scaffolded; `lib/main.dart` is still the default counter app).

---

## Phase 0 — Repo prep

### Task 0.1: Initialize git repo, baseline commit

**Files:** none new — just version control bootstrap.

- [ ] **Step 1: Init repo**

Run:
```
git init
git add -A
git commit -m "chore: scaffold flutter project"
```

- [ ] **Step 2: Verify**

Run: `git log --oneline`
Expected: one commit "chore: scaffold flutter project".

---

## Phase 1 — Dependencies and assets

### Task 1.1: Replace `pubspec.yaml` with full deps + asset declarations

**Files:**
- Modify: `pubspec.yaml` (full replace)

- [ ] **Step 1: Overwrite pubspec.yaml**

```yaml
name: cartfly
description: "CartFly — cross-border shopping assistant."
publish_to: "none"
version: 0.1.0+1

environment:
  sdk: ">=3.6.0 <4.0.0"

dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  cupertino_icons: ^1.0.8

  firebase_core: ^3.6.0
  firebase_auth: ^5.3.1
  cloud_firestore: ^5.4.4

  provider: ^6.1.2
  go_router: ^14.6.1
  shared_preferences: ^2.3.2

  google_fonts: ^6.2.1
  flutter_svg: ^2.0.10
  flutter_map: ^7.0.2
  latlong2: ^0.9.1
  intl: any

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0

flutter:
  uses-material-design: true
  generate: true
  assets:
    - assets/flags/
    - assets/maps/
    - assets/pattern/
```

- [ ] **Step 2: Create asset directories**

PowerShell:
```
New-Item -ItemType Directory -Force assets/flags, assets/maps, assets/pattern | Out-Null
```

- [ ] **Step 3: Pub get**

Run: `flutter pub get`
Expected: "Got dependencies!" with no errors.

- [ ] **Step 4: Commit**

```
git add pubspec.yaml pubspec.lock assets
git commit -m "chore: add deps and asset folders"
```

### Task 1.2: Drop placeholder asset files

**Files:**
- Create: `assets/pattern/airplane_box.svg`
- Create: `assets/flags/README.md`, `assets/maps/README.md`

The flag and map assets are filled in later (user supplies). For now we ship the SVG pattern (a tiny inline drawing) and README placeholders so the asset bundle resolves.

- [ ] **Step 1: Write the SVG pattern**

Create `assets/pattern/airplane_box.svg`:
```xml
<svg xmlns="http://www.w3.org/2000/svg" width="240" height="240" viewBox="0 0 240 240">
  <g fill="#3B5EE3" fill-opacity="0.07">
    <!-- airplane -->
    <path d="M40 60 l40 -8 l8 -16 l6 0 l-2 14 l28 -6 l4 6 l-30 12 l-2 16 l10 -2 l4 6 l-14 4 l-6 8 l-4 0 l2 -8 l-30 6 l-4 -6 l30 -10 z"/>
    <!-- box -->
    <path d="M150 130 l30 -10 l30 10 l0 30 l-30 10 l-30 -10 z M150 130 l30 10 l0 30 M210 130 l-30 10 l0 30" fill="none" stroke="#3B5EE3" stroke-opacity="0.18" stroke-width="2"/>
    <!-- second small plane -->
    <path d="M170 50 l24 -4 l5 -10 l4 0 l-1 9 l16 -3 l3 4 l-18 7 l-1 10 l6 -1 l3 4 l-9 2 l-4 5 l-3 0 l1 -5 l-18 4 l-3 -4 l18 -6 z"/>
    <!-- second box -->
    <path d="M50 160 l22 -8 l22 8 l0 24 l-22 8 l-22 -8 z" fill="none" stroke="#3B5EE3" stroke-opacity="0.18" stroke-width="2"/>
  </g>
</svg>
```

- [ ] **Step 2: README stubs**

Create `assets/flags/README.md`:
```
Flag PNGs go here, named: sa.png eg.png ae.png us.png cn.png
Rounded-corner flags matching the mockups in screenshots/.
Until real assets are dropped in, FlagIcon falls back to the country emoji.
```

Create `assets/maps/README.md`:
```
Country map images (used as decorative backdrops only — real maps render via flutter_map).
Names: world.png saudi.png egypt.png uae.png usa.png china.png
```

- [ ] **Step 3: Commit**

```
git add assets
git commit -m "chore: add bg pattern svg and asset readmes"
```

---

## Phase 2 — Theme and shared widgets

### Task 2.1: Color tokens

**Files:**
- Create: `lib/theme/colors.dart`

- [ ] **Step 1: Write colors.dart**

```dart
import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const bgBlue = Color(0xFFDCE7FF);
  static const bgSoft = Color(0xFFF4F7FF);
  static const primary = Color(0xFF3B5EE3);
  static const primaryButton = Color(0xFF8FA8E8);
  static const border = Color(0xFF1B2C7A);
  static const text = Color(0xFF0B0B0B);
  static const muted = Color(0xFF6B6B6B);
  static const surface = Colors.white;
}
```

### Task 2.2: Text theme

**Files:**
- Create: `lib/theme/text_theme.dart`

- [ ] **Step 1: Write text_theme.dart**

```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

TextTheme buildTextTheme(Locale locale) {
  final body = locale.languageCode == 'ar'
      ? GoogleFonts.cairoTextTheme()
      : GoogleFonts.interTextTheme();
  final display = GoogleFonts.dmSerifDisplay();

  return body.copyWith(
    displayLarge: display.copyWith(fontSize: 56, color: AppColors.primary, fontStyle: FontStyle.italic),
    displayMedium: display.copyWith(fontSize: 40, color: AppColors.primary, fontStyle: FontStyle.italic),
    headlineLarge: display.copyWith(fontSize: 28, color: AppColors.primary),
    headlineSmall: body.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: AppColors.text),
    titleLarge: body.titleLarge?.copyWith(fontWeight: FontWeight.w600, color: AppColors.text),
    bodyLarge: body.bodyLarge?.copyWith(fontSize: 16, color: AppColors.text),
    bodyMedium: body.bodyMedium?.copyWith(fontSize: 14, color: AppColors.text),
    labelLarge: body.labelLarge?.copyWith(fontWeight: FontWeight.w600),
  );
}
```

### Task 2.3: App theme

**Files:**
- Create: `lib/theme/app_theme.dart`

- [ ] **Step 1: Write app_theme.dart**

```dart
import 'package:flutter/material.dart';
import 'colors.dart';
import 'text_theme.dart';

ThemeData buildAppTheme(Locale locale) {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      surface: AppColors.surface,
      primary: AppColors.primary,
    ),
    scaffoldBackgroundColor: AppColors.bgSoft,
    textTheme: buildTextTheme(locale),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryButton,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.text,
        minimumSize: const Size(double.infinity, 52),
        side: const BorderSide(color: AppColors.border, width: 1.4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
    ),
  );
}
```

- [ ] **Step 2: Commit theme**

```
git add lib/theme
git commit -m "feat: theme tokens, text theme, and material theme"
```

### Task 2.4: AppBackground widget

**Files:**
- Create: `lib/widgets/app_background.dart`

- [ ] **Step 1: Write the widget**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/colors.dart';

class AppBackground extends StatelessWidget {
  const AppBackground({super.key, required this.child, this.solid});

  final Widget child;
  final Color? solid;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: solid ?? AppColors.bgSoft,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (solid == null)
            Positioned.fill(
              child: SvgPicture.asset(
                'assets/pattern/airplane_box.svg',
                fit: BoxFit.none,
                repeat: ImageRepeat.repeat,
              ),
            ),
          child,
        ],
      ),
    );
  }
}
```

### Task 2.5: AppLogo widget

**Files:**
- Create: `lib/widgets/app_logo.dart`

- [ ] **Step 1: Write it**

```dart
import 'package:flutter/material.dart';
import '../theme/colors.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 40});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Text(
      'CartFly',
      style: Theme.of(context).textTheme.displayMedium?.copyWith(
            fontSize: size,
            color: AppColors.primary,
            fontStyle: FontStyle.italic,
          ),
    );
  }
}
```

### Task 2.6: LabeledTextField

**Files:**
- Create: `lib/widgets/labeled_text_field.dart`

- [ ] **Step 1: Write it**

```dart
import 'package:flutter/material.dart';

class LabeledTextField extends StatelessWidget {
  const LabeledTextField({
    super.key,
    required this.label,
    this.controller,
    this.obscure = false,
    this.keyboardType,
    this.validator,
    this.textInputAction,
  });

  final String label;
  final TextEditingController? controller;
  final bool obscure;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          validator: validator,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
```

### Task 2.7: MenuButton (home screen big rounded buttons)

**Files:**
- Create: `lib/widgets/menu_button.dart`

- [ ] **Step 1: Write it**

```dart
import 'package:flutter/material.dart';
import '../theme/colors.dart';

class MenuButton extends StatelessWidget {
  const MenuButton({super.key, required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 64,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border, width: 1.4),
        ),
        child: Text(label, style: const TextStyle(
          fontWeight: FontWeight.w800, fontSize: 18, color: Colors.black,
        )),
      ),
    );
  }
}
```

### Task 2.8: FlagIcon widget (with emoji fallback)

**Files:**
- Create: `lib/widgets/flag_icon.dart`

- [ ] **Step 1: Write it**

```dart
import 'package:flutter/material.dart';

class FlagIcon extends StatelessWidget {
  const FlagIcon({super.key, required this.code, this.size = 96});
  final String code; // 'sa', 'eg', 'ae', 'us', 'cn'
  final double size;

  static const Map<String, String> _emoji = {
    'sa': '🇸🇦', 'eg': '🇪🇬', 'ae': '🇦🇪', 'us': '🇺🇸', 'cn': '🇨🇳',
  };

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Image.asset(
        'assets/flags/$code.png',
        width: size, height: size * 0.7, fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          width: size, height: size * 0.7,
          color: const Color(0xFFE8ECFF),
          alignment: Alignment.center,
          child: Text(_emoji[code] ?? '🏳️',
              style: TextStyle(fontSize: size * 0.55)),
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: Commit shared widgets**

```
git add lib/widgets
git commit -m "feat: shared widgets (background, logo, text field, menu button, flag)"
```

---

## Phase 3 — Localization

### Task 3.1: ARB files

**Files:**
- Create: `lib/l10n/app_en.arb`
- Create: `lib/l10n/app_ar.arb`
- Create: `l10n.yaml`

- [ ] **Step 1: l10n.yaml**

```yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
output-class: AppLocalizations
output-dir: lib/l10n
synthetic-package: false
```

`synthetic-package: false` writes the generated file to `lib/l10n/app_localizations.dart` so the screens can import it via a normal relative path.

- [ ] **Step 2: app_en.arb**

```json
{
  "@@locale": "en",
  "appTitle": "CartFly",
  "tagline": "from cart to doorstep",
  "login": "Login",
  "register": "Register",
  "dontHaveAccount": "Don't have an account",
  "email": "Email:",
  "password": "Password:",
  "confirmPassword": "Confirm password",
  "fullName": "Full name:",
  "phoneNumber": "Phone number:",
  "country": "Country:",
  "currency": "Currency:",
  "createAccount": "Create account",
  "forgotPassword": "Forgot password?",
  "sendResetEmail": "Send reset email",
  "verifyEmailTitle": "Verify your email",
  "verifyEmailBody": "We sent a verification link to {email}. Tap it, then return here and continue.",
  "@verifyEmailBody": {"placeholders": {"email": {}}},
  "iVerified": "I verified, continue",
  "welcomeTitle": "Welcome to cartfly",
  "tapToContinue": "tap to continue..",
  "ourWarehouses": "Our warehouses",
  "howItWorks": "How it works?",
  "haveAnIssue": "Have an issue?",
  "lockerLocations": "Locker locations",
  "ourLockerLocations": "our lockers locations",
  "back": "Back",
  "next": "Next",
  "bestFor": "Best for: {value}",
  "@bestFor": {"placeholders": {"value": {}}},
  "whyBuyHere": "Why buy here",
  "whyBuyLocally": "Why buy locally",
  "buyFrom": "Buy from {country}",
  "@buyFrom": {"placeholders": {"country": {}}},
  "bestWebsites": "Best websites",
  "language": "Language",
  "logout": "Logout",
  "profile": "Profile",
  "support": "Support",
  "supportSubject": "Subject",
  "supportMessage": "Message",
  "send": "Send",
  "errorInvalidEmail": "Enter a valid email",
  "errorPasswordShort": "Password must be at least 6 characters",
  "errorPasswordsDontMatch": "Passwords do not match",
  "errorRequired": "Required"
}
```

- [ ] **Step 3: app_ar.arb (translations)**

```json
{
  "@@locale": "ar",
  "appTitle": "كارت فلاي",
  "tagline": "من السلة إلى باب البيت",
  "login": "تسجيل الدخول",
  "register": "تسجيل",
  "dontHaveAccount": "ليس لديك حساب",
  "email": "البريد الإلكتروني:",
  "password": "كلمة المرور:",
  "confirmPassword": "تأكيد كلمة المرور",
  "fullName": "الاسم الكامل:",
  "phoneNumber": "رقم الهاتف:",
  "country": "الدولة:",
  "currency": "العملة:",
  "createAccount": "إنشاء حساب",
  "forgotPassword": "نسيت كلمة المرور؟",
  "sendResetEmail": "إرسال رابط الاستعادة",
  "verifyEmailTitle": "تحقق من بريدك",
  "verifyEmailBody": "أرسلنا رابط التحقق إلى {email}. اضغط عليه ثم عُد هنا وتابع.",
  "iVerified": "تم التحقق، متابعة",
  "welcomeTitle": "أهلاً بك في كارت فلاي",
  "tapToContinue": "اضغط للمتابعة..",
  "ourWarehouses": "مستودعاتنا",
  "howItWorks": "كيف نعمل؟",
  "haveAnIssue": "هل لديك مشكلة؟",
  "lockerLocations": "مواقع الكاسات",
  "ourLockerLocations": "مواقع كاسّاتنا",
  "back": "رجوع",
  "next": "التالي",
  "bestFor": "الأفضل لـ: {value}",
  "whyBuyHere": "لماذا تشتري من هنا",
  "whyBuyLocally": "لماذا تشتري محلياً",
  "buyFrom": "اشترِ من {country}",
  "bestWebsites": "أفضل المواقع",
  "language": "اللغة",
  "logout": "تسجيل الخروج",
  "profile": "الملف الشخصي",
  "support": "الدعم",
  "supportSubject": "الموضوع",
  "supportMessage": "الرسالة",
  "send": "إرسال",
  "errorInvalidEmail": "أدخل بريداً صالحاً",
  "errorPasswordShort": "كلمة المرور يجب أن تكون 6 أحرف على الأقل",
  "errorPasswordsDontMatch": "كلمتا المرور غير متطابقتين",
  "errorRequired": "مطلوب"
}
```

- [ ] **Step 4: Generate**

Run: `flutter gen-l10n`
Expected: file generated under `.dart_tool/flutter_gen/gen_l10n/`.

- [ ] **Step 5: Commit**

```
git add lib/l10n l10n.yaml
git commit -m "feat: i18n with EN and AR"
```

### Task 3.2: LocaleProvider (persists choice in SharedPreferences)

**Files:**
- Create: `lib/app/locale_provider.dart`

- [ ] **Step 1: Write it**

```dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');
  Locale get locale => _locale;

  static const _key = 'locale';

  Future<void> load() async {
    final p = await SharedPreferences.getInstance();
    final code = p.getString(_key);
    if (code != null) _locale = Locale(code);
    notifyListeners();
  }

  Future<void> set(Locale locale) async {
    _locale = locale;
    notifyListeners();
    final p = await SharedPreferences.getInstance();
    await p.setString(_key, locale.languageCode);
  }

  void toggle() => set(_locale.languageCode == 'en'
      ? const Locale('ar')
      : const Locale('en'));
}
```

- [ ] **Step 2: Commit**

```
git add lib/app/locale_provider.dart
git commit -m "feat: locale provider with persistence"
```

---

## Phase 4 — Firebase + Auth

### Task 4.1: Firebase project setup

**Files:** generated `firebase_options.dart`, native config files.

- [ ] **Step 1: Install FlutterFire CLI (skip if already installed)**

Run: `dart pub global activate flutterfire_cli`

- [ ] **Step 2: Configure Firebase project**

Run: `flutterfire configure --project=cartfly-univ`
- Select platforms: android, ios, web (not macos / windows / linux).
- Pick or create Firebase project `cartfly-univ`.

Expected: writes `lib/firebase_options.dart`, `android/app/google-services.json`, `ios/Runner/GoogleService-Info.plist`, web index updated.

- [ ] **Step 3: Enable Email/Password sign-in**

Manual step in Firebase Console: Authentication → Sign-in method → enable Email/Password (with "Email link" off).

- [ ] **Step 4: Initialize Firestore in test mode**

Manual: Firebase Console → Firestore → Create database → start in test mode (university scope; harden rules later if shipping).

- [ ] **Step 5: Commit**

```
git add lib/firebase_options.dart android/app/google-services.json ios/Runner/GoogleService-Info.plist web/index.html
git commit -m "chore: configure firebase for android/ios/web"
```

### Task 4.2: AppUser model

**Files:**
- Create: `lib/data/models/app_user.dart`

- [ ] **Step 1: Write it**

```dart
class AppUser {
  AppUser({
    required this.uid,
    required this.name,
    required this.phone,
    required this.email,
    required this.country,
    required this.currency,
  });

  final String uid;
  final String name;
  final String phone;
  final String email;
  final String country;
  final String currency;

  Map<String, dynamic> toMap() => {
        'name': name, 'phone': phone, 'email': email,
        'country': country, 'currency': currency,
      };

  factory AppUser.fromMap(String uid, Map<String, dynamic> m) => AppUser(
        uid: uid,
        name: m['name'] as String? ?? '',
        phone: m['phone'] as String? ?? '',
        email: m['email'] as String? ?? '',
        country: m['country'] as String? ?? '',
        currency: m['currency'] as String? ?? 'USD',
      );
}
```

### Task 4.3: AuthProvider — write tests first

**Files:**
- Create: `test/auth/auth_status_test.dart`

The provider does meaningful work (state machine, async). Worth a test. Heavy mocking of FirebaseAuth is brittle — test the pure status mapping instead.

- [ ] **Step 1: Write the test**

```dart
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

  test('pendingOtp keeps user but blocks app', () {
    final s = AuthState.pendingOtp(email: 'a@b.com');
    expect(s.status, AuthStatus.pendingOtp);
    expect(s.pendingEmail, 'a@b.com');
  });
}
```

- [ ] **Step 2: Run — should fail (file missing)**

Run: `flutter test test/auth/auth_status_test.dart`
Expected: FAIL — `auth_provider.dart` missing.

### Task 4.4: AuthProvider implementation

**Files:**
- Create: `lib/features/auth/auth_provider.dart`

- [ ] **Step 1: Write the provider**

```dart
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../../data/models/app_user.dart';

enum AuthStatus { loading, authenticated, unauthenticated, pendingOtp }

class AuthState {
  AuthState({required this.status, this.user, this.pendingEmail});

  final AuthStatus status;
  final AppUser? user;
  final String? pendingEmail;

  factory AuthState.initial() => AuthState(status: AuthStatus.loading);
  factory AuthState.signedOut() => AuthState(status: AuthStatus.unauthenticated);
  factory AuthState.pendingOtp({required String email}) =>
      AuthState(status: AuthStatus.pendingOtp, pendingEmail: email);
  factory AuthState.signedIn(AppUser u) =>
      AuthState(status: AuthStatus.authenticated, user: u);
}

class AuthProvider extends ChangeNotifier {
  AuthProvider({FirebaseAuth? auth, FirebaseFirestore? db})
      : _auth = auth ?? FirebaseAuth.instance,
        _db = db ?? FirebaseFirestore.instance {
    _sub = _auth.authStateChanges().listen(_onAuthChange);
  }

  final FirebaseAuth _auth;
  final FirebaseFirestore _db;
  late final StreamSubscription<User?> _sub;

  AuthState _state = AuthState.initial();
  AuthState get state => _state;
  String? errorKey;

  Future<void> _onAuthChange(User? u) async {
    if (u == null) {
      _set(AuthState.signedOut());
      return;
    }
    if (!u.emailVerified) {
      _set(AuthState.pendingOtp(email: u.email ?? ''));
      return;
    }
    final doc = await _db.collection('users').doc(u.uid).get();
    final profile = AppUser.fromMap(u.uid, doc.data() ?? {'email': u.email});
    _set(AuthState.signedIn(profile));
  }

  void _set(AuthState s) { _state = s; errorKey = null; notifyListeners(); }
  void _fail(String key) { errorKey = key; notifyListeners(); }

  Future<bool> register({
    required String name, required String phone, required String email,
    required String country, required String currency, required String password,
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await _db.collection('users').doc(cred.user!.uid).set({
        'name': name, 'phone': phone, 'email': email,
        'country': country, 'currency': currency,
        'createdAt': FieldValue.serverTimestamp(),
      });
      await cred.user!.sendEmailVerification();
      _set(AuthState.pendingOtp(email: email));
      return true;
    } on FirebaseAuthException catch (e) {
      _fail('errorAuth_${e.code}'); return false;
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      _fail('errorAuth_${e.code}'); return false;
    }
  }

  Future<bool> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email); return true;
    } on FirebaseAuthException catch (e) {
      _fail('errorAuth_${e.code}'); return false;
    }
  }

  Future<bool> reloadVerified() async {
    await _auth.currentUser?.reload();
    final u = _auth.currentUser;
    if (u != null && u.emailVerified) {
      await _onAuthChange(u);
      return true;
    }
    return false;
  }

  Future<void> logout() => _auth.signOut();

  @override
  void dispose() { _sub.cancel(); super.dispose(); }
}
```

- [ ] **Step 2: Run tests — should pass**

Run: `flutter test test/auth/auth_status_test.dart`
Expected: 3 passed.

- [ ] **Step 3: Commit**

```
git add lib/data/models/app_user.dart lib/features/auth/auth_provider.dart test/auth
git commit -m "feat: AppUser model and AuthProvider"
```

---

## Phase 5 — Routing

### Task 5.1: Route names

**Files:**
- Create: `lib/router/routes.dart`

- [ ] **Step 1: Write it**

```dart
class Routes {
  Routes._();
  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const otp = '/otp';
  static const forgot = '/forgot';
  static const welcome = '/welcome';
  static const home = '/home';
  static const warehouses = '/warehouses';
  static const warehouseDetail = '/warehouses/:code';
  static const howItWorks = '/how-it-works';
  static const lockers = '/lockers';
  static const lockersCountry = '/lockers/:code';
  static const support = '/support';
}
```

### Task 5.2: Router with redirect

**Files:**
- Create: `lib/router/app_router.dart`

Screens used here are imported up front; placeholder screens are filled in Phase 6+.

- [ ] **Step 1: Write router (forward references to screens are fine — they get created in later tasks)**

```dart
import 'package:go_router/go_router.dart';
import '../features/auth/auth_provider.dart';
import '../features/auth/login_screen.dart';
import '../features/auth/register_screen.dart';
import '../features/auth/otp_screen.dart';
import '../features/auth/forgot_password_screen.dart';
import '../features/splash/splash_screen.dart';
import '../features/welcome/welcome_screen.dart';
import '../features/home/home_screen.dart';
import '../features/warehouses/warehouses_screen.dart';
import '../features/warehouses/warehouse_detail_screen.dart';
import '../features/how_it_works/how_it_works_screen.dart';
import '../features/lockers/lockers_world_screen.dart';
import '../features/lockers/country_lockers_screen.dart';
import '../features/support/support_screen.dart';
import 'routes.dart';

GoRouter buildRouter(AuthProvider auth) {
  return GoRouter(
    initialLocation: Routes.splash,
    refreshListenable: auth,
    redirect: (ctx, state) {
      final s = auth.state.status;
      final loc = state.matchedLocation;
      const publicRoutes = {Routes.splash, Routes.login, Routes.register, Routes.forgot};

      if (s == AuthStatus.loading) {
        return loc == Routes.splash ? null : Routes.splash;
      }
      if (s == AuthStatus.pendingOtp) {
        return loc == Routes.otp ? null : Routes.otp;
      }
      if (s == AuthStatus.unauthenticated) {
        return publicRoutes.contains(loc) ? null : Routes.login;
      }
      // authenticated
      if (publicRoutes.contains(loc) || loc == Routes.otp) {
        return Routes.home;
      }
      return null;
    },
    routes: [
      GoRoute(path: Routes.splash, builder: (_, __) => const SplashScreen()),
      GoRoute(path: Routes.login, builder: (_, __) => const LoginScreen()),
      GoRoute(path: Routes.register, builder: (_, __) => const RegisterScreen()),
      GoRoute(path: Routes.otp, builder: (_, __) => const OtpScreen()),
      GoRoute(path: Routes.forgot, builder: (_, __) => const ForgotPasswordScreen()),
      GoRoute(path: Routes.welcome, builder: (_, __) => const WelcomeScreen()),
      GoRoute(path: Routes.home, builder: (_, __) => const HomeScreen()),
      GoRoute(path: Routes.warehouses, builder: (_, __) => const WarehousesScreen()),
      GoRoute(
        path: Routes.warehouseDetail,
        builder: (_, st) => WarehouseDetailScreen(code: st.pathParameters['code']!),
      ),
      GoRoute(path: Routes.howItWorks, builder: (_, __) => const HowItWorksScreen()),
      GoRoute(path: Routes.lockers, builder: (_, __) => const LockersWorldScreen()),
      GoRoute(
        path: Routes.lockersCountry,
        builder: (_, st) => CountryLockersScreen(code: st.pathParameters['code']!),
      ),
      GoRoute(path: Routes.support, builder: (_, __) => const SupportScreen()),
    ],
  );
}
```

- [ ] **Step 2: Commit (will not compile yet — screen files coming next)**

```
git add lib/router
git commit -m "feat: go_router with auth redirect"
```

---

## Phase 6 — App entrypoint

### Task 6.1: app.dart

**Files:**
- Create: `lib/app.dart`

- [ ] **Step 1: Write it**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'app/locale_provider.dart';
import 'features/auth/auth_provider.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';
import 'l10n/app_localizations.dart';

class CartFlyApp extends StatefulWidget {
  const CartFlyApp({super.key});
  @override
  State<CartFlyApp> createState() => _CartFlyAppState();
}

class _CartFlyAppState extends State<CartFlyApp> {
  late final AuthProvider _auth = AuthProvider();
  late final LocaleProvider _locale = LocaleProvider()..load();

  @override
  void dispose() { _auth.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _auth),
        ChangeNotifierProvider.value(value: _locale),
      ],
      child: Consumer<LocaleProvider>(
        builder: (context, lp, _) {
          return MaterialApp.router(
            title: 'CartFly',
            debugShowCheckedModeBanner: false,
            theme: buildAppTheme(lp.locale),
            locale: lp.locale,
            supportedLocales: const [Locale('en'), Locale('ar')],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            routerConfig: buildRouter(_auth),
          );
        },
      ),
    );
  }
}
```

### Task 6.2: main.dart

**Files:**
- Modify: `lib/main.dart` (replace generated counter app)

- [ ] **Step 1: Replace contents**

```dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'app.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const CartFlyApp());
}
```

- [ ] **Step 2: Commit (still won't compile — screens missing)**

```
git add lib/app.dart lib/main.dart
git commit -m "feat: app entry with providers and router"
```

---

## Phase 7 — Screens (each replicates its mockup)

Screens are independent and small. Each task creates one file. After each one, optionally `flutter run` and visually compare to the screenshot.

### Task 7.1: Splash

**Files:**
- Create: `lib/features/splash/splash_screen.dart`

Screenshot: `WhatsApp Image 2026-05-09 at 7.55.12 PM.jpeg`. Solid `bgBlue`, centered logo + tagline, two buttons at bottom.

- [ ] **Step 1: Write it**

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../l10n/app_localizations.dart';
import '../../router/routes.dart';
import '../../theme/colors.dart';
import '../../widgets/app_logo.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.bgBlue,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const Spacer(flex: 3),
              const AppLogo(size: 72),
              const SizedBox(height: 8),
              Text(t.tagline, style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(color: AppColors.muted)),
              const Spacer(flex: 5),
              ElevatedButton(
                onPressed: () => context.go(Routes.login),
                child: Text(t.login),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => context.go(Routes.register),
                child: Text(t.dontHaveAccount),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
```

### Task 7.2: Login

**Files:**
- Create: `lib/features/auth/login_screen.dart`

Screenshot: `7.55.13 PM.jpeg`.

- [ ] **Step 1: Write it**

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../router/routes.dart';
import '../../widgets/app_background.dart';
import '../../widgets/labeled_text_field.dart';
import 'auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _pwd = TextEditingController();
  bool _busy = false;

  @override
  void dispose() { _email.dispose(); _pwd.dispose(); super.dispose(); }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _busy = true);
    final ok = await context.read<AuthProvider>().login(_email.text.trim(), _pwd.text);
    if (mounted) setState(() => _busy = false);
    if (ok && mounted) context.go(Routes.welcome);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Form(
              key: _form,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () => context.go(Routes.splash),
                    icon: const Icon(Icons.chevron_left, size: 32),
                  ),
                  Text(t.login, style: Theme.of(context).textTheme.displayMedium),
                  const SizedBox(height: 60),
                  LabeledTextField(
                    label: t.email, controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) => (v ?? '').contains('@') ? null : t.errorInvalidEmail,
                  ),
                  LabeledTextField(
                    label: t.password, controller: _pwd, obscure: true,
                    validator: (v) => (v ?? '').length >= 6 ? null : t.errorPasswordShort,
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: SizedBox(
                      width: 180,
                      child: ElevatedButton(
                        onPressed: _busy ? null : _submit,
                        child: _busy
                            ? const SizedBox(width: 20, height: 20,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : Text(t.login),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.go(Routes.forgot),
                    child: Text(t.forgotPassword),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
```

### Task 7.3: Register

**Files:**
- Create: `lib/features/auth/register_screen.dart`

Screenshot: `7.55.13 PM (1).jpeg`. Seven fields stacked vertically, scrollable.

- [ ] **Step 1: Write it**

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../router/routes.dart';
import '../../widgets/app_background.dart';
import '../../widgets/labeled_text_field.dart';
import 'auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _country = TextEditingController();
  final _currency = TextEditingController(text: 'USD');
  final _pwd = TextEditingController();
  final _pwd2 = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    for (final c in [_name, _phone, _email, _country, _currency, _pwd, _pwd2]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    final t = AppLocalizations.of(context)!;
    if (_pwd.text != _pwd2.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.errorPasswordsDontMatch)));
      return;
    }
    setState(() => _busy = true);
    final ok = await context.read<AuthProvider>().register(
          name: _name.text.trim(), phone: _phone.text.trim(),
          email: _email.text.trim(), country: _country.text.trim(),
          currency: _currency.text.trim(), password: _pwd.text,
        );
    if (mounted) setState(() => _busy = false);
    if (ok && mounted) context.go(Routes.otp);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    String? req(String? v) => (v == null || v.isEmpty) ? t.errorRequired : null;

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Form(
              key: _form,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () => context.go(Routes.splash),
                    icon: const Icon(Icons.chevron_left, size: 32),
                  ),
                  Text(t.register, style: Theme.of(context).textTheme.displayMedium),
                  const SizedBox(height: 8),
                  LabeledTextField(label: t.fullName, controller: _name, validator: req),
                  LabeledTextField(label: t.phoneNumber, controller: _phone,
                      keyboardType: TextInputType.phone, validator: req),
                  LabeledTextField(label: t.email, controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) => (v ?? '').contains('@') ? null : t.errorInvalidEmail),
                  LabeledTextField(label: t.country, controller: _country, validator: req),
                  LabeledTextField(label: t.currency, controller: _currency, validator: req),
                  LabeledTextField(label: t.password, controller: _pwd, obscure: true,
                      validator: (v) => (v ?? '').length >= 6 ? null : t.errorPasswordShort),
                  LabeledTextField(label: t.confirmPassword, controller: _pwd2, obscure: true,
                      validator: (v) => (v ?? '').length >= 6 ? null : t.errorPasswordShort),
                  Center(
                    child: SizedBox(
                      width: 220,
                      child: ElevatedButton(
                        onPressed: _busy ? null : _submit,
                        child: _busy
                            ? const SizedBox(width: 20, height: 20,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : Text(t.createAccount),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
```

### Task 7.4: OTP / verify-email screen

**Files:**
- Create: `lib/features/auth/otp_screen.dart`

- [ ] **Step 1: Write it**

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/app_background.dart';
import 'auth_provider.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});
  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  bool _busy = false;
  String? _msg;

  Future<void> _check() async {
    setState(() { _busy = true; _msg = null; });
    final ok = await context.read<AuthProvider>().reloadVerified();
    if (mounted) setState(() {
      _busy = false;
      if (!ok) _msg = 'Not verified yet — check your inbox.';
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final email = context.watch<AuthProvider>().state.pendingEmail ?? '';
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(t.verifyEmailTitle,
                    style: Theme.of(context).textTheme.headlineLarge),
                const SizedBox(height: 16),
                Text(t.verifyEmailBody(email), textAlign: TextAlign.center),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _busy ? null : _check,
                  child: Text(t.iVerified),
                ),
                if (_msg != null) Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(_msg!, style: const TextStyle(color: Colors.red)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

### Task 7.5: Forgot password

**Files:**
- Create: `lib/features/auth/forgot_password_screen.dart`

- [ ] **Step 1: Write it**

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../router/routes.dart';
import '../../widgets/app_background.dart';
import '../../widgets/labeled_text_field.dart';
import 'auth_provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _email = TextEditingController();
  bool _busy = false;
  bool _sent = false;

  @override
  void dispose() { _email.dispose(); super.dispose(); }

  Future<void> _send() async {
    setState(() => _busy = true);
    final ok = await context.read<AuthProvider>().resetPassword(_email.text.trim());
    if (mounted) setState(() { _busy = false; _sent = ok; });
    if (ok && mounted) {
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) context.go(Routes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () => context.go(Routes.login),
                  icon: const Icon(Icons.chevron_left, size: 32),
                ),
                Text(t.forgotPassword,
                    style: Theme.of(context).textTheme.displayMedium),
                const SizedBox(height: 32),
                LabeledTextField(label: t.email, controller: _email),
                ElevatedButton(
                  onPressed: _busy ? null : _send,
                  child: Text(t.sendResetEmail),
                ),
                if (_sent) const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text('Email sent. Check your inbox.'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

### Task 7.6: Welcome

**Files:**
- Create: `lib/features/welcome/welcome_screen.dart`

Screenshot: `7.55.13 PM (2).jpeg`. Tap anywhere → home.

- [ ] **Step 1: Write it**

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../l10n/app_localizations.dart';
import '../../router/routes.dart';
import '../../theme/colors.dart';
import '../../widgets/app_background.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      body: GestureDetector(
        onTap: () => context.go(Routes.home),
        behavior: HitTestBehavior.opaque,
        child: AppBackground(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(t.welcomeTitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displayMedium),
                const SizedBox(height: 24),
                Text(t.tapToContinue,
                    style: Theme.of(context).textTheme.bodyMedium
                        ?.copyWith(color: AppColors.muted)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

### Task 7.7: Drawer

**Files:**
- Create: `lib/widgets/section_drawer.dart`

- [ ] **Step 1: Write it**

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../app/locale_provider.dart';
import '../features/auth/auth_provider.dart';
import '../l10n/app_localizations.dart';
import '../router/routes.dart';

class SectionDrawer extends StatelessWidget {
  const SectionDrawer({super.key});
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final lp = context.watch<LocaleProvider>();
    return Drawer(
      child: SafeArea(
        child: ListView(
          children: [
            ListTile(
              title: Text(t.language),
              trailing: Text(lp.locale.languageCode == 'en' ? 'EN' : 'AR'),
              onTap: () => context.read<LocaleProvider>().toggle(),
            ),
            ListTile(
              title: Text(t.support),
              onTap: () { Navigator.pop(context); context.go(Routes.support); },
            ),
            ListTile(
              title: Text(t.logout),
              onTap: () => context.read<AuthProvider>().logout(),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Task 7.8: Home menu

**Files:**
- Create: `lib/features/home/home_screen.dart`

Screenshot: `7.55.13 PM (3).jpeg`. Logo at top, hamburger top-right, four big rounded buttons.

- [ ] **Step 1: Write it**

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../l10n/app_localizations.dart';
import '../../router/routes.dart';
import '../../widgets/app_background.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/menu_button.dart';
import '../../widgets/section_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      endDrawer: const SectionDrawer(),
      body: AppBackground(
        child: SafeArea(
          child: Builder(
            builder: (context) => Column(
              children: [
                Row(
                  children: [
                    const Spacer(),
                    const AppLogo(size: 28),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () => Scaffold.of(context).openEndDrawer(),
                    ),
                  ],
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    children: [
                      MenuButton(label: t.ourWarehouses,
                          onTap: () => context.push(Routes.warehouses)),
                      const SizedBox(height: 22),
                      MenuButton(label: t.howItWorks,
                          onTap: () => context.push(Routes.howItWorks)),
                      const SizedBox(height: 22),
                      MenuButton(label: t.haveAnIssue,
                          onTap: () => context.push(Routes.support)),
                      const SizedBox(height: 22),
                      MenuButton(label: t.lockerLocations,
                          onTap: () => context.push(Routes.lockers)),
                    ],
                  ),
                ),
                const Spacer(flex: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: Commit Phase 7 first half**

```
git add lib/features lib/widgets/section_drawer.dart
git commit -m "feat: splash, login, register, otp, forgot, welcome, home, drawer"
```

---

## Phase 8 — Static data

### Task 8.1: WebsiteRef + Warehouse model

**Files:**
- Create: `lib/data/models/website_ref.dart`
- Create: `lib/data/models/warehouse.dart`

- [ ] **Step 1: Models**

```dart
// website_ref.dart
class WebsiteRef {
  const WebsiteRef(this.label, {this.note});
  final String label;
  final String? note;
}
```

```dart
// warehouse.dart
import 'website_ref.dart';

class Warehouse {
  const Warehouse({
    required this.code,
    required this.displayName,
    required this.bestFor,
    required this.whyBuyHere,
    required this.categoriesHeading,
    required this.categories,
    required this.sites,
  });

  final String code;             // sa eg ae us cn
  final String displayName;
  final String bestFor;
  final List<String> whyBuyHere;
  final String categoriesHeading; // 'Buy from Saudi Arabia'
  final List<String> categories;
  final List<WebsiteRef> sites;
}
```

### Task 8.2: warehouses.dart — content lifted from screenshots

**Files:**
- Create: `lib/data/warehouses.dart`

- [ ] **Step 1: Write it**

```dart
import 'models/warehouse.dart';
import 'models/website_ref.dart';

const warehouses = <Warehouse>[
  Warehouse(
    code: 'sa', displayName: 'Saudi Arabia',
    bestFor: 'Perfumes & Beauty',
    whyBuyHere: [
      'Authentic Arabian & international perfumes',
      'Strong discounts on beauty products',
    ],
    categoriesHeading: 'Buy from Saudi Arabia',
    categories: ['Luxury & Arabic perfumes', 'Makeup & skincare', 'Fashion during sales'],
    sites: [
      WebsiteRef('noon.sa'),
      WebsiteRef('amazon.sa'),
      WebsiteRef('golden-scent.com', note: 'perfumes'),
      WebsiteRef('faces.com', note: 'beauty'),
      WebsiteRef('niceonesa.com', note: 'skincare'),
    ],
  ),
  Warehouse(
    code: 'eg', displayName: 'Egypt',
    bestFor: 'Urgent or Local Purchases',
    whyBuyHere: ['Faster delivery', 'Easier returns & warranty'],
    categoriesHeading: 'Best websites',
    categories: [],
    sites: [
      WebsiteRef('amazon.eg'), WebsiteRef('noon.eg'), WebsiteRef('jumia.com.eg'),
      WebsiteRef('locallyeg.com'), WebsiteRef('gonative.eg'), WebsiteRef('genz-s.com'),
    ],
  ),
  Warehouse(
    code: 'ae', displayName: 'United Arab Emirates',
    bestFor: 'Electronics, Fashion, Perfumes & Beauty',
    whyBuyHere: [
      'Only 5% VAT',
      'Competitive electronics market',
      'Easy shipping to many countries',
    ],
    categoriesHeading: 'Buy from UAE',
    categories: [
      'Smartphones & laptops', 'Designer clothing & shoes',
      'Original perfumes', 'Makeup & skincare',
    ],
    sites: [
      WebsiteRef('noon.com'), WebsiteRef('amazon.ae'),
      WebsiteRef('sharafdg.com', note: 'electronics'),
      WebsiteRef('sephora.ae'), WebsiteRef('namshi.com', note: 'fashion'),
    ],
  ),
  Warehouse(
    code: 'us', displayName: 'USA',
    bestFor: 'Electronics & Clothing',
    whyBuyHere: [
      'Lowest global prices for tech',
      'Huge seasonal discounts (Black Friday, Back-to-School)',
      'Wide availability of global brands',
    ],
    categoriesHeading: 'Buy from USA',
    categories: [
      'Phones & laptops', 'Apple products & gaming consoles',
      'Brand clothing & accessories', 'Watches & gadgets',
    ],
    sites: [
      WebsiteRef('apple.com'), WebsiteRef('walmart.com'),
      WebsiteRef('nike.com / levis.com'), WebsiteRef('sephora.com'),
    ],
  ),
  Warehouse(
    code: 'cn', displayName: 'China',
    bestFor: 'Wholesale & Affordable Goods',
    whyBuyHere: [
      'Lowest manufacturer prices',
      'Wide variety of consumer electronics',
    ],
    categoriesHeading: 'Buy from China',
    categories: ['Smartphones & accessories', 'Home gadgets', 'Tools & wearables'],
    sites: [
      WebsiteRef('aliexpress.com'), WebsiteRef('taobao.com'),
      WebsiteRef('jd.com'), WebsiteRef('tmall.com'),
    ],
  ),
];

Warehouse warehouseByCode(String code) =>
    warehouses.firstWhere((w) => w.code == code);
```

### Task 8.3: Locker model + lockers.dart with stubbed entries

**Files:**
- Create: `lib/data/models/locker.dart`
- Create: `lib/data/lockers.dart`

- [ ] **Step 1: Model**

```dart
import 'package:latlong2/latlong.dart';

enum LockerType { mall, metro, plaza, store }

class Locker {
  const Locker({
    required this.name,
    required this.spot,
    required this.coord,
    this.type = LockerType.mall,
  });
  final String name;
  final String spot;
  final LatLng coord;
  final LockerType type;
}

class CityLockers {
  const CityLockers(this.city, this.lockers);
  final String city;
  final List<Locker> lockers;
}

class CountryLockers {
  const CountryLockers({
    required this.code,
    required this.displayName,
    required this.center,
    required this.zoom,
    required this.cities,
  });
  final String code;
  final String displayName;
  final LatLng center;
  final double zoom;
  final List<CityLockers> cities;
}
```

- [ ] **Step 2: Lockers data — pre-filled where screenshot shows the names; lat/lng best-effort**

```dart
import 'package:latlong2/latlong.dart';
import 'models/locker.dart';

// Coordinates are landmark approximations sourced from public maps.
// Replace city stubs with real CartFly locker locations as supplied.
const _eg = CountryLockers(
  code: 'eg', displayName: '🇪🇬 Egypt',
  center: LatLng(27.0, 30.0), zoom: 5.5,
  cities: [
    CityLockers('Cairo', [
      Locker(name: 'New Cairo', spot: 'Cairo Festival City Mall',
          coord: LatLng(30.0286, 31.4076)),
      Locker(name: 'Nasr City', spot: 'City Stars Mall',
          coord: LatLng(30.0726, 31.3464)),
      Locker(name: 'Downtown', spot: 'Sadat Metro Station',
          coord: LatLng(30.0444, 31.2357), type: LockerType.metro),
    ]),
    CityLockers('Giza', [
      Locker(name: '6th of October', spot: 'Mall of Egypt',
          coord: LatLng(29.9712, 30.9707)),
      Locker(name: 'Sheikh Zayed', spot: 'Arkan Plaza',
          coord: LatLng(30.0501, 30.9728), type: LockerType.plaza),
      Locker(name: 'Dokki', spot: 'Dokki Metro Station',
          coord: LatLng(30.0388, 31.2122), type: LockerType.metro),
    ]),
    CityLockers('Alexandria', [
      Locker(name: 'Smouha', spot: 'Green Plaza Mall',
          coord: LatLng(31.2156, 29.9438)),
      Locker(name: 'San Stefano', spot: 'San Stefano Grand Plaza',
          coord: LatLng(31.2380, 29.9580)),
      Locker(name: 'Raml Station', spot: 'Raml Tram Station',
          coord: LatLng(31.1995, 29.8964), type: LockerType.metro),
    ]),
  ],
);

const _sa = CountryLockers(
  code: 'sa', displayName: '🇸🇦 Saudi Arabia',
  center: LatLng(24.0, 45.0), zoom: 5.0,
  cities: [
    CityLockers('Riyadh', [
      Locker(name: 'King Fahd', spot: 'Kingdom Centre',
          coord: LatLng(24.7115, 46.6747)),
      Locker(name: 'Olaya', spot: 'Riyadh Park Mall',
          coord: LatLng(24.7588, 46.6326)),
    ]),
    CityLockers('Jeddah', [
      Locker(name: 'Corniche', spot: 'Red Sea Mall',
          coord: LatLng(21.6259, 39.0992)),
      Locker(name: 'Tahlia', spot: 'Le Prestige Mall',
          coord: LatLng(21.5724, 39.1407)),
    ]),
    CityLockers('Dammam', [
      Locker(name: 'Khobar', spot: 'Mall of Dhahran',
          coord: LatLng(26.3010, 50.1502)),
      Locker(name: 'Al Olaya', spot: 'City Centre Dammam',
          coord: LatLng(26.4282, 50.0850)),
    ]),
  ],
);

const _ae = CountryLockers(
  code: 'ae', displayName: '🇦🇪 UAE',
  center: LatLng(24.4, 54.5), zoom: 7.0,
  cities: [
    CityLockers('Dubai', [
      Locker(name: 'Downtown', spot: 'Dubai Mall',
          coord: LatLng(25.1972, 55.2796)),
      Locker(name: 'Dubai Marina', spot: 'Marina Mall',
          coord: LatLng(25.0772, 55.1410)),
      Locker(name: 'Mall of the Emirates', spot: 'MoE',
          coord: LatLng(25.1180, 55.2003)),
    ]),
    CityLockers('Abu Dhabi', [
      Locker(name: 'Yas Island', spot: 'Yas Mall',
          coord: LatLng(24.4884, 54.6075)),
      Locker(name: 'Khalifa City', spot: 'Etihad Plaza',
          coord: LatLng(24.4150, 54.5854), type: LockerType.plaza),
      Locker(name: 'Abu Dhabi Mall', spot: 'Abu Dhabi Mall Area',
          coord: LatLng(24.4881, 54.3691)),
    ]),
    CityLockers('Sharjah', [
      Locker(name: 'Al Majaz', spot: 'Al Majaz Waterfront',
          coord: LatLng(25.3300, 55.3870)),
      Locker(name: 'City Centre', spot: 'City Centre Sharjah',
          coord: LatLng(25.3326, 55.4209)),
    ]),
  ],
);

const _us = CountryLockers(
  code: 'us', displayName: '🇺🇸 USA',
  center: LatLng(39.5, -98.0), zoom: 3.5,
  cities: [
    CityLockers('New York', [
      Locker(name: 'Manhattan', spot: 'Hudson Yards',
          coord: LatLng(40.7540, -74.0014)),
    ]),
    CityLockers('Los Angeles', [
      Locker(name: 'Downtown LA', spot: 'The Bloc',
          coord: LatLng(34.0470, -118.2569)),
    ]),
    CityLockers('Miami', [
      Locker(name: 'Brickell', spot: 'Brickell City Centre',
          coord: LatLng(25.7656, -80.1918)),
    ]),
  ],
);

const _cn = CountryLockers(
  code: 'cn', displayName: '🇨🇳 China',
  center: LatLng(34.0, 105.0), zoom: 4.0,
  cities: [
    CityLockers('Beijing', [
      Locker(name: 'Chaoyang', spot: 'Sanlitun',
          coord: LatLng(39.9385, 116.4474)),
      Locker(name: 'Haidian', spot: 'Beijing Railway Station',
          coord: LatLng(39.9027, 116.4280), type: LockerType.metro),
    ]),
    CityLockers('Shanghai', [
      Locker(name: 'Pudong', spot: 'IFC Mall',
          coord: LatLng(31.2384, 121.5008)),
      Locker(name: 'Jing\'an', spot: 'Jing\'an Temple',
          coord: LatLng(31.2247, 121.4456)),
    ]),
    CityLockers('Guangzhou', [
      Locker(name: 'Tianhe', spot: 'TaiKoo Hui',
          coord: LatLng(23.1351, 113.3219)),
      Locker(name: 'Yuexiu', spot: 'Guangzhou East Railway Station',
          coord: LatLng(23.1488, 113.3305), type: LockerType.metro),
    ]),
  ],
);

const countryLockers = <CountryLockers>[_eg, _sa, _ae, _us, _cn];

CountryLockers lockersByCode(String code) =>
    countryLockers.firstWhere((c) => c.code == code);
```

### Task 8.4: How-it-works content

**Files:**
- Create: `lib/data/how_it_works.dart`

- [ ] **Step 1: Write it**

```dart
class HowItWorksPage {
  const HowItWorksPage(this.heading, this.body);
  final String heading;
  final String body;
}

const howItWorksEn = <HowItWorksPage>[
  HowItWorksPage('How CartFly Works',
      '1. Create your account\n'
      'Sign up and set up your CartFly account in seconds. Once you join, '
      "you'll get access to our warehouse addresses in multiple countries "
      'including the UAE, Saudi Arabia, Egypt, USA, and China.\n\n'
      '2. Shop from your favorite websites\n'
      'Choose any online store located in one of our warehouse countries. '
      'For example, you can shop from Sephora UAE, Adidas USA, or any brand '
      'you love. Add the products you want to the cart directly on the '
      "store's website and proceed to the checkout page.\n\n"
      '3. Use the CartFly checkout popup\n'
      'When you reach the checkout page, the CartFly popup will appear with '
      'two options:\n'
      '• Copy Warehouse Address — paste the warehouse address into the '
      'shipping field.\n'
      '• Cart Calculator (optional) — estimate customs, taxes, and delivery '
      'fees based on the number of items and packages.'),
  HowItWorksPage('How CartFly Works',
      '4. Confirm your order\n'
      "After completing the purchase on the store's website, go back to "
      'CartFly and open the Order Confirmation section. Enter your order '
      'number, name, and phone number. Your order will automatically appear '
      'in your account as Pending.\n\n'
      '5. Warehouse arrival & final payment\n'
      'Once your package arrives at our warehouse, you will receive a '
      'notification. We will calculate the exact customs, taxes, and '
      'shipping fees. You can then complete the payment and get your order '
      'delivered to your doorstep.'),
];

const howItWorksAr = <HowItWorksPage>[
  HowItWorksPage('كيف يعمل كارت فلاي',
      '١. أنشئ حسابك\n'
      'سجّل وافتح حسابك في كارت فلاي خلال ثوانٍ. بمجرد انضمامك ستحصل على '
      'عناوين مستودعاتنا في الإمارات والسعودية ومصر وأمريكا والصين.\n\n'
      '٢. تسوّق من مواقعك المفضلة\n'
      'اختر أي متجر موجود في إحدى دول مستودعاتنا، مثل سيفورا الإمارات أو '
      'أديداس أمريكا. أضف المنتجات إلى السلة مباشرة وادخل لصفحة الدفع.\n\n'
      '٣. استخدم نافذة كارت فلاي عند الدفع\n'
      'ستظهر نافذة كارت فلاي بخيارين:\n'
      '• نسخ عنوان المستودع.\n'
      '• حاسبة السلة (اختياري) لتقدير الجمارك والضرائب والشحن.'),
  HowItWorksPage('كيف يعمل كارت فلاي',
      '٤. تأكيد طلبك\n'
      'بعد إتمام الشراء، ارجع إلى كارت فلاي وافتح قسم تأكيد الطلب. أدخل '
      'رقم الطلب والاسم والهاتف، وسيظهر الطلب بحالة "قيد الانتظار".\n\n'
      '٥. وصول المستودع والدفع النهائي\n'
      'عند وصول الشحنة إلى مستودعنا ستصلك رسالة، نحسب الجمارك والشحن '
      'بدقة، ثم تكمل الدفع ويصل الطلب إلى باب بيتك.'),
];
```

- [ ] **Step 2: Commit data**

```
git add lib/data
git commit -m "feat: static data — warehouses, lockers, how-it-works"
```

---

## Phase 9 — Content screens

### Task 9.1: Warehouses grid

**Files:**
- Create: `lib/features/warehouses/warehouses_screen.dart`

Screenshot: `7.55.13 PM (4).jpeg`. 3-column-ish grid of flag + caption, large title.

- [ ] **Step 1: Write it**

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/warehouses.dart';
import '../../l10n/app_localizations.dart';
import '../../router/routes.dart';
import '../../widgets/app_background.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/flag_icon.dart';
import '../../widgets/section_drawer.dart';

class WarehousesScreen extends StatelessWidget {
  const WarehousesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      endDrawer: const SectionDrawer(),
      body: AppBackground(
        child: SafeArea(
          child: Builder(
            builder: (context) => Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left, size: 28),
                      onPressed: () => context.pop(),
                    ),
                    const Spacer(),
                    const AppLogo(size: 24),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () => Scaffold.of(context).openEndDrawer(),
                    ),
                  ],
                ),
                Text(t.ourWarehouses,
                    style: Theme.of(context).textTheme.headlineLarge
                        ?.copyWith(color: Colors.black)),
                const SizedBox(height: 24),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    childAspectRatio: 1.0,
                    children: [
                      for (final w in warehouses)
                        InkWell(
                          onTap: () => context.push('${Routes.warehouses}/${w.code}'),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FlagIcon(code: w.code, size: 120),
                              const SizedBox(height: 8),
                              Text(w.displayName,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyLarge),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

### Task 9.2: Warehouse detail

**Files:**
- Create: `lib/features/warehouses/warehouse_detail_screen.dart`

Screenshots: `7.55.13 PM (5)..(7)`, `7.55.14 PM (1)`. Centered flag, headings, bullet groups, Back button.

- [ ] **Step 1: Write it**

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/warehouses.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/app_background.dart';
import '../../widgets/flag_icon.dart';

class WarehouseDetailScreen extends StatelessWidget {
  const WarehouseDetailScreen({super.key, required this.code});
  final String code;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final w = warehouseByCode(code);
    final isLocal = w.code == 'eg';
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              children: [
                const SizedBox(height: 24),
                FlagIcon(code: w.code, size: 200),
                const SizedBox(height: 24),
                _Heading(t.bestFor(w.bestFor)),
                _Heading(isLocal ? t.whyBuyLocally : t.whyBuyHere),
                ...w.whyBuyHere.map(_bullet),
                const SizedBox(height: 16),
                _Heading(w.categoriesHeading),
                ...w.categories.map(_bullet),
                const SizedBox(height: 16),
                _Heading(t.bestWebsites),
                ...w.sites.map((s) => _bullet(
                    s.note == null ? s.label : '${s.label} (${s.note})')),
                const SizedBox(height: 24),
                SizedBox(
                  width: 220,
                  child: ElevatedButton(
                    onPressed: () => context.pop(),
                    child: Text(t.back),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _bullet(String s) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Text('• $s', textAlign: TextAlign.center),
      );
}

class _Heading extends StatelessWidget {
  const _Heading(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(text,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge),
      );
}
```

### Task 9.3: How it works (two pages)

**Files:**
- Create: `lib/features/how_it_works/how_it_works_screen.dart`

- [ ] **Step 1: Write it**

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/how_it_works.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/app_background.dart';
import '../../widgets/app_logo.dart';

class HowItWorksScreen extends StatefulWidget {
  const HowItWorksScreen({super.key});
  @override
  State<HowItWorksScreen> createState() => _HowItWorksScreenState();
}

class _HowItWorksScreenState extends State<HowItWorksScreen> {
  final _ctrl = PageController();
  int _page = 0;

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final pages = isAr ? howItWorksAr : howItWorksEn;

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Column(
            children: [
              Row(children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left, size: 28),
                  onPressed: () => context.pop(),
                ),
                const Spacer(),
                const AppLogo(size: 24),
                const Spacer(),
                const SizedBox(width: 48),
              ]),
              Expanded(
                child: PageView.builder(
                  controller: _ctrl,
                  itemCount: pages.length,
                  onPageChanged: (i) => setState(() => _page = i),
                  itemBuilder: (_, i) => SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(children: [
                      const SizedBox(height: 16),
                      Text(pages[i].heading,
                          style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 16),
                      Text(pages[i].body, textAlign: TextAlign.center),
                    ]),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: SizedBox(
                  width: 220,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_page < pages.length - 1) {
                        _ctrl.nextPage(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeInOut);
                      } else {
                        context.pop();
                      }
                    },
                    child: Text(_page < pages.length - 1 ? t.next : t.back),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

### Task 9.4: Lockers world list

**Files:**
- Create: `lib/features/lockers/lockers_world_screen.dart`

Screenshot: `7.55.14 PM (4).jpeg`. Title pill, world map image area, country list. We render the map via `flutter_map` zoomed-out with all 5 country centers pinned.

- [ ] **Step 1: Write it**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import '../../data/lockers.dart';
import '../../l10n/app_localizations.dart';
import '../../router/routes.dart';
import '../../theme/colors.dart';
import '../../widgets/app_background.dart';
import '../../widgets/app_logo.dart';

class LockersWorldScreen extends StatelessWidget {
  const LockersWorldScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Column(children: [
            Row(children: [
              IconButton(
                icon: const Icon(Icons.chevron_left, size: 28),
                onPressed: () => context.pop(),
              ),
              const Spacer(), const AppLogo(size: 24),
              const Spacer(), const SizedBox(width: 48),
            ]),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: AppColors.border, width: 1.4),
              ),
              child: Text(t.ourLockerLocations,
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: FlutterMap(
                    options: const MapOptions(
                      initialCenter: LatLng(20, 30),
                      initialZoom: 1.5,
                      interactionOptions: InteractionOptions(
                        flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
                      ),
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.cartfly.app',
                      ),
                      MarkerLayer(markers: [
                        for (final c in countryLockers)
                          Marker(
                            point: c.center, width: 44, height: 44,
                            child: GestureDetector(
                              onTap: () => context.push('${Routes.lockers}/${c.code}'),
                              child: const Icon(Icons.location_on,
                                  color: AppColors.primary, size: 36),
                            ),
                          ),
                      ]),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Wrap(
                spacing: 12, runSpacing: 8, alignment: WrapAlignment.center,
                children: [
                  for (final c in countryLockers)
                    OutlinedButton(
                      onPressed: () => context.push('${Routes.lockers}/${c.code}'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(120, 40),
                      ),
                      child: Text(c.displayName),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: SizedBox(
                width: 220,
                child: ElevatedButton(
                  onPressed: () => context.pop(),
                  child: Text(t.back),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
```

### Task 9.5: Country lockers screen — map + side list

**Files:**
- Create: `lib/features/lockers/country_lockers_screen.dart`

Screenshots: `7.55.14 PM (5)`, `(6)` composites.

- [ ] **Step 1: Write it**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import '../../data/lockers.dart';
import '../../data/models/locker.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/colors.dart';
import '../../widgets/app_background.dart';
import '../../widgets/app_logo.dart';

class CountryLockersScreen extends StatefulWidget {
  const CountryLockersScreen({super.key, required this.code});
  final String code;

  @override
  State<CountryLockersScreen> createState() => _CountryLockersScreenState();
}

class _CountryLockersScreenState extends State<CountryLockersScreen> {
  final _map = MapController();
  final Map<String, GlobalKey> _itemKeys = {};
  String? _highlight;

  String _key(Locker l) => '${l.name}|${l.spot}';

  void _focus(Locker l) {
    setState(() => _highlight = _key(l));
    _map.move(l.coord, 14);
    final k = _itemKeys[_key(l)];
    if (k?.currentContext != null) {
      Scrollable.ensureVisible(k!.currentContext!,
          duration: const Duration(milliseconds: 300), alignment: 0.2);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final c = lockersByCode(widget.code);
    final allLockers = [for (final ct in c.cities) ...ct.lockers];

    final body = Column(children: [
      SizedBox(
        height: 280,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: FlutterMap(
            mapController: _map,
            options: MapOptions(initialCenter: c.center, initialZoom: c.zoom),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.cartfly.app',
              ),
              MarkerLayer(markers: [
                for (final l in allLockers)
                  Marker(
                    point: l.coord, width: 36, height: 36,
                    child: GestureDetector(
                      onTap: () => _focus(l),
                      child: Icon(Icons.location_on,
                          color: _highlight == _key(l)
                              ? AppColors.primary
                              : AppColors.border,
                          size: 32),
                    ),
                  ),
              ]),
            ],
          ),
        ),
      ),
      Expanded(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          children: [
            for (final ct in c.cities) ...[
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 6),
                child: Text(ct.city,
                    style: Theme.of(context).textTheme.titleLarge),
              ),
              for (final l in ct.lockers)
                Container(
                  key: _itemKeys.putIfAbsent(_key(l), () => GlobalKey()),
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: _highlight == _key(l)
                        ? AppColors.bgBlue
                        : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.border, width: 1),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    title: Text('${l.name} – ${l.spot}'),
                    onTap: () => _focus(l),
                  ),
                ),
            ],
          ],
        ),
      ),
    ]);

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Column(children: [
            Row(children: [
              IconButton(
                icon: const Icon(Icons.chevron_left, size: 28),
                onPressed: () => context.pop(),
              ),
              const Spacer(), const AppLogo(size: 24),
              const Spacer(), const SizedBox(width: 48),
            ]),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(c.displayName,
                  style: Theme.of(context).textTheme.headlineLarge),
            ),
            Expanded(child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: body,
            )),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: SizedBox(
                width: 220,
                child: ElevatedButton(
                  onPressed: () => context.pop(),
                  child: Text(t.back),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
```

### Task 9.6: Support screen

**Files:**
- Create: `lib/features/support/support_screen.dart`

- [ ] **Step 1: Write it**

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/app_background.dart';
import '../../widgets/labeled_text_field.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});
  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final _form = GlobalKey<FormState>();
  final _subject = TextEditingController();
  final _msg = TextEditingController();
  bool _busy = false; bool _sent = false;

  @override
  void dispose() { _subject.dispose(); _msg.dispose(); super.dispose(); }

  Future<void> _send() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _busy = true);
    final uid = FirebaseAuth.instance.currentUser?.uid;
    await FirebaseFirestore.instance.collection('support').add({
      'uid': uid,
      'subject': _subject.text.trim(),
      'message': _msg.text.trim(),
      'createdAt': FieldValue.serverTimestamp(),
    });
    if (mounted) setState(() { _busy = false; _sent = true; });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    String? req(String? v) => (v == null || v.isEmpty) ? t.errorRequired : null;

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _form,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left, size: 28),
                    onPressed: () => context.pop(),
                  ),
                  Text(t.support,
                      style: Theme.of(context).textTheme.displayMedium),
                  const SizedBox(height: 16),
                  LabeledTextField(label: t.supportSubject,
                      controller: _subject, validator: req),
                  Text(t.supportMessage,
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _msg, maxLines: 6, validator: req,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: _busy ? null : _send,
                      child: Text(t.send),
                    ),
                  ),
                  if (_sent) const Padding(
                    padding: EdgeInsets.only(top: 12),
                    child: Text('Sent. Thanks!'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: Build the project (everything should now compile)**

Run: `flutter analyze`
Expected: 0 errors. Some `info` lint hints are fine.

Run: `flutter build apk --debug`
Expected: builds successfully.

- [ ] **Step 3: Commit Phase 9**

```
git add lib/features/warehouses lib/features/how_it_works lib/features/lockers lib/features/support
git commit -m "feat: warehouses, how-it-works, lockers, support screens"
```

---

## Phase 10 — Manual smoke + polish

### Task 10.1: Run on Android emulator and verify each screen against its screenshot

**Files:** none — manual.

- [ ] **Step 1: Boot emulator + run**

Run: `flutter run -d emulator-5554`
Expected: app launches at splash.

- [ ] **Step 2: Walk the flow**

For each of these screens, verify it visually matches the corresponding screenshot:

1. Splash → matches `7.55.12 PM`
2. Login → matches `7.55.13 PM`
3. Register → matches `7.55.13 PM (1)`
4. OTP — bespoke design, just verify it sends a Firebase verification email
5. Welcome → matches `7.55.13 PM (2)` after `tap to continue`
6. Home → matches `7.55.13 PM (3)`
7. Warehouses → matches `7.55.13 PM (4)`
8. Saudi detail → matches `7.55.13 PM (5)`
9. USA detail → matches `7.55.13 PM (6)`
10. Egypt detail → matches `7.55.13 PM (7)`
11. UAE detail → matches `7.55.14 PM (1)`
12. How it works (1/2) → matches `7.55.14 PM (2)`
13. How it works (2/2) → matches `7.55.14 PM (3)`
14. Lockers world → matches `7.55.14 PM (4)`
15. Egypt lockers → matches `7.55.14 PM (5)`

For any screen that diverges noticeably, fix on the spot — adjust spacing / font size / asset until it matches.

- [ ] **Step 3: Toggle to AR via drawer**

Verify text flips and direction is RTL on register, warehouses, how-it-works.

- [ ] **Step 4: Commit any tweaks**

```
git add -A
git commit -m "fix: visual polish to match screenshots"
```

### Task 10.2: Web build sanity

**Files:** none — manual.

- [ ] **Step 1: Build web**

Run: `flutter build web`
Expected: builds.

- [ ] **Step 2: Serve and click through**

Run: `flutter run -d chrome`
Expected: app loads. flutter_map tiles render. Auth works.

If anything breaks (e.g. `flutter_map` tile fetch), add `<meta>` referrer policy to `web/index.html`:
```html
<meta name="referrer" content="no-referrer-when-downgrade">
```

- [ ] **Step 3: Commit**

```
git add web
git commit -m "chore: web build verified"
```

---

## Phase 11 — Wrap

### Task 11.1: README

**Files:**
- Modify: `README.md` (replace generated stub)

- [ ] **Step 1: Write README**

```markdown
# CartFly

Cross-border shopping assistant. Flutter app for Android, iOS, Web.

## Stack
Flutter 3.27 / Dart 3.6, Firebase Auth + Firestore, Provider, go_router, flutter_map, intl/ARB.

## Run
1. `flutter pub get`
2. Drop a Firebase config: `flutterfire configure`
3. `flutter run`

## Languages
English and Arabic. Toggle from the drawer.

## Project layout
- `lib/features/<area>` — one folder per screen group
- `lib/data` — static content (warehouses, lockers, how-it-works)
- `lib/widgets` — shared UI
- `lib/theme` — palette, typography, theme builder
- `lib/router` — go_router config + auth redirect
- `lib/l10n` — ARB files
```

- [ ] **Step 2: Commit**

```
git add README.md
git commit -m "docs: project readme"
```

---

## Spec coverage check

| Spec section | Implemented in |
|---|---|
| 1 Stack | Task 1.1 |
| 2 Folder layout | Phases 2–9 |
| 3 Theme | Tasks 2.1–2.3 |
| 4 Screens (14) | Phase 7 + Phase 9 |
| 5 Auth flow | Tasks 4.3–4.4 + 5.2 + 7.1–7.6 |
| 6 Static data | Phase 8 |
| 7 Locker country screen | Task 9.5 |
| 8 Localization | Phase 3 + 7.7 |
| 9 Drawer | Task 7.7 |
| 10 Out of scope | (intentionally not built) |
| 11 Open items | locker stubs filled with placeholders, README notes assets |
| 12 Acceptance | Phase 10 manual checks |

Plan complete.
