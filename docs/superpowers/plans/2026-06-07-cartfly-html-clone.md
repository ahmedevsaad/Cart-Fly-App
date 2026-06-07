# CartFly Figma → HTML Clone Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Clone all 44 Figma Page-1 frames into connected static HTML + Tailwind files under `html/`, with real exported assets, ready for later Flutter conversion.

**Architecture:** A 3-phase multi-agent Workflow. Phase 1 (one agent) extracts a shared design system + shared assets. Phase 2 (~8 parallel agents) clones screens in similarity-grouped batches, each reading the design system and fetching its frames from Figma MCP (`get_node` + `get_reactions` + asset export). Phase 3 (one agent) wires links, builds `index.html`, and verifies no dead links / missing assets.

**Tech Stack:** Static HTML5, Tailwind CSS (CDN), Google Fonts CDN, Figma MCP (`figma-mcp-go`), the Workflow tool for orchestration. No build step, no JS framework.

**Verification model:** This is a static-clone task, not application logic — there are no unit tests. "Tests" = (a) file-exists checks, (b) a dead-link scanner over `html/`, (c) a missing-asset scanner, (d) manual browser click-through of the main flow.

---

## Figma Node Map (source of truth — 44 frames)

Every Phase-2 agent fetches its frames by these exact node IDs (colon format).

### Auth (batch A)
| Node ID | Figma name | Output file |
|---|---|---|
| `1:2` | Home | `screens/home.html` (splash) |
| `212:264` | Home | `screens/login.html` |
| `14:71` | Register | `screens/register.html` |
| `208:250` | Welcome | `screens/welcome.html` |

### Warehouses (batch B)
| Node ID | Figma name | Output file |
|---|---|---|
| `17:131` | warehouses | `screens/warehouses.html` |
| `30:28` | Saudi | `screens/warehouse-saudi.html` |
| `39:2` | Egypt | `screens/warehouse-egypt.html` |
| `55:29` | UAE | `screens/warehouse-uae.html` |
| `54:12` | China | `screens/warehouse-china.html` |
| `52:8` | USA | `screens/warehouse-usa.html` |

### Main + Profile (batch C)
| Node ID | Figma name | Output file |
|---|---|---|
| `207:191` | Main page | `screens/main.html` |
| `150:6` | My profile | `screens/my-profile.html` |
| `166:212` | order details | `screens/order-details.html` |

### Settings + Menu (batch D)
| Node ID | Figma name | Output file |
|---|---|---|
| `219:674` | Settings | `screens/settings.html` |
| `229:906` | Settings/language | `screens/settings-language.html` |
| `229:1049` | Settings/currency | `screens/settings-currency.html` |
| `163:13` | menu | `screens/menu.html` |
| `166:255` | menu (2nd) | `screens/menu-2.html` |

### Plans (batch E)
| Node ID | Figma name | Output file |
|---|---|---|
| `164:35` | Our plans | `screens/our-plans.html` |
| `188:67` | Prime cart | `screens/plan-prime.html` |
| `188:40` | Smart cart | `screens/plan-smart.html` |
| `184:22` | Basic cart | `screens/plan-basic.html` |
| `165:90` | our plans 3 | `screens/our-plans-3.html` |
| `195:125` | our plans 6 | `screens/our-plans-6.html` |
| `195:145` | our plans 7 | `screens/our-plans-7.html` |
| `229:814` | our plans 8 | `screens/our-plans-8.html` |
| `229:839` | our plans 9 | `screens/our-plans-9.html` |
| `229:866` | our plans 10 | `screens/our-plans-10.html` |

### Lockers + How-it-works (batch F)
| Node ID | Figma name | Output file |
|---|---|---|
| `116:46` | lockers location | `screens/lockers.html` |
| `119:11` | Saudi arabia | `screens/lockers-saudi.html` |
| `109:7` | Egypt | `screens/lockers-egypt.html` |
| `120:20` | UAE | `screens/lockers-uae.html` |
| `121:29` | China | `screens/lockers-china.html` |
| `79:86` | USA | `screens/lockers-usa.html` |
| `70:8` | How it works | `screens/how-it-works.html` |

### Shein + Popups (batch G)
| Node ID | Figma name | Output file |
|---|---|---|
| `65:6` | shein checkout page | `screens/shein-checkout.html` |
| `83:79` | shein checkout page final | `screens/shein-checkout-final.html` |
| `83:65` | cartfly popup 1 | `screens/cartfly-popup-1.html` |
| `71:16` | cartfly popup | `screens/cartfly-popup-2.html` |
| `83:95` | cartfly popup 3 | `screens/cartfly-popup-3.html` |
| `87:140` | cartfly popup 4 | `screens/cartfly-popup-4.html` |

### Misc (batch H)
| Node ID | Figma name | Output file |
|---|---|---|
| `70:17` | Have an issue | `screens/have-an-issue.html` |
| `166:288` | About us | `screens/about-us.html` |
| `166:308` | Policy 1 | `screens/policy.html` |

**Total: 44 frames → 44 screen files.**

---

## Task 1: Scaffold the `html/` skeleton

**Files:**
- Create: `html/index.html`
- Create: `html/design-system.css` (empty placeholder, filled in Task 2)
- Create: `html/components.html` (empty placeholder, filled in Task 2)
- Create dirs: `html/screens/`, `html/assets/images/`, `html/assets/icons/`

- [ ] **Step 1: Create directories**

```powershell
New-Item -ItemType Directory -Force w:\cart-fly\html\screens
New-Item -ItemType Directory -Force w:\cart-fly\html\assets\images
New-Item -ItemType Directory -Force w:\cart-fly\html\assets\icons
```

- [ ] **Step 2: Create `html/index.html`** (temporary redirect to splash; Phase 3 replaces with a real index)

```html
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta http-equiv="refresh" content="0; url=screens/home.html">
  <title>CartFly</title>
</head>
<body>
  <a href="screens/home.html">Enter CartFly</a>
</body>
</html>
```

- [ ] **Step 3: Create empty `html/design-system.css` and `html/components.html`**

```powershell
Set-Content -Encoding utf8 w:\cart-fly\html\design-system.css "/* filled in Task 2 (Phase 1) */"
Set-Content -Encoding utf8 w:\cart-fly\html\components.html "<!-- filled in Task 2 (Phase 1) -->"
```

- [ ] **Step 4: Create the screenshot helper for the verify loop**

```powershell
New-Item -ItemType Directory -Force w:\cart-fly\tools
New-Item -ItemType Directory -Force w:\cart-fly\html\.refs
```

Write `tools/shoot.mjs` (full content in Task 3a). Ensure Playwright's Chromium is available:

Run: `npx playwright install chromium`
Expected: chromium present (or already installed).

- [ ] **Step 5: Verify structure**

Run: `Get-ChildItem -Recurse w:\cart-fly\html | Select-Object FullName`
Expected: `index.html`, `design-system.css`, `components.html`, `tools/shoot.mjs`, and the asset/screen/.refs dirs exist.

---

## Task 2: Phase 1 — Foundation (design system + shared assets)

This is the Workflow's Phase 1 agent. It runs **alone** (hard barrier) before any screen agent.

**Files:**
- Modify: `html/design-system.css`
- Modify: `html/components.html`
- Create: `html/assets/images/logo.png`, `html/assets/icons/{home,account_circle,settings,chevron-back,arrow-right-circle}.svg`, background pattern asset

- [ ] **Step 1: Write the starter `design-system.css`**

The Phase-1 agent verifies these tokens against frames `1:2`, `212:264`, `17:131`, `219:674`, `188:67` and adjusts only if a token is provably wrong. Starter content:

```css
:root {
  /* colors (normalized from Figma Page 1) */
  --bg-splash: #c5e2ff;
  --bg-page: #ffffff;
  --primary: #2563eb;
  --btn-fill: #86a6ea;
  --btn-alt: #649dde;
  --border-strong: #16447b;
  --input-bg: #ffffff;
  --input-bg-alt: #f1f3f5;
  --input-border: #848484;
  --text: #000000;
  --text-soft: #120101;
  --muted: #64748b;
  --radius: 10px;
}

/* fonts */
body { font-family: 'Inter', system-ui, sans-serif; color: var(--text); }
.font-display { font-family: 'Playfair Display', serif; font-weight: 600; }
.font-accent  { font-family: 'Instrument Serif', serif; }
.font-alt     { font-family: 'Alan Sans', sans-serif; }

/* components */
.cf-frame { width: 390px; min-height: 844px; margin: 0 auto; position: relative; background: var(--bg-page); }
.cf-btn { background: var(--btn-fill); color: #fff; border-radius: var(--radius); padding: .6rem 1.2rem; text-align: center; display: inline-block; }
.cf-btn-outline { background: var(--btn-alt); border: 1px solid var(--primary); color: #fff; border-radius: var(--radius); padding: .6rem 1.2rem; }
.cf-input { width: 100%; background: var(--input-bg); border: 1px solid var(--border-strong); border-radius: var(--radius); padding: .6rem .8rem; }
.cf-card { border: 1px solid var(--border-strong); border-radius: var(--radius); background: #fff; }
.cf-topbar { display: flex; align-items: center; gap: .5rem; padding: .75rem 1rem; }
.cf-bottomnav { position: absolute; bottom: 0; left: 0; right: 0; display: flex; justify-content: space-around; align-items: center; padding: .5rem 0; background: var(--btn-fill); border-radius: 22px; margin: .5rem; }
.cf-bg { position: absolute; inset: 0; background: var(--bg-page); z-index: -1; }
```

- [ ] **Step 2: Write `components.html`** — copy-paste reference blocks every screen agent reuses

```html
<!-- TOP BAR -->
<header class="cf-topbar">
  <a href="javascript:history.back()"><img src="../assets/icons/chevron-back.svg" alt="Back" class="w-6 h-6"></a>
  <span class="font-display text-2xl mx-auto">CartFly</span>
</header>

<!-- BOTTOM NAV -->
<nav class="cf-bottomnav">
  <a href="main.html" class="flex flex-col items-center text-xs"><img src="../assets/icons/home.svg" class="w-5 h-5" alt=""><span>Home</span></a>
  <a href="my-profile.html"><img src="../assets/icons/account_circle.svg" class="w-6 h-6" alt="Profile"></a>
  <a href="settings.html" class="flex flex-col items-center text-xs"><img src="../assets/icons/settings.svg" class="w-5 h-5" alt=""><span>Settings</span></a>
</nav>

<!-- PRIMARY BUTTON -->
<a href="#" class="cf-btn font-medium">Label</a>
```

- [ ] **Step 3: Export shared assets from Figma**

Export these recurring nodes (icons as SVG, logo as PNG) into `html/assets/`:
- Logo wordmark → `assets/images/logo.png` (or rendered text — wordmark is `Playfair Display`, may stay as text)
- `chevron_backward` instance → `assets/icons/chevron-back.svg`
- `Home` icon instance → `assets/icons/home.svg`
- `account_circle` instance → `assets/icons/account_circle.svg`
- `Settings` icon instance → `assets/icons/settings.svg`
- `Arrow right-circle` instance → `assets/icons/arrow-right-circle.svg`

Use the Figma MCP export (`export_frames_to_pdf` is wrong here — use node image export via `get_screenshot`/`save_screenshots` at SVG/PNG scale, or `import_image` round-trip). If MCP image export of a single icon node is unavailable, render an equivalent inline SVG and save it to the same path. Record which icons are real exports vs redrawn.

- [ ] **Step 4: Verify**

Run: `Get-ChildItem w:\cart-fly\html\assets\icons`
Expected: the 5 icon SVGs exist. `design-system.css` contains `:root` tokens. `components.html` is non-empty.

---

## Task 3: Phase 2 — Clone screens (parallel agents)

This is the heart of the work, run as the Workflow's Phase 2. Each batch (A–H from the node map) is one agent. Every agent follows the **same per-screen procedure** below.

**Per-screen procedure (the agent prompt template):**

> For each assigned `(nodeId, outputFile)`:
> 1. `get_node(nodeId)` — full detail (text, fills, fonts, bounds, corner radius).
> 2. `get_reactions(nodeId)` and key child nodes — capture prototype navigation targets. Map each target frame's node ID to its output filename using the Node Map table. If a clickable element has no reaction, infer the link by common sense (Back→`history.back()`, bottom-nav→main/profile/settings, primary CTA→the obvious next screen).
> 3. Export this screen's **unique** images/icons (flags, photos, `image-removebg-preview*`, decorative rectangles with image fills) into `assets/images/` with descriptive names (e.g. `flag-saudi.png`).
> 4. Write `outputFile` as a complete HTML document (template below), using Tailwind utility classes + the `cf-*` component classes. Use **flex/grid flow** for layout; use `position:absolute` only for true overlaps (popups, bg pattern).
> 5. Reproduce the real text content verbatim from the node's `characters`.

**Per-screen HTML template:**

```html
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=390, initial-scale=1">
  <title>CartFly — <!-- screen name --></title>
  <script src="https://cdn.tailwindcss.com"></script>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600&family=Playfair+Display:wght@600&family=Instrument+Serif&family=Alan+Sans:wght@400;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="../design-system.css">
</head>
<body class="bg-slate-100">
  <main class="cf-frame">
    <!-- cloned content here -->
  </main>
</body>
</html>
```

**Files:** one per row in the Node Map (44 files under `html/screens/`).

**Per-screen pipeline (clone → compare → refine until visually identical):**

Each screen runs as a 2-stage pipeline so refinement happens per-screen, not at the end:

- **Stage 1 — Clone:** the batch agent runs the per-screen procedure above and writes `outputFile`.
- **Stage 2 — Verify-and-refine loop** (a *fresh* agent, max 4 passes): see Task 3a. The screen's reference Figma screenshot and its rendered HTML screenshot are diffed; the fresh agent edits the HTML to fix every visible difference; loop until the diff agent reports `match: true` (visually identical) or 4 passes are spent.

- [ ] **Step 1: Author the Workflow script** `wf-cartfly-clone.js` capturing Phases 1–3

Save via the Workflow tool's persisted script path. The script:
- Phase 1: one `agent()` call running Task 2's procedure (schema: `{designSystemWritten: bool, assetsExported: string[], notes: string}`).
- Phase 2: `pipeline()` over the 8 batches. Stage 1 = clone agent (schema: `{files: [{file, ok, links: string[], assets: string[], notes}]}`). Stage 2 = for each file in the batch, the verify-and-refine loop from Task 3a (schema: `{file, match: bool, passes: number, remainingDiffs: string[]}`).
- Phase 3: one `agent()` running Task 4's procedure (schema: `{deadLinks: string[], missingAssets: string[], indexBuilt: bool}`).

- [ ] **Step 2: Dispatch batch A and review one file before fanning out**

Run batch A (auth, 4 screens) first as a pilot — clone **and** the verify loop. Open `screens/home.html` and `screens/login.html` in a browser plus inspect their final diff screenshots. Confirm the loop actually converged to `match: true`.

- [ ] **Step 3: Dispatch batches B–H in parallel**

After batch A passes review, run the remaining 7 batches concurrently (cap ~8). Each screen self-refines via its Stage-2 loop.

- [ ] **Step 4: Verify all 44 files exist and all converged**

Run: `(Get-ChildItem w:\cart-fly\html\screens\*.html).Count`
Expected: `44`. Also confirm the Workflow result lists `match: true` for all 44 (any screen that hit the 4-pass cap without matching is flagged in `_report.md` with its `remainingDiffs`).

---

## Task 3a: Per-screen verify-and-refine loop (the fresh comparison agent)

This is the loop the user requested: after each screen finishes, a **fresh agent** compares HTML against the design and refines until visually identical.

**Reference Figma screenshots** are captured once in Phase 1 (or lazily on first compare): for each `nodeId`, call Figma MCP `get_screenshot`/`save_screenshots` → save to `html/.refs/<file>.png` (the `.refs` dir is gitignored / not shipped).

**HTML screenshot helper** — `tools/shoot.mjs` (created in Task 1, Step 5 below), renders a screen to PNG at 390px width via Playwright + Chrome:

```javascript
// tools/shoot.mjs  —  usage: node tools/shoot.mjs <htmlPath> <outPng>
import { chromium } from 'playwright';
const [, , htmlPath, outPng] = process.argv;
const browser = await chromium.launch();
const page = await browser.newPage({ viewport: { width: 390, height: 844 }, deviceScaleFactor: 2 });
await page.goto('file:///' + htmlPath.replace(/\\/g, '/'));
await page.waitForTimeout(800); // let Tailwind CDN + fonts settle
await page.screenshot({ path: outPng, fullPage: true });
await browser.close();
```

**Loop procedure (fresh agent per screen, max 4 passes):**

> Inputs: `nodeId`, `htmlFile`, `refPng = html/.refs/<file>.png`.
> Repeat up to 4 times:
> 1. `node tools/shoot.mjs <abs htmlFile> html/.refs/<file>.actual.png` — render current HTML.
> 2. Read both images (`refPng` = Figma truth, `.actual.png` = current HTML).
> 3. Compare: list every **visible** difference — wrong/missing text, wrong color, wrong font, wrong size, wrong spacing, missing element, misaligned block. Ignore sub-~3px positional drift (allowed by the visual-identical bar).
> 4. If no visible differences → return `{file, match: true, passes: <n>, remainingDiffs: []}` and stop.
> 5. Otherwise edit `htmlFile` to fix the listed differences, then loop.
> After 4 passes without a clean match → return `{file, match: false, passes: 4, remainingDiffs: [...]}`.

- [ ] **Step 1: Confirm the helper renders** (done once before the loop runs)

Run: `node w:\cart-fly\tools\shoot.mjs w:\cart-fly\html\screens\home.html w:\cart-fly\html\.refs\home.actual.png`
Expected: PNG created, no error. (Playwright 1.58 + Chrome confirmed available.)

- [ ] **Step 2: Confirm Figma reference capture works**

For one node (`1:2`), capture the Figma screenshot to `html/.refs/home.png` and confirm it's a valid PNG of the splash frame.

---

## Task 4: Phase 3 — Wire links, build index, verify

**Files:**
- Modify: `html/index.html` (real landing page)
- Create: `html/_report.md` (clone report)

- [ ] **Step 1: Build the real `index.html`** — a clickable directory of all 44 screens grouped by batch, plus a prominent "Start: Splash" link to `screens/home.html`.

- [ ] **Step 2: Dead-link scan**

Run this PowerShell scanner:

```powershell
$screens = Get-ChildItem w:\cart-fly\html\screens\*.html
$names = $screens.Name
$dead = @()
foreach ($f in $screens) {
  $html = Get-Content $f.FullName -Raw
  [regex]::Matches($html, 'href="(?!http|javascript|#)([^"]+\.html)"') | ForEach-Object {
    $target = Split-Path $_.Groups[1].Value -Leaf
    if ($names -notcontains $target) { $dead += "$($f.Name) -> $($_.Groups[1].Value)" }
  }
}
if ($dead) { $dead } else { "No dead links" }
```

Expected: `No dead links`. Fix any reported link (point it at the correct file from the Node Map, or add `history.back()` where appropriate).

- [ ] **Step 3: Missing-asset scan**

```powershell
$pages = Get-ChildItem w:\cart-fly\html -Recurse -Filter *.html
$miss = @()
foreach ($f in $pages) {
  $html = Get-Content $f.FullName -Raw
  [regex]::Matches($html, 'src="(?!http)([^"]+)"') | ForEach-Object {
    $rel = $_.Groups[1].Value
    $abs = Join-Path $f.Directory.FullName $rel
    if (-not (Test-Path $abs)) { $miss += "$($f.Name) -> $rel" }
  }
}
if ($miss) { $miss } else { "No missing assets" }
```

Expected: `No missing assets`. Fix by exporting the missing asset from Figma or correcting the path.

- [ ] **Step 4: Confirm every screen wires the design system**

```powershell
Get-ChildItem w:\cart-fly\html\screens\*.html | Where-Object {
  -not ((Get-Content $_.FullName -Raw) -match 'design-system\.css') -or
  -not ((Get-Content $_.FullName -Raw) -match 'cdn\.tailwindcss\.com')
} | Select-Object Name
```

Expected: no output (all 44 link both).

- [ ] **Step 5: Manual click-through**

Open `html/index.html` in a browser. Walk: splash → login → register → welcome → main → warehouses → warehouse-saudi → Back → bottom-nav Settings → settings-language → Back. Note any screen that renders wrong in `_report.md`.

- [ ] **Step 6: Write `_report.md`** — list each screen with status (clean / minor-drift / needs-Figma-data), which icons are real exports vs redrawn, and any frames that merged/split vs the original 44.

---

## Acceptance (from spec §9)

- [ ] All 44 frames present as `.html` under `html/screens/`.
- [ ] Every screen passed the verify-and-refine loop with `match: true` (visually identical to its Figma frame); any screen that capped at 4 passes is listed in `_report.md` with remaining diffs.
- [ ] Every screen loads `design-system.css` + Tailwind CDN and renders the cloned layout.
- [ ] Dead-link scan returns "No dead links".
- [ ] Missing-asset scan returns "No missing assets".
- [ ] `index.html` opens; main flow is clickable end-to-end.
- [ ] `design-system.css` holds one normalized token set (future Flutter `ThemeData`).
- [ ] `_report.md` documents drift, redrawn icons, and any count changes.

---

## Notes / Deviations from spec

- Spec said "~38 screens"; actual Page-1 frame count is **44** (duplicate names hid warehouse-detail vs locker-location country sets, and two `menu` frames). Spec §2 explicitly permitted the count to shift — captured here.
- Logo may remain live `Playfair Display` text rather than a PNG export if the wordmark renders cleanly; recorded in `_report.md`.
