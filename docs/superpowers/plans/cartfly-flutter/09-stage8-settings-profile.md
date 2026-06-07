# Stage 8 — Settings, Profile & Info Pages

**Goal:** Fill the Settings and Profile tabs and the Menu tab; wire language + currency persistence, edit-profile, change-password, sign-out, and the static info pages (about/policy/how-it-works/support).

**Prereq:** Stage 7 complete.

**Files:**
- Modify: `lib/features/settings/settings_screen.dart`, `lib/features/profile/profile_screen.dart`, `lib/features/menu/menu_screen.dart`
- Create: `lib/features/settings/language_screen.dart`, `currency_screen.dart`
- Create: `lib/features/profile/edit_profile_screen.dart`, `change_password_screen.dart`
- Create: `lib/features/info/about_screen.dart`, `policy_screen.dart`, `how_it_works_screen.dart`, `lib/features/support/support_screen.dart`
- Modify: `lib/router/app_router.dart` (routes), `lib/features/auth/auth_provider.dart` (changePassword)
- Reuse: `data/how_it_works.dart`
- Reference visuals: `html/screens/{settings,settings-language,settings-currency,my-profile,menu,about-us,policy,have-an-issue}.html`

---

### Task 8.1: Settings routes

**Files:** Modify `lib/router/app_router.dart` — add:

```dart
GoRoute(path: Routes.settingsLanguage, builder: (_, __) => const LanguageScreen()),
GoRoute(path: Routes.settingsCurrency, builder: (_, __) => const CurrencyScreen()),
GoRoute(path: Routes.editProfile, builder: (_, __) => const EditProfileScreen()),
GoRoute(path: Routes.changePassword, builder: (_, __) => const ChangePasswordScreen()),
GoRoute(path: Routes.about, builder: (_, __) => const AboutScreen()),
GoRoute(path: Routes.policy, builder: (_, __) => const PolicyScreen()),
GoRoute(path: Routes.howItWorks, builder: (_, __) => const HowItWorksScreen()),
GoRoute(path: Routes.support, builder: (_, __) => const SupportScreen()),
```

### Task 8.2: Settings tab

**Files:** `lib/features/settings/settings_screen.dart`

- [ ] **Step 1:** Sections of `CfListRow`s (per `html/screens/settings.html`):
  - **Account:** Saved addresses (disabled), Edit profiles → `Routes.editProfile`, Change password → `Routes.changePassword`.
  - **App Preferences:** Languages → `Routes.settingsLanguage`, Currency → `Routes.settingsCurrency`, Notification settings (disabled).
  - **Support & Help:** Help center (disabled), Have an issue → `Routes.support`, Report a problem → `Routes.support`.
  - About us → `Routes.about`, Policy → `Routes.policy`.
  - `CfButton('Sign out')` (danger color) → `await context.read<AuthProvider>().logout()` (redirect sends to `/login`).
- [ ] **Step 2: Analyze + commit.**

### Task 8.3: Language screen

**Files:** `lib/features/settings/language_screen.dart`

- [ ] **Step 1:** Two options — "English" / "العربية". On tap, `context.read<SettingsProvider>().setLocale(Locale('en'|'ar'))`; the app rebuilds in the new locale and direction (RTL handled by Flutter `Directionality`). Show a check on the active locale.
- [ ] **Step 2: Manual** — switch to Arabic → UI flips to RTL; relaunch app → choice persisted (shared_preferences). Commit.

### Task 8.4: Currency screen

**Files:** `lib/features/settings/currency_screen.dart`

- [ ] **Step 1:** Options USD/SAR/AED/EGP/CNY. On tap: `context.read<SettingsProvider>().setCurrency(code)` AND, if authenticated, persist to Firestore via `UserRepository(uid).setCurrency(code)` then `AuthProvider.refreshProfile()`. Show a check on the active currency.
- [ ] **Step 2: Analyze + commit.**

### Task 8.5: Profile tab + edit profile

**Files:** `lib/features/profile/profile_screen.dart`, `edit_profile_screen.dart`

- [ ] **Step 1: ProfileScreen** — read `context.watch<AuthProvider>().state.user`; show name, phone, email, country, **plan** (or "No plan"). `CfListRow('Edit profile')` → `Routes.editProfile`; `CfListRow('Change password')` → `Routes.changePassword`; `CfButton('Sign out')` → `logout()`.
- [ ] **Step 2: EditProfileScreen** — pre-filled `CfInput`s for name/phone + country dropdown. `CfButton('Save')` → `UserRepository(uid).updateProfile(...)` then `AuthProvider.refreshProfile()` then `context.pop()`.
- [ ] **Step 3: Analyze + commit.**

### Task 8.6: Change password

**Files:** `lib/features/auth/auth_provider.dart` (add method), `lib/features/profile/change_password_screen.dart`

- [ ] **Step 1: Add to AuthProvider** (reauth + update; falls back to a clear error if recent-login is required):

```dart
Future<bool> changePassword(String currentPassword, String newPassword) async {
  final u = _auth.currentUser;
  if (u == null || u.email == null) return false;
  try {
    final cred = EmailAuthProvider.credential(
        email: u.email!, password: currentPassword);
    await u.reauthenticateWithCredential(cred);
    await u.updatePassword(newPassword);
    return true;
  } on FirebaseAuthException catch (e) {
    _fail('errorAuth_${e.code}');
    return false;
  }
}
```
(Import `EmailAuthProvider` from `firebase_auth`.)

- [ ] **Step 2: ChangePasswordScreen** — `CfInput('Current password', obscure)`, `CfInput('New password', obscure)`, `CfInput('Confirm new password', obscure)`. Validate new==confirm. `CfButton('Update')` → `changePassword(...)`; on success `SnackBar('Password updated')` + `pop()`; on failure show `auth.errorKey`.
- [ ] **Step 3: Analyze + commit.**

### Task 8.7: Menu tab

**Files:** `lib/features/menu/menu_screen.dart`

- [ ] **Step 1:** "Shipping method" hub (per `html/screens/menu.html`): `CfCard`/`CfButton` "Lockers" → `Routes.lockers`, "Home Delivery" → `Routes.warehouses`; plus `CfListRow('How it works')` → `Routes.howItWorks`.
- [ ] **Step 2: Analyze + commit.**

### Task 8.8: Info pages

**Files:** `about_screen.dart`, `policy_screen.dart`, `how_it_works_screen.dart`, `support/support_screen.dart`

- [ ] **Step 1: AboutScreen / PolicyScreen** — static text (copy from `html/screens/about-us.html`, `policy.html`) in a scroll view, `CfTopBar` back.
- [ ] **Step 2: HowItWorksScreen** — render `data/how_it_works.dart` steps for the current locale.
- [ ] **Step 3: SupportScreen ("Have an issue")** — a simple form (`CfInput('Subject')`, multiline `CfInput('Describe the issue')`, `CfButton('Submit')`) that writes to `users/{uid}/issues` OR just shows a `SnackBar('Thanks, we'll get back to you')` (university scope — pick the SnackBar, no backend).
- [ ] **Step 4: Analyze + commit** — `git commit -m "feat(stage8): settings, profile, menu, info pages"`.

---

## Stage exit check
- `flutter analyze` → No issues found.
- Language switch persists and flips RTL; currency persists to Firestore.
- Edit profile + change password work against Firebase.
- Sign out returns to login; Profile shows the live plan/currency.
- About/Policy/How-it-works/Support render.
