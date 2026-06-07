# CartFly Flutter — Execution Strategy Design

**Date:** 2026-06-08
**Scope:** How to implement the 10-stage CartFly Flutter rebuild (see `docs/superpowers/plans/cartfly-flutter/`) with stage-by-stage review gates, unit/widget TDD, and `integration_test` running on Chrome.

**Source plans:** `docs/superpowers/plans/cartfly-flutter/00-overview.md` (and stage files 01–10)
**Visual reference:** `html/` (HTML/Tailwind clone)
**Existing spec:** `docs/superpowers/specs/2026-05-09-cartfly-mockups-and-auth-design.md`

---

## 1. Chosen Approach

**Approach A — TDD during + integration test per stage gate.**

Each stage ends with three automated checks before the user review gate:
1. `flutter analyze` → No issues found
2. `flutter test` → all unit/widget tests pass
3. `flutter drive --driver=test_driver/integration_test.dart --target=integration_test/stage_N_test.dart -d chrome` → passes

Only after those three pass does the user manually review the running app and confirm the stage exit check. On confirmation ("ok"), commit and move to the next stage.

---

## 2. Test Infrastructure (one-time setup before Stage 0)

### 2.1 Dependencies

Add to `pubspec.yaml` `dev_dependencies`:

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  integration_test:
    sdk: flutter
  fake_cloud_firestore: ^3.0.0   # already planned for Stage 6
```

### 2.2 Driver shim

`test_driver/integration_test.dart`:

```dart
import 'package:integration_test/integration_test_driver.dart';
Future<void> main() => integrationDriver();
```

### 2.3 Shared test helper

`integration_test/test_helpers.dart`:

```dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cartfly/firebase_options.dart';

Future<void> initTestFirebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
}
```

### 2.4 Firebase emulator config

`firebase.json` already exists. Add/confirm the `emulators` block:

```json
{
  "emulators": {
    "auth": { "port": 9099 },
    "firestore": { "port": 8080 },
    "ui": { "enabled": true }
  }
}
```

### 2.5 Running a stage test

```
# Terminal 1
firebase emulators:start --only auth,firestore

# Terminal 2
flutter drive \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/stage_N_test.dart \
  -d chrome
```

---

## 3. Per-Stage Integration Test Coverage

Each `integration_test/stage_N_test.dart` verifies the **minimum automated proof** of that stage's exit check. Tests verify behavior, not pixels.

| Stage | File | Integration Test Covers |
|---|---|---|
| 0 | `stage0_test.dart` | App launches and shows "CartFly — rebuilding" |
| 1 | `stage1_test.dart` | Smoke screen: splash color present, "CartFly" display text, ElevatedButton renders |
| 2 | `stage2_test.dart` | Gallery screen: all `Cf*` widgets render without overflow; `CfButton` tap fires callback |
| 3 | `stage3_test.dart` | With `DEBUG_BYPASS_AUTH=true`: 4 bottom-bar items present; tapping each switches body text; active item changes |
| 4 | `stage4_test.dart` | Register via emulator → verify screen appears → login → `/home` reached |
| 5 | `stage5_test.dart` | Home rows present; Warehouses grid loads; country detail screen loads |
| 6 | `stage6_test.dart` | Create shipment → appears in orders list → Track screen shows timeline → Advance moves status |
| 7 | `stage7_test.dart` | Plans screen → Prime → card form → success screen → Firestore `plan == "prime"` |
| 8 | `stage8_test.dart` | Language switch persists; sign-out redirects to `/login` |
| 9 | `stage9_test.dart` | Full acceptance: register→verify→home → create shipment → subscribe → switch language → sign out → login |

Unit/widget tests (TDD) are written during each stage exactly as the existing stage plans specify — these integration tests are additive on top.

---

## 4. Per-Stage Execution Rhythm

Every stage follows this loop:

```
1. Implement tasks (TDD for logic: write failing test → implement → pass)
2. flutter analyze → No issues found
3. flutter test → all unit/widget tests pass
4. firebase emulators:start --only auth,firestore
5. flutter drive ... --target=integration_test/stage_N_test.dart -d chrome → PASS
6. ── REVIEW GATE ──
   User manually inspects the running app in Chrome
   User confirms stage exit check (from the stage plan file)
   User says "ok" or flags issues
7. git commit "feat(stageN): ..."  (per-task commits already done during step 1)
8. Move to next stage
```

### Auth bypass for Stages 0–3

Stages 0–3 predate the auth screens. Integration tests for those stages use `--dart-define=DEBUG_BYPASS_AUTH=true`. From Stage 4 onward, tests connect to the Firebase Auth emulator.

### On test failure

Do not advance to the next stage. Fix the failure first — a stage gate exists to surface regressions early. A bug traced to Stage 3 routing but caught at Stage 5 is better than finding it at Stage 9.

---

## 5. Commit Strategy

- **Per-task commits** during implementation: `feat(stage1): color tokens`, `feat(stage2): cf_button (+test)`, etc. (exactly as specified in the stage plan files)
- **Stage-complete commit** after integration test passes: `feat(stage1): complete — tests pass`

---

## 6. Stage Map (summary)

| Stage | Plan File | Key Deliverable |
|---|---|---|
| 0 | `01-stage0-teardown.md` | Old UI removed, app compiles to blank shell |
| 1 | `02-stage1-design-system.md` | Color tokens, typography, ThemeData, assets |
| 2 | `03-stage2-components.md` | `Cf*` widget library + gallery screen |
| 3 | `04-stage3-shell.md` | `StatefulShellRoute`, dynamic bottom bar, auth redirect, `SettingsProvider` |
| 4 | `05-stage4-auth.md` | Splash/login/register/verify/forgot/welcome on real Firebase |
| 5 | `06-stage5-home-catalogs.md` | Home dashboard + warehouses + lockers (static data) |
| 6 | `07-stage6-shipments.md` | Order model/repo/provider, create-shipment, list, track (Firestore) |
| 7 | `08-stage7-plans-payment.md` | Plans chooser, simulated card payment, subscription |
| 8 | `09-stage8-settings-profile.md` | Language/currency persist, edit-profile, change-password, info pages |
| 9 | `10-stage9-polish.md` | RTL pass, empty/error states, remove dev scaffolding, full acceptance |

---

## 7. Acceptance (end of Stage 9)

All of the following automated and manual checks pass:

- `flutter analyze` → No issues found
- `flutter test` → all unit/widget tests green
- All 10 `integration_test/stage_N_test.dart` files pass on Chrome
- Register→verify→home on real Firebase ✔
- Create-shipment persists and tracks ✔
- Subscribe sets `user.plan` in Firestore ✔
- Language/currency persist across relaunches ✔
- Dynamic bottom bar highlights active tab ✔
- RTL (Arabic) layout correct ✔
- `flutter build web` and `flutter build apk --debug` succeed ✔
