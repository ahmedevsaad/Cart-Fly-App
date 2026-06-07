# Stage 1 — Design System

**Goal:** Recreate the HTML clone's design tokens as Flutter theme code, copy assets, and prove they render.

**Prereq:** Stage 0 complete.

**Files:**
- Create: `lib/theme/app_colors.dart`, `lib/theme/app_text.dart`, `lib/theme/app_theme.dart`
- Modify: `lib/app.dart` (use the theme + a token smoke screen), `pubspec.yaml` (assets globs)
- Assets: copy `html/assets/{icons,images,pattern}` → `assets/`

Token source of truth: `html/design-system.css` (`:root` block).

---

### Task 1.1: Color tokens

**Files:** Create `lib/theme/app_colors.dart`

- [ ] **Step 1: Write the colors** (values copied verbatim from `html/design-system.css`)

```dart
import 'package:flutter/material.dart';

/// CartFly color tokens — mirror of html/design-system.css :root.
class AppColors {
  AppColors._();

  static const bgSplash = Color(0xFFC5E2FF);
  static const bgPage = Color(0xFFFFFFFF);
  static const primary = Color(0xFF2563EB);
  static const btnFill = Color(0xFF86A6EA);
  static const btnAlt = Color(0xFF649DDE);
  static const borderStrong = Color(0xFF16447B);
  static const inputBg = Color(0xFFFFFFFF);
  static const inputBgAlt = Color(0xFFF1F3F5);
  static const inputBorder = Color(0xFF848484);
  static const text = Color(0xFF000000);
  static const textSoft = Color(0xFF120101);
  static const muted = Color(0xFF64748B);
  static const navBar = Color(0xFF86A6EA);   // bottom bar background
  static const navPill = Color(0xFFC7D3F2);  // inactive nav item pill
  static const danger = Color(0xFFEF4444);
  static const cardBg = Color(0xFFECEEF0);

  static const double radius = 10;
}
```

- [ ] **Step 2: Analyze + commit**

Run: `flutter analyze` → No issues found.
```bash
git add lib/theme/app_colors.dart && git commit -m "feat(stage1): color tokens"
```

### Task 1.2: Text styles

**Files:** Create `lib/theme/app_text.dart`

- [ ] **Step 1: Write text styles using google_fonts**

```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Typography — Playfair Display (display/logo), Inter (body),
/// Alan Sans (accent), per html/design-system.css.
class AppText {
  AppText._();

  static TextStyle get logo => GoogleFonts.playfairDisplay(
      fontSize: 32, fontWeight: FontWeight.w600, color: AppColors.text);
  static TextStyle get display => GoogleFonts.playfairDisplay(
      fontSize: 44, fontWeight: FontWeight.w600, color: AppColors.text);
  static TextStyle get title => GoogleFonts.inter(
      fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.text);
  static TextStyle get heading => GoogleFonts.inter(
      fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.text);
  static TextStyle get body => GoogleFonts.inter(
      fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.text);
  static TextStyle get bodyMedium => GoogleFonts.inter(
      fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.text);
  static TextStyle get caption => GoogleFonts.inter(
      fontSize: 13, fontWeight: FontWeight.w400, color: AppColors.muted);
  // Accent text (e.g. "Forget password?"). The clone uses "Alan Sans", but that
  // font may be absent from the pinned google_fonts version and would throw at
  // runtime — use Inter italic (negligible visual difference, no crash risk).
  static TextStyle get accent => GoogleFonts.inter(
      fontSize: 16, fontWeight: FontWeight.w400,
      fontStyle: FontStyle.italic, color: AppColors.text);
}
```

> **Font safety (grill-with-docs finding):** Only **Playfair Display** (display/logo) and **Inter** (everything else) are used — both are reliably present in `google_fonts`. Do NOT call `GoogleFonts.alanSans()` / `GoogleFonts.instrumentSerif()`; those generated methods may not exist in the installed version.

- [ ] **Step 2: Analyze + commit**

Run: `flutter analyze` → No issues found.
```bash
git add lib/theme/app_text.dart && git commit -m "feat(stage1): text styles"
```

### Task 1.3: ThemeData

**Files:** Create `lib/theme/app_theme.dart`

- [ ] **Step 1: Build the theme**

```dart
import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text.dart';

ThemeData buildAppTheme() {
  final base = ThemeData.light(useMaterial3: true);
  return base.copyWith(
    scaffoldBackgroundColor: AppColors.bgPage,
    colorScheme: base.colorScheme.copyWith(
      primary: AppColors.primary,
      surface: AppColors.bgPage,
    ),
    textTheme: base.textTheme.apply(bodyColor: AppColors.text),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.inputBg,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppColors.radius),
        borderSide: const BorderSide(color: AppColors.borderStrong),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppColors.radius),
        borderSide: const BorderSide(color: AppColors.borderStrong),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.btnFill,
        foregroundColor: Colors.white,
        textStyle: AppText.bodyMedium.copyWith(color: Colors.white),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppColors.radius)),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      ),
    ),
  );
}
```

- [ ] **Step 2: Analyze + commit**

Run: `flutter analyze` → No issues found.
```bash
git add lib/theme/app_theme.dart && git commit -m "feat(stage1): app theme"
```

### Task 1.4: Copy assets + register in pubspec

**Files:** copy assets; modify `pubspec.yaml`

- [ ] **Step 1: Copy clone assets into the Flutter project**

```bash
cd w:/cart-fly
mkdir -p assets/icons assets/images
cp html/assets/icons/* assets/icons/
cp html/assets/images/*.png assets/images/ 2>/dev/null || true
cp html/assets/pattern/airplane_box.svg assets/pattern/airplane_box.svg
```

- [ ] **Step 2: Ensure `pubspec.yaml` assets section includes the new folders**

`pubspec.yaml` `flutter:` block should list:
```yaml
  assets:
    - assets/flags/
    - assets/maps/
    - assets/pattern/
    - assets/icons/
    - assets/images/
```

- [ ] **Step 3: Fetch + analyze**

Run: `flutter pub get` then `flutter analyze`
Expected: No issues found.

### Task 1.5: Token smoke screen

**Files:** Modify `lib/app.dart`

- [ ] **Step 1: Render tokens to verify they load**

```dart
import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'theme/app_colors.dart';
import 'theme/app_text.dart';

class CartFlyApp extends StatelessWidget {
  const CartFlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CartFly',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: Scaffold(
        backgroundColor: AppColors.bgSplash,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('CartFly', style: AppText.display),
              Text('from cart to doorstep', style: AppText.caption),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: () {}, child: const Text('Login')),
            ],
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: Run and visually verify**

Run: `flutter run -d chrome`
Expected: blue (`#c5e2ff`) background, serif "CartFly" wordmark, muted subtitle, a `#86a6ea` pill "Login" button. Compare to `html/screens/home.html`.

- [ ] **Step 3: Commit**

```bash
git add -A && git commit -m "feat(stage1): assets + token smoke screen"
```

---

## Stage exit check
- `flutter analyze` → No issues found.
- Smoke screen renders the tokens (fonts load via google_fonts, colors correct).
- Assets present under `assets/icons`, `assets/images`, `assets/pattern`.
