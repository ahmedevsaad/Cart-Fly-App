# Stage 9 — Polish & Acceptance

**Goal:** Tidy states, localize error keys, RTL pass, remove dev scaffolding, and run the full acceptance checklist.

**Prereq:** Stage 8 complete.

**Files:**
- Modify: assorted screens (loading/empty/error states), `lib/l10n/app_en.arb` + `app_ar.arb` (new strings + auth error map), helper `lib/l10n/auth_error.dart`
- Delete: `lib/features/dev/gallery_screen.dart`, `lib/app/locale_provider.dart` (superseded)
- Reference: every `html/screens/*.html` for final visual parity

---

### Task 9.1: Localize auth error keys

**Files:** Create `lib/l10n/auth_error.dart`; extend ARB files.

- [ ] **Step 1:** Map `AuthProvider.errorKey` (e.g. `errorAuth_wrong-password`) to friendly text. Add a small resolver:

```dart
String authErrorText(String? key) {
  switch (key) {
    case 'errorAuth_invalid-email': return 'That email looks invalid.';
    case 'errorAuth_user-not-found':
    case 'errorAuth_wrong-password':
    case 'errorAuth_invalid-credential': return 'Wrong email or password.';
    case 'errorAuth_email-already-in-use': return 'That email is already registered.';
    case 'errorAuth_weak-password': return 'Password is too weak (min 6 chars).';
    case 'errorAuth_requires-recent-login': return 'Please sign in again to change your password.';
    case null: return '';
    default: return 'Something went wrong. Please try again.';
  }
}
```

- [ ] **Step 2:** Replace every raw `auth.errorKey` display (login/register/verify/change-password) with `authErrorText(auth.errorKey)`. Analyze + commit.

### Task 9.2: Loading / empty / error states pass

- [ ] **Step 1:** Audit Firestore-driven screens (orders list, order detail, track, profile): while data is null/loading show `CfLoading`; empty → `CfEmptyState`; on a thrown stream error → `CfErrorState(onRetry:)`. Profile: if `state.user == null` show `CfLoading`.
- [ ] **Step 2:** Disable buttons during async actions (login/register/create/subscribe already gate with a `_busy` flag — verify each does). Analyze + commit.

### Task 9.3: RTL pass

- [ ] **Step 1:** Switch language to Arabic and walk every screen group: auth, home, warehouses, lockers, shipments, plans/payment, settings/profile. Fix any hard-coded `EdgeInsets.only(left:)`/`Alignment` that breaks in RTL — prefer `EdgeInsetsDirectional` and `Align(Alignment.centerStart)`.
- [ ] **Step 2:** Ensure the bottom bar, back chevron, and timelines mirror correctly. Commit fixes.

### Task 9.4: Remove dev scaffolding

- [ ] **Step 1:** Delete `lib/features/dev/gallery_screen.dart` and any temp `home:` reference. Delete `lib/app/locale_provider.dart` (superseded by `SettingsProvider`) and remove its imports. `flutter analyze` → No issues found. Commit.

### Task 9.5: Full acceptance run (manual)

Run `flutter run -d chrome` (and once on an Android emulator):

- [ ] Register → verification email → "I have verified" → **/home**.
- [ ] Bottom bar: tap all 4 tabs — **active tab highlights**, each tab preserves its own state/scroll; bar persists.
- [ ] Home → Create shipment → fill form → **shipment persists** (visible after hot restart) → Track → Advance status updates the timeline live.
- [ ] Home → Warehouses → a country detail; Home → Lockers → country map with pins.
- [ ] Plans → Prime → card form → **success** → Firestore `users/{uid}.plan == 'prime'`; Profile shows the plan.
- [ ] Plans → invalid card → **error** → Try again returns to form.
- [ ] Settings → Language → Arabic → **RTL**; relaunch → persisted. Currency → SAR → persisted to Firestore.
- [ ] Profile → Edit profile (save) and Change password (reauth) work.
- [ ] Sign out → **/login**; log back in → /home.
- [ ] `flutter analyze` → No issues found. `flutter test` → all pass.
- [ ] `flutter build apk --debug` and `flutter build web` both succeed.

- [ ] **Commit** — `git commit -m "chore(stage9): polish, RTL, states, remove dev scaffolding"`.

---

## Stage exit check (= project acceptance, from spec §11)
- Register→verify→home on real Firebase ✔
- Create-shipment persists & tracks ✔
- Subscribe sets `user.plan` ✔
- Language/currency persist ✔
- Dynamic bottom bar highlights active tab & persists across tabs ✔
- Builds for Android + Web ✔
- `flutter analyze` clean, `flutter test` green ✔
