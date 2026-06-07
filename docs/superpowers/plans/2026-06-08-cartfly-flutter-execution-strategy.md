# CartFly Flutter — Execution Strategy Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Execute the 10-stage CartFly Flutter UI rebuild with a three-check gate (flutter analyze + flutter test + flutter drive -d chrome) and manual user review before advancing each stage.

**Architecture:** A one-time test infrastructure setup precedes Stage 0. Each stage then follows: implement per the existing stage plan file → `flutter analyze` → `flutter test` → `flutter drive -d chrome` → user reviews → commit → next stage. Integration tests connect to Firebase Auth (port 9099) and Firestore (port 8080) emulators running locally. Stages 0–3 compile with `--dart-define=DEBUG_BYPASS_AUTH=true`; Stages 4–9 use the emulators for real auth flows.

**Tech Stack:** Flutter ≥3.4, Dart 3.4+, provider, go_router, firebase_core/auth/firestore, integration_test (Flutter SDK), fake_cloud_firestore ^3.0.0 (dev), Firebase emulators (auth:9099, firestore:8080)

**Source spec:** `docs/superpowers/specs/2026-06-08-cartfly-flutter-execution-strategy-design.md`
**Stage plans:** `docs/superpowers/plans/cartfly-flutter/` (00-overview through 10-stage9)

---

## Pre-Flight Check

- [ ] Verify Firebase CLI is installed: `firebase --version` → ≥13.
  If missing: `npm install -g firebase-tools && firebase login`
- [ ] Verify Flutter: `flutter --version` → ≥3.4
- [ ] Confirm `firebase.json` has the `emulators` block (added in Task 0)

---

## Task 0: Test Infrastructure Setup

**Files:**
- Modify: `pubspec.yaml`
- Modify: `firebase.json`
- Create: `test_driver/integration_test.dart`
- Create: `integration_test/test_helpers.dart`

### Step 0.1: Add dev dependencies to pubspec.yaml

- [ ] Open `pubspec.yaml`. Under `dev_dependencies`, add:

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
  integration_test:
    sdk: flutter
  fake_cloud_firestore: ^3.0.0
```

Also bump `country_flags` in `dependencies` (required by Stage 2 plan):

```yaml
  country_flags: ^4.0.0
```

Run: `flutter pub get`
Expected: Resolves without errors.

### Step 0.2: Add emulators block to firebase.json

- [ ] Open `firebase.json` and replace its contents with:

```json
{
  "flutter": {
    "platforms": {
      "android": {
        "default": {
          "projectId": "cartfly-4382a",
          "appId": "1:922941791257:android:076962cc031c91b3209e88",
          "fileOutput": "android/app/google-services.json"
        }
      },
      "dart": {
        "lib/firebase_options.dart": {
          "projectId": "cartfly-4382a",
          "configurations": {
            "android": "1:922941791257:android:076962cc031c91b3209e88",
            "ios": "1:922941791257:ios:83e65469a560effb209e88",
            "web": "1:922941791257:web:6fd1eff4e5e29115209e88"
          }
        }
      }
    }
  },
  "emulators": {
    "auth": { "port": 9099 },
    "firestore": { "port": 8080 },
    "ui": { "enabled": true, "port": 4000 }
  }
}
```

### Step 0.3: Create integration test driver shim

- [ ] Create `test_driver/integration_test.dart`:

```dart
import 'package:integration_test/integration_test_driver.dart';
Future<void> main() => integrationDriver();
```

### Step 0.4: Create shared test helper

- [ ] Create `integration_test/test_helpers.dart`:

```dart
import 'dart:convert';
// dart:html is available on Flutter Web (Chrome target).
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:cartfly/firebase_options.dart';

const _projectId = 'cartfly-4382a';

/// Call in setUpAll of every integration test before pumping any widget.
Future<void> initTestFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
}

/// Wipes all emulator accounts and Firestore documents. Call in tearDownAll.
Future<void> clearEmulatorData() async {
  try {
    await html.HttpRequest.request(
      'http://localhost:9099/emulator/v1/projects/$_projectId/accounts',
      method: 'DELETE',
    );
  } catch (_) {}
  try {
    await html.HttpRequest.request(
      'http://localhost:8080/emulator/v1/projects/$_projectId/databases/(default)/documents',
      method: 'DELETE',
    );
  } catch (_) {}
}

/// Creates a user in the emulator, marks their email as verified, signs out,
/// and returns their uid. Safe to call multiple times with different emails.
Future<String> createVerifiedUser({
  required String email,
  required String password,
}) async {
  final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
    email: email,
    password: password,
  );
  final uid = cred.user!.uid;
  // Use the emulator admin REST API to set emailVerified without an email link.
  await html.HttpRequest.request(
    'http://localhost:9099/identitytoolkit.googleapis.com/v1/projects/$_projectId/accounts:update',
    method: 'POST',
    requestHeaders: {'Content-Type': 'application/json'},
    sendData: jsonEncode({'localId': uid, 'emailVerified': true}),
  );
  await FirebaseAuth.instance.signOut();
  return uid;
}

/// Signs in an existing emulator user. Use after [createVerifiedUser].
Future<void> signInUser(String email, String password) async {
  await FirebaseAuth.instance.signInWithEmailAndPassword(
    email: email,
    password: password,
  );
}

/// Marks the currently signed-in user's email as verified in the emulator.
/// Call after registering via the UI (when you have the uid from currentUser).
Future<void> verifyCurrentUser() async {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) return;
  await html.HttpRequest.request(
    'http://localhost:9099/identitytoolkit.googleapis.com/v1/projects/$_projectId/accounts:update',
    method: 'POST',
    requestHeaders: {'Content-Type': 'application/json'},
    sendData: jsonEncode({'localId': uid, 'emailVerified': true}),
  );
}
```

### Step 0.5: Verify emulator starts

- [ ] Run: `firebase emulators:start --only auth,firestore`
Expected: "All emulators ready!" — auth on 9099, Firestore on 8080, UI on 4000.
Stop with Ctrl+C. You will start it again before each stage gate.

### Step 0.6: Commit

- [ ] `git add -A && git commit -m "chore: test infrastructure (integration_test, firebase emulators)"`

---

## Task 1: Stage 0 — Teardown

**Implementation plan:** `docs/superpowers/plans/cartfly-flutter/01-stage0-teardown.md`

**New file:** `integration_test/stage0_test.dart`

### Step 1.1: Implement Stage 0

- [ ] Complete every task in `docs/superpowers/plans/cartfly-flutter/01-stage0-teardown.md`.

Run: `flutter analyze`
Expected: **No issues found.**

### Step 1.2: Write Stage 0 integration test

- [ ] Create `integration_test/stage0_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:cartfly/app.dart';

import 'test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(initTestFirebase);
  tearDownAll(clearEmulatorData);

  testWidgets('stage0: app launches and shows placeholder text', (tester) async {
    await tester.pumpWidget(const CartFlyApp());
    await tester.pumpAndSettle(const Duration(seconds: 3));
    expect(find.text('CartFly — rebuilding'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
```

### Step 1.3: Run Stage 0 gate

- [ ] Terminal 1: `firebase emulators:start --only auth,firestore`
- [ ] Terminal 2:

```bash
flutter drive \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/stage0_test.dart \
  -d chrome
```

Expected: 1 test PASS.

- [ ] `── REVIEW GATE ──` Run `flutter run -d chrome`. Confirm white screen reading "CartFly — rebuilding". Firebase initializes in the console without error. Report any issues before proceeding.

### Step 1.4: Commit

- [ ] `git add -A && git commit -m "feat(stage0): complete — placeholder screen, gate passes"`

---

## Task 2: Stage 1 — Design System

**Implementation plan:** `docs/superpowers/plans/cartfly-flutter/02-stage1-design-system.md`

**New file:** `integration_test/stage1_test.dart`

### Step 2.1: Implement Stage 1

- [ ] Complete every task in `docs/superpowers/plans/cartfly-flutter/02-stage1-design-system.md`.

Run: `flutter analyze`
Expected: **No issues found.**

### Step 2.2: Write Stage 1 integration test

- [ ] Create `integration_test/stage1_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:cartfly/app.dart';
import 'package:cartfly/theme/app_colors.dart';

import 'test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(initTestFirebase);
  tearDownAll(clearEmulatorData);

  testWidgets('stage1: smoke screen renders design tokens', (tester) async {
    await tester.pumpWidget(const CartFlyApp());
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Display text present
    expect(find.text('CartFly'), findsOneWidget);
    // Caption present
    expect(find.text('from cart to doorstep'), findsOneWidget);
    // Login ElevatedButton rendered
    expect(find.widgetWithText(ElevatedButton, 'Login'), findsOneWidget);
    // Scaffold background colour matches bgSplash token
    final scaffold = tester.widget<Scaffold>(find.byType(Scaffold).first);
    expect(scaffold.backgroundColor, AppColors.bgSplash);
    // No uncaught exceptions
    expect(tester.takeException(), isNull);
  });
}
```

### Step 2.3: Run Stage 1 gate

- [ ] Terminal 1: `firebase emulators:start --only auth,firestore`
- [ ] Terminal 2:

```bash
flutter drive \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/stage1_test.dart \
  -d chrome
```

Expected: 1 test PASS.

- [ ] `── REVIEW GATE ──` Run `flutter run -d chrome`. Confirm: blue (`#c5e2ff`) background, Playfair Display "CartFly" wordmark, muted caption, `#86a6ea` pill Login button. Compare to `html/screens/home.html`.

### Step 2.4: Commit

- [ ] `git add -A && git commit -m "feat(stage1): complete — design tokens + assets, gate passes"`

---

## Task 3: Stage 2 — Component Library

**Implementation plan:** `docs/superpowers/plans/cartfly-flutter/03-stage2-components.md`

**New file:** `integration_test/stage2_test.dart`

### Step 3.1: Implement Stage 2

- [ ] Complete every task in `docs/superpowers/plans/cartfly-flutter/03-stage2-components.md`.

Run: `flutter test` → CfButton + CfInput widget tests PASS.
Run: `flutter analyze` → **No issues found.**

### Step 3.2: Write Stage 2 integration test

- [ ] Create `integration_test/stage2_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:cartfly/app.dart';
import 'package:cartfly/widgets/cf_button.dart';
import 'package:cartfly/widgets/cf_card.dart';
import 'package:cartfly/widgets/cf_input.dart';
import 'package:cartfly/widgets/cf_states.dart';
import 'package:cartfly/widgets/cf_status_timeline.dart';

import 'test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(initTestFirebase);
  tearDownAll(clearEmulatorData);

  testWidgets('stage2: gallery renders all Cf* widgets', (tester) async {
    await tester.pumpWidget(const CartFlyApp());
    await tester.pumpAndSettle(const Duration(seconds: 3));

    expect(find.byType(CfButton), findsWidgets);
    expect(find.byType(CfOutlineButton), findsWidgets);
    expect(find.byType(CfInput), findsWidgets);
    expect(find.byType(CfCard), findsWidgets);
    expect(find.byType(CfStatusTimeline), findsOneWidget);
    expect(find.byType(CfEmptyState), findsOneWidget);
    expect(find.byType(CfErrorState), findsOneWidget);
    // No render overflow
    expect(tester.takeException(), isNull);
  });

  testWidgets('stage2: CfButton tap fires without exception', (tester) async {
    await tester.pumpWidget(const CartFlyApp());
    await tester.pumpAndSettle(const Duration(seconds: 3));

    await tester.tap(find.byType(CfButton).first);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
```

### Step 3.3: Run Stage 2 gate

- [ ] Terminal 1: `firebase emulators:start --only auth,firestore`
- [ ] Terminal 2:

```bash
flutter drive \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/stage2_test.dart \
  -d chrome
```

Expected: 2 tests PASS.

- [ ] `── REVIEW GATE ──` Run `flutter run -d chrome`. Gallery shows all widgets. Compare to `html/components.html` and `html/screens/login.html`. No visible overflow.

### Step 3.4: Commit

- [ ] `git add -A && git commit -m "feat(stage2): complete — Cf* component library, gate passes"`

---

## Task 4: Stage 3 — Navigation Shell

**Implementation plan:** `docs/superpowers/plans/cartfly-flutter/04-stage3-shell.md`

**New file:** `integration_test/stage3_test.dart`

### Step 4.1: Implement Stage 3

- [ ] Complete every task in `docs/superpowers/plans/cartfly-flutter/04-stage3-shell.md`.

Run: `flutter analyze` → **No issues found.**

### Step 4.2: Write Stage 3 integration test

- [ ] Create `integration_test/stage3_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:cartfly/app.dart';
import 'package:cartfly/widgets/cf_bottom_nav.dart';

import 'test_helpers.dart';

// Compiled with --dart-define=DEBUG_BYPASS_AUTH=true — router bypasses auth.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(initTestFirebase);
  tearDownAll(clearEmulatorData);

  testWidgets('stage3: shell renders 4-tab bottom bar', (tester) async {
    await tester.pumpWidget(const CartFlyApp());
    await tester.pumpAndSettle(const Duration(seconds: 3));

    expect(find.byType(CfBottomNav), findsOneWidget);
    // "Home" label in the nav bar
    expect(
      find.descendant(of: find.byType(CfBottomNav), matching: find.text('Home')),
      findsOneWidget,
    );
    // "Settings" label in the nav bar
    expect(
      find.descendant(of: find.byType(CfBottomNav), matching: find.text('Settings')),
      findsOneWidget,
    );
  });

  testWidgets('stage3: tapping Settings nav item switches body', (tester) async {
    await tester.pumpWidget(const CartFlyApp());
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Tap the "Settings" label inside CfBottomNav
    final settingsInNav = find.descendant(
      of: find.byType(CfBottomNav),
      matching: find.text('Settings'),
    );
    await tester.tap(settingsInNav);
    await tester.pumpAndSettle();

    // Placeholder settings tab body shows "Settings"
    expect(find.text('Settings'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('stage3: tab state preserved when switching back', (tester) async {
    await tester.pumpWidget(const CartFlyApp());
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Go to Settings
    await tester.tap(find.descendant(
      of: find.byType(CfBottomNav),
      matching: find.text('Settings'),
    ));
    await tester.pumpAndSettle();

    // Go back to Home
    await tester.tap(find.descendant(
      of: find.byType(CfBottomNav),
      matching: find.text('Home'),
    ));
    await tester.pumpAndSettle();

    // Home placeholder body still present
    expect(find.text('Home'), findsWidgets);
    expect(tester.takeException(), isNull);
  });
}
```

### Step 4.3: Run Stage 3 gate

- [ ] Terminal 1: `firebase emulators:start --only auth,firestore`
- [ ] Terminal 2:

```bash
flutter drive \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/stage3_test.dart \
  -d chrome \
  --dart-define=DEBUG_BYPASS_AUTH=true
```

Expected: 3 tests PASS.

- [ ] `── REVIEW GATE ──` Run `flutter run -d chrome --dart-define=DEBUG_BYPASS_AUTH=true`. Navigate to `/home`. Tap all 4 bottom-bar items — active tab highlights dynamically, body text changes, switching back preserves state.

### Step 4.4: Commit

- [ ] `git add -A && git commit -m "feat(stage3): complete — shell + dynamic bottom bar, gate passes"`

---

## Task 5: Stage 4 — Auth Flow

**Implementation plan:** `docs/superpowers/plans/cartfly-flutter/05-stage4-auth.md`

**New file:** `integration_test/stage4_test.dart`

### Step 5.1: Implement Stage 4

- [ ] Complete every task in `docs/superpowers/plans/cartfly-flutter/05-stage4-auth.md`.

Run: `flutter analyze` → **No issues found.**

### Step 5.2: Write Stage 4 integration test

- [ ] Create `integration_test/stage4_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:cartfly/app.dart';
import 'package:cartfly/widgets/cf_bottom_nav.dart';
import 'package:cartfly/widgets/cf_button.dart';

import 'test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await initTestFirebase();
    // Pre-create a verified user so the login test doesn't depend on registration UI.
    await createVerifiedUser(
      email: 'stage4@cartfly.test',
      password: 'TestPass123!',
    );
  });

  tearDownAll(clearEmulatorData);

  testWidgets('stage4: unauthenticated start → login screen shown', (tester) async {
    await tester.pumpWidget(const CartFlyApp());
    await tester.pumpAndSettle(const Duration(seconds: 3));

    expect(find.widgetWithText(CfButton, 'Login'), findsOneWidget);
  });

  testWidgets('stage4: login with valid credentials reaches /home', (tester) async {
    await tester.pumpWidget(const CartFlyApp());
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Enter email into first TextField
    await tester.enterText(find.byType(TextField).at(0), 'stage4@cartfly.test');
    // Enter password into second TextField
    await tester.enterText(find.byType(TextField).at(1), 'TestPass123!');
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(CfButton, 'Login'));
    await tester.pumpAndSettle(const Duration(seconds: 6));

    // Authenticated → router redirects to /home → CfBottomNav visible
    expect(find.byType(CfBottomNav), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('stage4: tapping register button navigates to register screen', (tester) async {
    await tester.pumpWidget(const CartFlyApp());
    await tester.pumpAndSettle(const Duration(seconds: 3));

    await tester.tap(find.widgetWithText(CfOutlineButton, "Don't have an account"));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Register form has a "Full name:" label from CfInput
    expect(find.text('Full name:'), findsOneWidget);
  });

  testWidgets('stage4: register form submits → verify screen appears', (tester) async {
    await tester.pumpWidget(const CartFlyApp());
    await tester.pumpAndSettle(const Duration(seconds: 3));

    await tester.tap(find.widgetWithText(CfOutlineButton, "Don't have an account"));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Fill register form
    await tester.enterText(find.byType(TextField).at(0), 'Test User');
    await tester.enterText(find.byType(TextField).at(1), '0501234567');
    await tester.enterText(find.byType(TextField).at(2), 'newuser4@cartfly.test');
    // Select country (first DropdownButton)
    await tester.tap(find.byType(DropdownButton<String>).at(0));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(DropdownMenuItem<String>).first);
    await tester.pumpAndSettle();
    // Select currency (second DropdownButton)
    await tester.tap(find.byType(DropdownButton<String>).at(0));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(DropdownMenuItem<String>).first);
    await tester.pumpAndSettle();
    // Password fields
    await tester.enterText(find.byType(TextField).at(3), 'TestPass123!');
    await tester.enterText(find.byType(TextField).at(4), 'TestPass123!');
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(CfButton, 'Register'));
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // AuthProvider sets pendingOtp → router shows verify screen
    expect(find.widgetWithText(CfButton, 'I have verified'), findsOneWidget);
  });
}
```

### Step 5.3: Run Stage 4 gate

- [ ] Terminal 1: `firebase emulators:start --only auth,firestore`
- [ ] Terminal 2:

```bash
flutter drive \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/stage4_test.dart \
  -d chrome
```

Expected: 4 tests PASS.

- [ ] `── REVIEW GATE ──` Run `flutter run -d chrome` (no bypass). Register a real test email → verify arrives → "I have verified" → `/home`. Login with it. Forgot password. Sign out. Report any issues.

### Step 5.4: Commit

- [ ] `git add -A && git commit -m "feat(stage4): complete — auth flow on real Firebase, gate passes"`

---

## Task 6: Stage 5 — Home Dashboard & Static Catalogs

**Implementation plan:** `docs/superpowers/plans/cartfly-flutter/06-stage5-home-catalogs.md`

**New file:** `integration_test/stage5_test.dart`

### Step 6.1: Implement Stage 5

- [ ] Complete every task in `docs/superpowers/plans/cartfly-flutter/06-stage5-home-catalogs.md`.

Run: `flutter analyze` → **No issues found.**

### Step 6.2: Write Stage 5 integration test

- [ ] Create `integration_test/stage5_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:cartfly/app.dart';
import 'package:cartfly/widgets/cf_bottom_nav.dart';
import 'package:cartfly/widgets/cf_flag_card.dart';

import 'test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await initTestFirebase();
    await createVerifiedUser(
      email: 'stage5@cartfly.test',
      password: 'TestPass123!',
    );
    await signInUser('stage5@cartfly.test', 'TestPass123!');
  });

  tearDownAll(clearEmulatorData);

  testWidgets('stage5: home screen shows warehouse and locker rows', (tester) async {
    await tester.pumpWidget(const CartFlyApp());
    await tester.pumpAndSettle(const Duration(seconds: 5));

    expect(find.byType(CfBottomNav), findsOneWidget);
    expect(find.text('Our warehouses'), findsOneWidget);
    expect(find.text('Locker locations'), findsOneWidget);
  });

  testWidgets('stage5: tapping warehouses row loads flag-card grid', (tester) async {
    await tester.pumpWidget(const CartFlyApp());
    await tester.pumpAndSettle(const Duration(seconds: 5));

    await tester.tap(find.text('Our warehouses'));
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Warehouses screen shows at least 5 CfFlagCards (one per country)
    expect(find.byType(CfFlagCard), findsNWidgets(5));
  });

  testWidgets('stage5: tapping a flag card loads warehouse detail', (tester) async {
    await tester.pumpWidget(const CartFlyApp());
    await tester.pumpAndSettle(const Duration(seconds: 5));

    await tester.tap(find.text('Our warehouses'));
    await tester.pumpAndSettle(const Duration(seconds: 3));

    await tester.tap(find.byType(CfFlagCard).first);
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Detail screen contains 'Best for:' label
    expect(find.textContaining('Best for'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
```

### Step 6.3: Run Stage 5 gate

- [ ] Terminal 1: `firebase emulators:start --only auth,firestore`
- [ ] Terminal 2:

```bash
flutter drive \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/stage5_test.dart \
  -d chrome
```

Expected: 3 tests PASS.

- [ ] `── REVIEW GATE ──` Run `flutter run -d chrome`. Login → Home → Warehouses → country detail (check static content). Home → Lockers → country map shows OSM map + pins. Bottom bar stays visible on Home; detail screens push over it with back chevron.

### Step 6.4: Commit

- [ ] `git add -A && git commit -m "feat(stage5): complete — home + catalogs, gate passes"`

---

## Task 7: Stage 6 — Shipments (Firestore)

**Implementation plan:** `docs/superpowers/plans/cartfly-flutter/07-stage6-shipments.md`

**New file:** `integration_test/stage6_test.dart`

### Step 7.1: Implement Stage 6

- [ ] Complete every task in `docs/superpowers/plans/cartfly-flutter/07-stage6-shipments.md`.

Run: `flutter test` → order model + repository tests PASS.
Run: `flutter analyze` → **No issues found.**

### Step 7.2: Write Stage 6 integration test

- [ ] Create `integration_test/stage6_test.dart`:

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:cartfly/app.dart';
import 'package:cartfly/widgets/cf_button.dart';
import 'package:cartfly/widgets/cf_status_timeline.dart';

import 'test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await initTestFirebase();
    await createVerifiedUser(
      email: 'stage6@cartfly.test',
      password: 'TestPass123!',
    );
    await signInUser('stage6@cartfly.test', 'TestPass123!');
  });

  tearDownAll(clearEmulatorData);

  testWidgets('stage6: create shipment persists and appears in orders list', (tester) async {
    await tester.pumpWidget(const CartFlyApp());
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Navigate to Create Shipment
    await tester.tap(find.widgetWithText(CfButton, 'Create shipment'));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Fill title
    await tester.enterText(find.byType(TextField).first, 'Integration Test Item');
    await tester.pumpAndSettle();

    // Select country from dropdown
    await tester.tap(find.byType(DropdownButton<String>).first);
    await tester.pumpAndSettle();
    await tester.tap(find.byType(DropdownMenuItem<String>).first);
    await tester.pumpAndSettle();

    // Select Home delivery (not Locker, avoids locker dropdown)
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();

    // Submit
    await tester.tap(find.widgetWithText(CfButton, 'Create'));
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Should navigate to track screen — CfStatusTimeline present
    expect(find.byType(CfStatusTimeline), findsOneWidget);
  });

  testWidgets('stage6: advance status button moves timeline forward', (tester) async {
    await tester.pumpWidget(const CartFlyApp());
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Navigate to Create Shipment and create one
    await tester.tap(find.widgetWithText(CfButton, 'Create shipment'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
    await tester.enterText(find.byType(TextField).first, 'Advance Test');
    await tester.pumpAndSettle();
    await tester.tap(find.byType(DropdownButton<String>).first);
    await tester.pumpAndSettle();
    await tester.tap(find.byType(DropdownMenuItem<String>).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(CfButton, 'Create'));
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // On track screen — tap Advance status
    await tester.tap(find.widgetWithText(CfButton, 'Advance status'));
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Verify in Firestore that status advanced to 'atWarehouse'
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final orders = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('orders')
        .get();
    expect(orders.docs.isNotEmpty, isTrue);
    final status = orders.docs.first.data()['status'] as String;
    expect(status, 'atWarehouse');
  });
}
```

### Step 7.3: Run Stage 6 gate

- [ ] Terminal 1: `firebase emulators:start --only auth,firestore`
- [ ] Terminal 2:

```bash
flutter drive \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/stage6_test.dart \
  -d chrome
```

Expected: 2 tests PASS.

- [ ] `── REVIEW GATE ──` Run `flutter run -d chrome`. Login → Create shipment → order visible in orders list and Home strip → Track → Advance → timeline moves. Hot-restart — shipment still there (Firestore persisted).

### Step 7.4: Commit

- [ ] `git add -A && git commit -m "feat(stage6): complete — shipments create/track/persist, gate passes"`

---

## Task 8: Stage 7 — Plans & Simulated Payment

**Implementation plan:** `docs/superpowers/plans/cartfly-flutter/08-stage7-plans-payment.md`

**New file:** `integration_test/stage7_test.dart`

### Step 8.1: Implement Stage 7

- [ ] Complete every task in `docs/superpowers/plans/cartfly-flutter/08-stage7-plans-payment.md`.

Run: `flutter test` → UserRepository tests PASS.
Run: `flutter analyze` → **No issues found.**

### Step 8.2: Write Stage 7 integration test

- [ ] Create `integration_test/stage7_test.dart`:

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:cartfly/app.dart';
import 'package:cartfly/widgets/cf_button.dart';

import 'test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await initTestFirebase();
    await createVerifiedUser(
      email: 'stage7@cartfly.test',
      password: 'TestPass123!',
    );
    await signInUser('stage7@cartfly.test', 'TestPass123!');
  });

  tearDownAll(clearEmulatorData);

  testWidgets('stage7: plans screen lists Basic, Smart, Prime', (tester) async {
    await tester.pumpWidget(const CartFlyApp());
    await tester.pumpAndSettle(const Duration(seconds: 5));

    await tester.tap(find.text('Subscription plans'));
    await tester.pumpAndSettle(const Duration(seconds: 3));

    expect(find.text('Basic cart'), findsOneWidget);
    expect(find.text('Smart cart'), findsOneWidget);
    expect(find.text('Prime cart'), findsOneWidget);
  });

  testWidgets('stage7: subscribe to Prime sets plan in Firestore', (tester) async {
    await tester.pumpWidget(const CartFlyApp());
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Navigate to Plans
    await tester.tap(find.text('Subscription plans'));
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Tap Prime
    await tester.tap(find.text('Prime cart'));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Tap Subscribe now
    await tester.tap(find.widgetWithText(CfButton, 'Subscribe now'));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Fill card form (valid inputs — all non-empty, card ≥12 digits)
    await tester.enterText(find.byType(TextField).at(0), 'Test Holder');
    await tester.enterText(find.byType(TextField).at(1), '4111111111111111');
    await tester.enterText(find.byType(TextField).at(2), '123');
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(CfButton, 'Confirm'));
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Success screen
    expect(find.text('Payment Successful'), findsOneWidget);

    // Verify Firestore users/{uid}.plan == 'prime'
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();
    expect(doc.data()!['plan'], 'prime');
  });

  testWidgets('stage7: invalid card → payment error screen', (tester) async {
    await tester.pumpWidget(const CartFlyApp());
    await tester.pumpAndSettle(const Duration(seconds: 5));

    await tester.tap(find.text('Subscription plans'));
    await tester.pumpAndSettle(const Duration(seconds: 3));
    await tester.tap(find.text('Smart cart'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
    await tester.tap(find.widgetWithText(CfButton, 'Subscribe now'));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Leave all fields empty → should fail validation
    await tester.tap(find.widgetWithText(CfButton, 'Confirm'));
    await tester.pumpAndSettle(const Duration(seconds: 3));

    expect(find.text('Payment Error'), findsOneWidget);

    // "Try again" returns to card form
    await tester.tap(find.widgetWithText(CfButton, 'Try again'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
    expect(find.widgetWithText(CfButton, 'Confirm'), findsOneWidget);
  });
}
```

### Step 8.3: Run Stage 7 gate

- [ ] Terminal 1: `firebase emulators:start --only auth,firestore`
- [ ] Terminal 2:

```bash
flutter drive \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/stage7_test.dart \
  -d chrome
```

Expected: 3 tests PASS.

- [ ] `── REVIEW GATE ──` Run `flutter run -d chrome`. Plans → Prime → card → success. Check Firestore emulator UI (`localhost:4000`) — `users/{uid}.plan == 'prime'`. Invalid card → error → retry.

### Step 8.4: Commit

- [ ] `git add -A && git commit -m "feat(stage7): complete — plans + payment + subscription, gate passes"`

---

## Task 9: Stage 8 — Settings, Profile & Info Pages

**Implementation plan:** `docs/superpowers/plans/cartfly-flutter/09-stage8-settings-profile.md`

**New file:** `integration_test/stage8_test.dart`

### Step 9.1: Implement Stage 8

- [ ] Complete every task in `docs/superpowers/plans/cartfly-flutter/09-stage8-settings-profile.md`.

Run: `flutter analyze` → **No issues found.**

### Step 9.2: Write Stage 8 integration test

- [ ] Create `integration_test/stage8_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:cartfly/app.dart';
import 'package:cartfly/widgets/cf_bottom_nav.dart';
import 'package:cartfly/widgets/cf_button.dart';

import 'test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await initTestFirebase();
    await createVerifiedUser(
      email: 'stage8@cartfly.test',
      password: 'TestPass123!',
    );
    await signInUser('stage8@cartfly.test', 'TestPass123!');
  });

  tearDownAll(clearEmulatorData);

  testWidgets('stage8: sign-out redirects to login screen', (tester) async {
    await tester.pumpWidget(const CartFlyApp());
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Navigate to Settings tab
    await tester.tap(find.descendant(
      of: find.byType(CfBottomNav),
      matching: find.text('Settings'),
    ));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Tap Sign out button
    await tester.tap(find.widgetWithText(CfButton, 'Sign out'));
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Should be on login screen
    expect(find.widgetWithText(CfButton, 'Login'), findsOneWidget);
  });

  testWidgets('stage8: language switch changes app locale to Arabic', (tester) async {
    // Sign back in after previous test signed out
    await signInUser('stage8@cartfly.test', 'TestPass123!');

    await tester.pumpWidget(const CartFlyApp());
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Navigate to Settings tab
    await tester.tap(find.descendant(
      of: find.byType(CfBottomNav),
      matching: find.text('Settings'),
    ));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Tap Languages
    await tester.tap(find.text('Languages'));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Tap Arabic option
    await tester.tap(find.text('العربية'));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Locale should be ar — text directionality is RTL
    final directionality = tester.widget<Directionality>(
      find.byType(Directionality).first,
    );
    expect(directionality.textDirection, TextDirection.rtl);
  });
}
```

### Step 9.3: Run Stage 8 gate

- [ ] Terminal 1: `firebase emulators:start --only auth,firestore`
- [ ] Terminal 2:

```bash
flutter drive \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/stage8_test.dart \
  -d chrome
```

Expected: 2 tests PASS.

- [ ] `── REVIEW GATE ──` Run `flutter run -d chrome`. Login → Settings → Language → Arabic → UI flips RTL → relaunch (hot restart) → choice persisted. Edit profile. Change password. About / Policy / How it works / Support all render. Sign out → login.

### Step 9.4: Commit

- [ ] `git add -A && git commit -m "feat(stage8): complete — settings + profile + info, gate passes"`

---

## Task 10: Stage 9 — Polish & Full Acceptance

**Implementation plan:** `docs/superpowers/plans/cartfly-flutter/10-stage9-polish.md`

**New file:** `integration_test/stage9_test.dart`

### Step 10.1: Implement Stage 9

- [ ] Complete every task in `docs/superpowers/plans/cartfly-flutter/10-stage9-polish.md`.

Run: `flutter test` → all tests PASS.
Run: `flutter analyze` → **No issues found.**

### Step 10.2: Write Stage 9 full-acceptance integration test

- [ ] Create `integration_test/stage9_test.dart`:

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:cartfly/app.dart';
import 'package:cartfly/widgets/cf_bottom_nav.dart';
import 'package:cartfly/widgets/cf_button.dart';
import 'package:cartfly/widgets/cf_status_timeline.dart';

import 'test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(initTestFirebase);
  tearDownAll(clearEmulatorData);

  testWidgets('acceptance: register → verify → home', (tester) async {
    await tester.pumpWidget(const CartFlyApp());
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Go to register
    await tester.tap(find.widgetWithText(CfOutlineButton, "Don't have an account"));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Fill form
    await tester.enterText(find.byType(TextField).at(0), 'Acceptance User');
    await tester.enterText(find.byType(TextField).at(1), '0501234567');
    await tester.enterText(find.byType(TextField).at(2), 'accept@cartfly.test');
    await tester.tap(find.byType(DropdownButton<String>).at(0));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(DropdownMenuItem<String>).first);
    await tester.pumpAndSettle();
    await tester.tap(find.byType(DropdownButton<String>).at(0));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(DropdownMenuItem<String>).first);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(3), 'Accept123!');
    await tester.enterText(find.byType(TextField).at(4), 'Accept123!');
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(CfButton, 'Register'));
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Verify screen
    expect(find.widgetWithText(CfButton, 'I have verified'), findsOneWidget);

    // Use emulator to mark email as verified
    await verifyCurrentUser();

    // Tap "I have verified"
    await tester.tap(find.widgetWithText(CfButton, 'I have verified'));
    await tester.pumpAndSettle(const Duration(seconds: 6));

    // Should be on /home
    expect(find.byType(CfBottomNav), findsOneWidget);
  });

  testWidgets('acceptance: create shipment persists + tracks', (tester) async {
    await createVerifiedUser(email: 'shiptest@cartfly.test', password: 'TestPass123!');
    await signInUser('shiptest@cartfly.test', 'TestPass123!');

    await tester.pumpWidget(const CartFlyApp());
    await tester.pumpAndSettle(const Duration(seconds: 5));

    await tester.tap(find.widgetWithText(CfButton, 'Create shipment'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
    await tester.enterText(find.byType(TextField).first, 'Final Acceptance Item');
    await tester.pumpAndSettle();
    await tester.tap(find.byType(DropdownButton<String>).first);
    await tester.pumpAndSettle();
    await tester.tap(find.byType(DropdownMenuItem<String>).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(CfButton, 'Create'));
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Track screen shows timeline
    expect(find.byType(CfStatusTimeline), findsOneWidget);

    // Advance status and verify in Firestore
    await tester.tap(find.widgetWithText(CfButton, 'Advance status'));
    await tester.pumpAndSettle(const Duration(seconds: 3));
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final orders = await FirebaseFirestore.instance
        .collection('users').doc(uid).collection('orders').get();
    expect(orders.docs.first.data()['status'], 'atWarehouse');
  });

  testWidgets('acceptance: subscribe to plan sets Firestore field', (tester) async {
    await createVerifiedUser(email: 'plantest@cartfly.test', password: 'TestPass123!');
    await signInUser('plantest@cartfly.test', 'TestPass123!');

    await tester.pumpWidget(const CartFlyApp());
    await tester.pumpAndSettle(const Duration(seconds: 5));

    await tester.tap(find.text('Subscription plans'));
    await tester.pumpAndSettle(const Duration(seconds: 3));
    await tester.tap(find.text('Prime cart'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
    await tester.tap(find.widgetWithText(CfButton, 'Subscribe now'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
    await tester.enterText(find.byType(TextField).at(0), 'Test Holder');
    await tester.enterText(find.byType(TextField).at(1), '4111111111111111');
    await tester.enterText(find.byType(TextField).at(2), '123');
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(CfButton, 'Confirm'));
    await tester.pumpAndSettle(const Duration(seconds: 5));

    final uid = FirebaseAuth.instance.currentUser!.uid;
    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    expect(doc.data()!['plan'], 'prime');
  });

  testWidgets('acceptance: sign-out and login returns to /home', (tester) async {
    await createVerifiedUser(email: 'signout@cartfly.test', password: 'TestPass123!');
    await signInUser('signout@cartfly.test', 'TestPass123!');

    await tester.pumpWidget(const CartFlyApp());
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Sign out via Settings tab
    await tester.tap(find.descendant(
      of: find.byType(CfBottomNav),
      matching: find.text('Settings'),
    ));
    await tester.pumpAndSettle(const Duration(seconds: 2));
    await tester.tap(find.widgetWithText(CfButton, 'Sign out'));
    await tester.pumpAndSettle(const Duration(seconds: 5));

    expect(find.widgetWithText(CfButton, 'Login'), findsOneWidget);

    // Log back in
    await tester.enterText(find.byType(TextField).at(0), 'signout@cartfly.test');
    await tester.enterText(find.byType(TextField).at(1), 'TestPass123!');
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(CfButton, 'Login'));
    await tester.pumpAndSettle(const Duration(seconds: 6));

    expect(find.byType(CfBottomNav), findsOneWidget);
  });

  testWidgets('acceptance: language switch produces RTL layout', (tester) async {
    await createVerifiedUser(email: 'rtl@cartfly.test', password: 'TestPass123!');
    await signInUser('rtl@cartfly.test', 'TestPass123!');

    await tester.pumpWidget(const CartFlyApp());
    await tester.pumpAndSettle(const Duration(seconds: 5));

    await tester.tap(find.descendant(
      of: find.byType(CfBottomNav),
      matching: find.text('Settings'),
    ));
    await tester.pumpAndSettle(const Duration(seconds: 2));
    await tester.tap(find.text('Languages'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
    await tester.tap(find.text('العربية'));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    final dir = tester.widget<Directionality>(find.byType(Directionality).first);
    expect(dir.textDirection, TextDirection.rtl);
  });
}
```

### Step 10.3: Run all integration tests sequentially (final verification)

- [ ] Terminal 1: `firebase emulators:start --only auth,firestore`
- [ ] Terminal 2 — run each stage test in order to confirm no regressions:

```bash
# Stages 0–3 need the bypass flag
flutter drive --driver=test_driver/integration_test.dart --target=integration_test/stage0_test.dart -d chrome
flutter drive --driver=test_driver/integration_test.dart --target=integration_test/stage1_test.dart -d chrome
flutter drive --driver=test_driver/integration_test.dart --target=integration_test/stage2_test.dart -d chrome
flutter drive --driver=test_driver/integration_test.dart --target=integration_test/stage3_test.dart -d chrome --dart-define=DEBUG_BYPASS_AUTH=true

# Stages 4–9 — no bypass
flutter drive --driver=test_driver/integration_test.dart --target=integration_test/stage4_test.dart -d chrome
flutter drive --driver=test_driver/integration_test.dart --target=integration_test/stage5_test.dart -d chrome
flutter drive --driver=test_driver/integration_test.dart --target=integration_test/stage6_test.dart -d chrome
flutter drive --driver=test_driver/integration_test.dart --target=integration_test/stage7_test.dart -d chrome
flutter drive --driver=test_driver/integration_test.dart --target=integration_test/stage8_test.dart -d chrome
flutter drive --driver=test_driver/integration_test.dart --target=integration_test/stage9_test.dart -d chrome
```

Expected: All PASS.

Also run: `flutter test` → all unit/widget tests PASS.
Also run: `flutter analyze` → No issues found.

### Step 10.4: Final build verification

- [ ] `flutter build web` → succeeds (no errors)
- [ ] `flutter build apk --debug` → succeeds (no errors)

### Step 10.5: Full acceptance manual run

- [ ] `── REVIEW GATE ──` Run `flutter run -d chrome`. Walk the full acceptance checklist from `docs/superpowers/plans/cartfly-flutter/10-stage9-polish.md` § "Task 9.5 Full acceptance run". Confirm every item. Report any failures.

### Step 10.6: Final commit

- [ ] `git add -A && git commit -m "feat(stage9): complete — polish + RTL + full acceptance, all gates pass"`

---

## Summary

| Task | Stage | Gate |
|---|---|---|
| 0 | Test infrastructure | `flutter pub get` + emulator start |
| 1 | Stage 0 Teardown | `stage0_test.dart` on Chrome |
| 2 | Stage 1 Design System | `stage1_test.dart` on Chrome |
| 3 | Stage 2 Component Library | `stage2_test.dart` on Chrome |
| 4 | Stage 3 Shell | `stage3_test.dart` on Chrome (bypass auth) |
| 5 | Stage 4 Auth | `stage4_test.dart` on Chrome |
| 6 | Stage 5 Home/Catalogs | `stage5_test.dart` on Chrome |
| 7 | Stage 6 Shipments | `stage6_test.dart` on Chrome |
| 8 | Stage 7 Plans/Payment | `stage7_test.dart` on Chrome |
| 9 | Stage 8 Settings/Profile | `stage8_test.dart` on Chrome |
| 10 | Stage 9 Polish | `stage9_test.dart` on Chrome + all stages re-run |
