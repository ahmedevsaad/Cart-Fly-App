# Stage 2 — Component Library

**Goal:** Build the reusable themed `Cf*` widgets that every screen composes from, plus a gallery screen to eyeball them. This is the Flutter equivalent of the clone's `design-system.css` component classes.

**Prereq:** Stage 1 complete.

**Files (all under `lib/widgets/`):**
- `cf_background.dart` — tiled watermark.
- `cf_scaffold.dart` — page shell (background + optional top bar + optional bottom nav slot).
- `cf_top_bar.dart` — back chevron + "CartFly" wordmark.
- `cf_button.dart` — `CfButton`, `CfOutlineButton`.
- `cf_input.dart` — labeled text field.
- `cf_card.dart` — bordered container.
- `cf_list_row.dart` — settings-style row with trailing arrow.
- `cf_flag_card.dart` — country flag card.
- `cf_status_timeline.dart` — order tracking timeline.
- `cf_states.dart` — `CfLoading`, `CfEmptyState`, `CfErrorState`.
- Test: `test/widgets/cf_button_test.dart`, `test/widgets/cf_input_test.dart`
- Screen: `lib/features/dev/gallery_screen.dart` (temporary; removed in Stage 9)

> `CfBottomNav` is built in **Stage 3** (it needs the shell index). This stage builds everything else.

---

### Task 2.1: Watermark background

**Files:** Create `lib/widgets/cf_background.dart`

- [ ] **Step 1: Implement (reuses the proven tiling approach from the old `app_background.dart`)**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/app_colors.dart';

/// Faint tiled airplane/box watermark. Pass [solid] for a flat color (splash).
class CfBackground extends StatelessWidget {
  const CfBackground({super.key, required this.child, this.solid});
  final Widget child;
  final Color? solid;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: solid ?? AppColors.bgPage,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (solid == null)
            IgnorePointer(
              child: LayoutBuilder(builder: (context, c) {
                const tile = 240.0;
                final cols = (c.maxWidth / tile).ceil();
                final rows = (c.maxHeight / tile).ceil();
                return Wrap(
                  children: List.generate(
                    cols * rows,
                    (_) => SizedBox(
                      width: tile, height: tile,
                      child: SvgPicture.asset('assets/pattern/airplane_box.svg'),
                    ),
                  ),
                );
              }),
            ),
          child,
        ],
      ),
    );
  }
}
```

- [ ] **Step 2: Analyze + commit** — `flutter analyze`; `git commit -m "feat(stage2): cf_background"`.

### Task 2.2: CfScaffold

**Files:** Create `lib/widgets/cf_scaffold.dart`

- [ ] **Step 1: Implement** (`bottomNav` is a slot the shell fills in Stage 3)

```dart
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'cf_background.dart';

class CfScaffold extends StatelessWidget {
  const CfScaffold({
    super.key,
    required this.body,
    this.topBar,
    this.bottomNav,
    this.solidBackground,
  });

  final Widget body;
  final PreferredSizeWidget? topBar;
  final Widget? bottomNav;
  final Color? solidBackground;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: solidBackground ?? AppColors.bgPage,
      appBar: topBar,
      bottomNavigationBar: bottomNav,
      body: CfBackground(
        solid: solidBackground,
        child: SafeArea(child: body),
      ),
    );
  }
}
```

- [ ] **Step 2: Analyze + commit.**

### Task 2.3: CfTopBar

**Files:** Create `lib/widgets/cf_top_bar.dart`

- [ ] **Step 1: Implement** (back chevron + centered wordmark)

```dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/app_text.dart';

class CfTopBar extends StatelessWidget implements PreferredSizeWidget {
  const CfTopBar({super.key, this.showBack = true, this.onBack});
  final bool showBack;
  final VoidCallback? onBack;

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: showBack
          ? IconButton(
              onPressed: onBack ?? () => Navigator.of(context).maybePop(),
              icon: SvgPicture.asset('assets/icons/chevron-back.svg',
                  width: 24, height: 24),
            )
          : null,
      centerTitle: true,
      title: Text('CartFly', style: AppText.logo),
    );
  }
}
```

- [ ] **Step 2: Analyze + commit.**

### Task 2.4: Buttons (TDD)

**Files:** Create `lib/widgets/cf_button.dart`; Test `test/widgets/cf_button_test.dart`

- [ ] **Step 1: Write the failing test**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cartfly/widgets/cf_button.dart';

void main() {
  testWidgets('CfButton shows label and fires onPressed', (tester) async {
    var tapped = false;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: CfButton(label: 'Login', onPressed: () => tapped = true),
      ),
    ));
    expect(find.text('Login'), findsOneWidget);
    await tester.tap(find.text('Login'));
    expect(tapped, isTrue);
  });
}
```

- [ ] **Step 2: Run → fails** — `flutter test test/widgets/cf_button_test.dart` → FAIL (CfButton undefined).

- [ ] **Step 3: Implement**

```dart
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';

class CfButton extends StatelessWidget {
  const CfButton({super.key, required this.label, this.onPressed});
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(onPressed: onPressed, child: Text(label)),
    );
  }
}

class CfOutlineButton extends StatelessWidget {
  const CfOutlineButton({super.key, required this.label, this.onPressed});
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.btnAlt,
          foregroundColor: Colors.white,
          side: const BorderSide(color: AppColors.primary),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppColors.radius)),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        child: Text(label, style: AppText.bodyMedium.copyWith(color: Colors.white)),
      ),
    );
  }
}
```

- [ ] **Step 4: Run → passes.** `flutter test test/widgets/cf_button_test.dart` → PASS.
- [ ] **Step 5: Commit** — `git commit -m "feat(stage2): cf_button (+test)"`.

### Task 2.5: CfInput (TDD)

**Files:** Create `lib/widgets/cf_input.dart`; Test `test/widgets/cf_input_test.dart`

- [ ] **Step 1: Failing test**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cartfly/widgets/cf_input.dart';

void main() {
  testWidgets('CfInput shows label and accepts text', (tester) async {
    final c = TextEditingController();
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(body: CfInput(label: 'Email:', controller: c)),
    ));
    expect(find.text('Email:'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'a@b.com');
    expect(c.text, 'a@b.com');
  });
}
```

- [ ] **Step 2: Run → fails.**

- [ ] **Step 3: Implement**

```dart
import 'package:flutter/material.dart';
import '../theme/app_text.dart';

class CfInput extends StatelessWidget {
  const CfInput({
    super.key,
    required this.label,
    required this.controller,
    this.obscure = false,
    this.keyboardType,
  });
  final String label;
  final TextEditingController controller;
  final bool obscure;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppText.body),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
```

- [ ] **Step 4: Run → passes. Commit.**

### Task 2.6: CfCard, CfListRow, CfFlagCard

**Files:** `lib/widgets/cf_card.dart`, `lib/widgets/cf_list_row.dart`, `lib/widgets/cf_flag_card.dart`

- [ ] **Step 1: CfCard**

```dart
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CfCard extends StatelessWidget {
  const CfCard({super.key, required this.child, this.padding});
  final Widget child;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}
```

- [ ] **Step 2: CfListRow** (settings rows — label + trailing arrow icon)

```dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/app_text.dart';

class CfListRow extends StatelessWidget {
  const CfListRow({super.key, required this.label, this.onTap});
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        child: Row(
          children: [
            Expanded(child: Text(label, style: AppText.bodyMedium)),
            SvgPicture.asset('assets/icons/arrow-right-circle.svg',
                width: 24, height: 24),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 3: CfFlagCard** (uses `country_flags` package)

> **API correctness (grill-with-docs finding):** `country_flags` v4 takes a `theme: ImageTheme(...)` — NOT direct `width`/`height` args. First bump the dependency:
> ```bash
> flutter pub add country_flags:^4.0.0
> ```
> (`pubspec.yaml` currently pins `^3.2.0`, whose API differs; v4's `ImageTheme` is what the code below uses.)

```dart
import 'package:flutter/material.dart';
import 'package:country_flags/country_flags.dart';
import '../theme/app_text.dart';

/// [code] is an ISO country code, e.g. 'SA','EG','AE','US','CN'.
class CfFlagCard extends StatelessWidget {
  const CfFlagCard({super.key, required this.code, required this.name, this.onTap});
  final String code;
  final String name;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          CountryFlag.fromCountryCode(
            code,
            theme: const ImageTheme(
              width: 135, height: 90, shape: RoundedRectangle(8)),
          ),
          const SizedBox(height: 6),
          Text(name, style: AppText.bodyMedium, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
```
> If `RoundedRectangle`/`ImageTheme` names differ in the resolved v4 minor, run `flutter pub get` then check `package:country_flags/country_flags.dart` exports; the parameter is `theme:` regardless.

- [ ] **Step 4: Analyze + commit** all three.

### Task 2.7: CfStatusTimeline & CfStates

**Files:** `lib/widgets/cf_status_timeline.dart`, `lib/widgets/cf_states.dart`

> `CfStatusTimeline` takes an `int activeIndex` (0–5) so it does **not** depend on the `Order` model yet (that arrives in Stage 6). Stage 6 maps `OrderStatus.index` → this widget.

- [ ] **Step 1: CfStatusTimeline**

```dart
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';

class CfStatusTimeline extends StatelessWidget {
  const CfStatusTimeline({super.key, required this.steps, required this.activeIndex});
  final List<String> steps;       // e.g. ['Waiting','At warehouse',...]
  final int activeIndex;          // 0-based; steps up to & including are 'done'

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < steps.length; i++) ...[
          Row(
            children: [
              Icon(i <= activeIndex ? Icons.check_circle : Icons.circle_outlined,
                  color: i <= activeIndex ? AppColors.primary : AppColors.muted),
              const SizedBox(width: 10),
              Text(steps[i], style: AppText.body),
            ],
          ),
          if (i < steps.length - 1)
            const Padding(
              padding: EdgeInsets.only(left: 11),
              child: SizedBox(height: 20, child: VerticalDivider(width: 2)),
            ),
        ],
      ],
    );
  }
}
```

- [ ] **Step 2: CfStates**

```dart
import 'package:flutter/material.dart';
import '../theme/app_text.dart';

class CfLoading extends StatelessWidget {
  const CfLoading({super.key});
  @override
  Widget build(BuildContext context) =>
      const Center(child: CircularProgressIndicator());
}

class CfEmptyState extends StatelessWidget {
  const CfEmptyState({super.key, required this.message});
  final String message;
  @override
  Widget build(BuildContext context) =>
      Center(child: Text(message, style: AppText.caption, textAlign: TextAlign.center));
}

class CfErrorState extends StatelessWidget {
  const CfErrorState({super.key, required this.message, this.onRetry});
  final String message;
  final VoidCallback? onRetry;
  @override
  Widget build(BuildContext context) => Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(message, style: AppText.body, textAlign: TextAlign.center),
          if (onRetry != null)
            TextButton(onPressed: onRetry, child: const Text('Retry')),
        ]),
      );
}
```

- [ ] **Step 3: Analyze + commit.**

### Task 2.8: Gallery screen (temporary)

**Files:** Create `lib/features/dev/gallery_screen.dart`; Modify `lib/app.dart` to show it.

- [ ] **Step 1: Compose every widget once** in a scrollable column (buttons, input, card, list row, flag card, timeline at index 2, empty/error states). Point `app.dart` `home:` to `const GalleryScreen()`.

- [ ] **Step 2: Run + visually verify** — `flutter run -d chrome`. Compare buttons/inputs/cards to `html/components.html` and `html/screens/login.html`. Each widget renders without overflow.

- [ ] **Step 3: Run all widget tests** — `flutter test` → all PASS.

- [ ] **Step 4: Commit** — `git commit -m "feat(stage2): component library + gallery"`.

---

## Stage exit check
- `flutter test` → all widget tests pass.
- `flutter analyze` → No issues found.
- Gallery screen shows all `Cf*` widgets styled to match the clone.
