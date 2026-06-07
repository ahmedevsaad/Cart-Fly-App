# Stage 4 — Auth Flow

**Goal:** Rebuild splash/login/register/verify/forgot/welcome on the new design system, wired to the existing `AuthProvider`. Real register→verify→home works on the Firebase project.

**Prereq:** Stage 3 complete.

**Files:**
- Create: `lib/features/splash/splash_screen.dart`, `lib/features/auth/login_screen.dart`, `register_screen.dart`, `verify_screen.dart`, `forgot_password_screen.dart`, `lib/features/welcome/welcome_screen.dart`
- Modify: `lib/router/app_router.dart` (register these as top-level routes)
- Reference visuals: `html/screens/{home,login,register,welcome}.html`

> `AuthProvider` already exposes: `register(...)`, `login(email,pw)`, `resetPassword(email)`, `reloadVerified()`, `logout()`, `state.status`, `errorKey`. Screens only call these.

---

### Task 4.1: Register auth routes

**Files:** Modify `lib/router/app_router.dart` — add these **top-level** `GoRoute`s (siblings of the shell, before it):

```dart
GoRoute(path: Routes.splash, builder: (_, __) => const SplashScreen()),
GoRoute(path: Routes.login, builder: (_, __) => const LoginScreen()),
GoRoute(path: Routes.register, builder: (_, __) => const RegisterScreen()),
GoRoute(path: Routes.verify, builder: (_, __) => const VerifyScreen()),
GoRoute(path: Routes.forgot, builder: (_, __) => const ForgotPasswordScreen()),
GoRoute(path: Routes.welcome, builder: (_, __) => const WelcomeScreen()),
```
(with the matching imports).

- [ ] Add routes + imports. `flutter analyze` (will fail until screens exist — proceed to create them, then re-analyze). Commit after Task 4.6.

### Task 4.2: Splash

**Files:** `lib/features/splash/splash_screen.dart`

- [ ] **Step 1:** Solid `bgSplash` background, centered "CartFly" `AppText.display` + "from cart to doorstep" caption. The router redirect moves off `/` automatically once `AuthProvider` resolves `loading→authenticated/unauthenticated`. Use `CfScaffold(solidBackground: AppColors.bgSplash, body: ...)`.

```dart
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/cf_scaffold.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) => CfScaffold(
        solidBackground: AppColors.bgSplash,
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text('CartFly', style: AppText.display),
            Text('from cart to doorstep', style: AppText.caption),
          ]),
        ),
      );
}
```

### Task 4.3: Login (full reference for the auth-screen pattern)

**Files:** `lib/features/auth/login_screen.dart`

- [ ] **Step 1: Implement** — stateful, two `CfInput`s, `CfButton` login, "Forget password?" → `/forgot`, "Don't have an account" → `/register`. On login success the router redirect sends to `/home`.

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../router/routes.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/cf_button.dart';
import '../../widgets/cf_input.dart';
import '../../widgets/cf_scaffold.dart';
import 'auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _busy = false;
  String? _error;

  @override
  void dispose() { _email.dispose(); _password.dispose(); super.dispose(); }

  Future<void> _submit() async {
    setState(() { _busy = true; _error = null; });
    final auth = context.read<AuthProvider>();
    final ok = await auth.login(_email.text.trim(), _password.text);
    if (!mounted) return;
    setState(() { _busy = false; if (!ok) _error = auth.errorKey; });
    // success → router redirect navigates to /home automatically
  }

  @override
  Widget build(BuildContext context) {
    return CfScaffold(
      solidBackground: AppColors.bgSplash,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: ListView(children: [
          const SizedBox(height: 40),
          Center(child: Text('CartFly', style: AppText.display)),
          Center(child: Text('from cart to doorstep', style: AppText.caption)),
          const SizedBox(height: 30),
          Center(child: Text('Login', style: AppText.title)),
          const SizedBox(height: 24),
          CfInput(label: 'Email:', controller: _email,
              keyboardType: TextInputType.emailAddress),
          CfInput(label: 'Password:', controller: _password, obscure: true),
          TextButton(
            onPressed: () => context.push(Routes.forgot),
            child: const Text('Forget password?'),
          ),
          if (_error != null)
            Text(_error!, style: AppText.caption.copyWith(color: AppColors.danger)),
          const SizedBox(height: 8),
          CfButton(label: _busy ? '...' : 'Login', onPressed: _busy ? null : _submit),
          const SizedBox(height: 24),
          CfOutlineButton(
            label: "Don't have an account",
            onPressed: () => context.push(Routes.register),
          ),
        ]),
      ),
    );
  }
}
```

> Error display: `auth.errorKey` is an i18n key like `errorAuth_wrong-password`. For now show the raw key; Stage 8/9 maps keys to localized text. (Acceptable interim per university scope — note it.)

### Task 4.4: Register

**Files:** `lib/features/auth/register_screen.dart`

- [ ] **Step 1:** Same pattern as Login. Fields: Full name, Phone number, Email, Country (dropdown: Saudi Arabia/Egypt/UAE/USA/China), Currency (dropdown: USD/SAR/AED/EGP/CNY), Password, Confirm password. Validate password==confirm and non-empty. On submit call:

```dart
final ok = await context.read<AuthProvider>().register(
  name: _name.text.trim(), phone: _phone.text.trim(), email: _email.text.trim(),
  country: _country, currency: _currency, password: _password.text);
// ok → AuthProvider sets status=pendingOtp → router redirects to /verify
```
"Back" chevron via `CfTopBar`. Reference `html/screens/register.html`.

### Task 4.5: Verify-email & Forgot-password

**Files:** `lib/features/auth/verify_screen.dart`, `forgot_password_screen.dart`

- [ ] **Step 1: VerifyScreen** — explains "We sent a verification link to {email}. Tap continue after verifying." A `CfButton('I have verified')` calls `await context.read<AuthProvider>().reloadVerified()`; if false, show "Not verified yet." A `TextButton('Resend')` calls `FirebaseAuth.instance.currentUser?.sendEmailVerification()` (import firebase_auth). On success the redirect goes to `/home`.

- [ ] **Step 2: ForgotPasswordScreen** — one `CfInput('Email:')` + `CfButton('Send reset link')` → `resetPassword(email)`; show a confirmation `SnackBar` and `context.pop()` back to login.

### Task 4.6: Welcome

**Files:** `lib/features/welcome/welcome_screen.dart`

- [ ] **Step 1:** Shown after first sign-in (optional onboarding). Hero text + `CfButton('Tap to create shipment')` → `context.go(Routes.home)`. (Reachable from login flow or skip directly to home — keep simple: after login the redirect lands on `/home`; Welcome is reachable via a one-time entry, or wire login success to `context.push(Routes.welcome)` then welcome → home. Pick: **login → /home directly; Welcome is shown only right after first register/verify.** Implement Welcome as a normal route reachable from Verify's success if desired.)

- [ ] **Step 2: Analyze + commit** — `git commit -m "feat(stage4): auth screens wired to AuthProvider"`.

### Task 4.7: End-to-end auth test (manual, real Firebase)

- [ ] Run `flutter run -d chrome` (no bypass).
- [ ] Register a new test email → app moves to Verify screen; a verification email arrives.
- [ ] Click the email link, return, tap "I have verified" → app lands on `/home` with the bottom bar.
- [ ] Sign out (Profile/Settings sign-out exists from Stage 8; until then call `logout()` from a temp button or verify via login) → returns to `/login`.
- [ ] Login with the verified account → `/home`.
- [ ] Forgot password → reset email arrives.

---

## Stage exit check
- `flutter analyze` → No issues found.
- Real register→verify→home and login work against `cartfly-4382a`.
- Auth redirect keeps unauthenticated users out of the shell.
