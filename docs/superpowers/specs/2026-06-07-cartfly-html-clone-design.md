# CartFly — Figma Page 1 → HTML/Tailwind Clone

**Date:** 2026-06-07
**Scope:** Clone all ~38 app screens from Figma **Page 1** into static HTML + Tailwind CSS files, connected to each other via real links, with real assets exported from Figma. Output is an intermediate artifact that will later be converted to Flutter.

This spec covers the HTML clone only. The Flutter conversion is a later spec.

---

## 1. Goal & Constraints

- **Faithful clone** of every screen on Figma Page 1, mobile frame 390×844.
- **Connected:** screens link to each other via plain `<a href>`, using the designer's real prototype links (Figma `get_reactions`), gaps filled by judgment.
- **Real assets:** every image/icon exported from Figma into `html/assets/` (user choice A — full export, including icons as SVG).
- **Flutter-friendly:** HTML uses Tailwind flex/grid flow (not absolute positioning) so it maps to Flutter `Column`/`Row`/`Padding`. Absolute positioning used only for genuine overlaps (popups/modals, decorative background).
- **Never guess** — all design data loaded from Figma MCP (`figma-mcp-go`).
- Shared design system extracted once → maps cleanly to Flutter `ThemeData`/`AppColors`/`TextStyles`.

## 2. Output Structure

```
html/
  index.html              landing → splash (home.html)
  design-system.css       shared tokens (CSS vars) + component classes
  components.html          reference blocks: top bar, bottom nav, buttons, cards, bg
  assets/
    images/               exported PNGs (logos, flags, photos, decorative)
    icons/                exported SVGs (home, account_circle, settings, chevron, arrow-right-circle)
  screens/
    home.html             (splash — first "Home" frame)
    login.html            (second "Home" frame = login form)
    register.html
    welcome.html
    main.html             (Main page)
    warehouses.html
    warehouse-saudi.html  warehouse-egypt.html  warehouse-uae.html
    warehouse-china.html  warehouse-usa.html
    my-profile.html
    settings.html  settings-language.html  settings-currency.html
    how-it-works.html
    have-an-issue.html
    lockers.html          (lockers location)
    lockers-saudi.html    (Saudi arabia)
    menu.html
    our-plans.html  plan-prime.html  plan-smart.html  plan-basic.html
    our-plans-3.html  our-plans-6.html  our-plans-7.html
    our-plans-8.html  our-plans-9.html  our-plans-10.html
    shein-checkout.html  shein-checkout-final.html
    cartfly-popup-1.html  cartfly-popup-2.html
    cartfly-popup-3.html  cartfly-popup-4.html
    order-details.html
    about-us.html
    policy.html
```

- Each screen = one standalone `.html`, loads Tailwind via CDN + links `../design-system.css`.
- One file per screen = one Flutter screen widget later.
- `design-system.css` = the future Flutter `ThemeData`.

**Note on screen count:** Figma Page 1 has 38 named frames. Some are duplicate/overlay states (splash vs login, settings dropdown states, popup states). Each visual state is kept as its own file. Final count may shift ±a few as agents discover genuine merges or splits; any change is reported.

## 3. Design System (real Figma values)

No Figma variables or shared paint styles exist (`get_variable_defs` → empty, `get_styles` paints → empty). Colors are inline per node. Phase 1 samples multiple frames, then **normalizes** the slightly-inconsistent mockup hexes into one clean token set (flagged cleanup — the HTML is a clean clone, not a bug-for-bug copy of stray colors).

### Fonts (Google Fonts CDN)

| Family | Use |
|---|---|
| Playfair Display (SemiBold) | logo & display headings ("CartFly", "Login", "Register") |
| Inter (Light/Regular/Medium/SemiBold) | body, labels, buttons |
| Alan Sans (Regular/Bold) | some links ("Forget password?") |
| Instrument Serif (Regular) | minor accents |

### Colors (sampled from Login frame; Phase 1 verifies/normalizes)

| Token | Hex | Use |
|---|---|---|
| `--bg-splash` | `#c5e2ff` | splash / auth background |
| `--primary` | `#2563eb` | primary blue, strong borders |
| `--btn-fill` | `#86a6ea` | filled buttons |
| `--btn-alt` | `#649dde` | secondary button |
| `--border-strong` | `#16447b` | input borders (normalized from `#16447b`/`#1026b3`) |
| `--input-bg` | `#ffffff` | input field fill |
| `--input-bg-alt` | `#f1f3f5` | disabled/alt input fill |
| `--input-border` | `#848484` | input outline |
| `--text` | `#000000` | body text |
| `--text-soft` | `#120101` | near-black text |
| `--muted` | `#64748b` | captions ("from cart to doorstep") |

### Shared components (`components.html` + classes in `design-system.css`)

- `.cf-topbar` — back chevron + "CartFly" wordmark
- `.cf-bottomnav` — Home / account / Settings bottom bar (most inner screens)
- `.cf-btn` / `.cf-btn-outline` — pill buttons (corner radius 10)
- `.cf-input` — labeled field (white fill, blue border, radius 10)
- `.cf-card` — warehouse/plan cards
- `.cf-bg` — decorative airplane/box background

## 4. Execution — 3-Phase Workflow (multi-agent)

Approved approach: **Option C — design system first, then parallel screen agents.** Runs via the Workflow tool.

### Phase 1 — Foundation (1 agent, hard barrier)
- Read global styles + sample 3–4 key frames (splash/login, warehouses, settings, a plan card) for colors, fonts, bg pattern, top bar, bottom nav.
- Write `design-system.css` + `components.html`.
- Export shared/repeated assets (logo, bg pattern, bottom-nav icons) into `assets/`.
- Nothing downstream starts until this completes.

### Phase 2 — Screens (parallel, ~8 agents × 4–5 screens)
Screens grouped by similarity so each agent reuses one mental model:
- **auth:** home(splash), login, register, welcome
- **warehouses:** warehouses, warehouse-saudi/egypt/uae/china/usa
- **main+profile:** main, my-profile, order-details
- **settings:** settings, settings-language, settings-currency, menu
- **plans:** our-plans, plan-prime/smart/basic, our-plans-3/6/7/8/9/10
- **lockers+howto:** lockers, lockers-saudi, how-it-works
- **shein+popups:** shein-checkout, shein-checkout-final, cartfly-popup-1..4
- **misc:** have-an-issue, about-us, policy

Each agent: read `design-system.css` → per screen call `get_node` (full detail) + `get_reactions` + export that screen's unique images/icons → write the `.html`. Concurrency cap ~8–10.

### Phase 3 — Wire & verify (1 agent)
- Collect every `href`, cross-check against the file list, fix broken/missing links.
- Build `index.html`.
- Confirm every screen loads `design-system.css` + Tailwind, back/bottom-nav links resolve.
- Report any screen that couldn't be cloned faithfully (missing Figma data).

## 5. Navigation

- Links pulled from Figma prototype reactions (`get_reactions`) per the user's choice (A).
- Where a button has no Figma reaction, infer by common sense (Login → main/welcome, Back → previous, bottom-nav Home/account/Settings → respective screens).
- All navigation = static `<a href="../screens/x.html">`. No JS routing.

## 6. Assets

- Full export (user choice A): raster images **and** icons exported from Figma.
- Raster (logos, flags, photos, `image-removebg-preview...`) → `assets/images/*.png`.
- Icons (`home`, `account_circle`, `Settings`, `chevron_backward`, `Arrow right-circle`) → `assets/icons/*.svg`.
- Export via Figma MCP node export / `get_screenshot`.
- Shared assets exported once in Phase 1; screen-unique assets by the owning Phase-2 agent.

## 7. Layout Fidelity

- Tailwind flex/grid flow for structure (maps to Flutter `Column`/`Row`/`Expanded`).
- Absolute positioning only for true overlaps: popups/modals over a screen, decorative background pattern (these become Flutter `Stack` legitimately).
- Accept 1–3px drift vs Figma in exchange for idiomatic, Flutter-convertible structure. This is a self-owned graduation project, not a contractual pixel match.

## 8. Risks & Limitations

- **High token cost:** 38 screens × multiple MCP calls each. Accepted by user.
- Mockup is internally inconsistent (stray hexes, overlapping duplicate text nodes); output is a **clean** clone, not bug-for-bug.
- Some frames are partial/duplicate states; screen count may shift slightly.
- Arabic text in `settings-language` renders RTL.

## 9. Acceptance

- All Page-1 screens present as `.html` files under `html/screens/`.
- Every screen loads `design-system.css` + Tailwind CDN and renders the cloned layout.
- All inter-screen links resolve (no dead `href`).
- Real exported assets present in `html/assets/` and referenced (no broken images).
- `index.html` opens and the main flow is clickable: splash → login → register → welcome → main → warehouses → detail → back.
- `design-system.css` holds one normalized token set ready to become Flutter `ThemeData`.

## 10. Out of Scope

- Figma Page 2 (separate later task).
- Flutter conversion (separate later spec).
- Any interactivity beyond navigation links (no form submission, no JS state).
- Backend / data / auth logic.
