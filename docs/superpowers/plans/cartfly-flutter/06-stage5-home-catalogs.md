# Stage 5 — Home Dashboard & Static Catalogs

**Goal:** Fill the Home tab dashboard and build the warehouses (grid+detail) and lockers (map+country) screens from the existing static `data/`.

**Prereq:** Stage 4 complete.

**Files:**
- Modify: `lib/features/home/home_screen.dart`
- Create: `lib/features/warehouses/warehouses_screen.dart`, `warehouse_detail_screen.dart`
- Create: `lib/features/lockers/lockers_screen.dart`, `country_lockers_screen.dart`
- Modify: `lib/router/app_router.dart` (register pushed routes)
- Reuse: `data/warehouses.dart`, `data/lockers.dart`, models.
- Reference visuals: `html/screens/{main,warehouses,warehouse-saudi,lockers,lockers-saudi}.html`

---

### Task 5.1: Register catalog routes

**Files:** Modify `lib/router/app_router.dart` — add as top-level routes:

```dart
GoRoute(path: Routes.warehouses, builder: (_, __) => const WarehousesScreen()),
GoRoute(path: Routes.warehouseDetail,
    builder: (_, s) => WarehouseDetailScreen(code: s.pathParameters['code']!)),
GoRoute(path: Routes.lockers, builder: (_, __) => const LockersScreen()),
GoRoute(path: Routes.lockersCountry,
    builder: (_, s) => CountryLockersScreen(code: s.pathParameters['code']!)),
```

- [ ] Add + imports. Analyze (fails until screens exist; proceed).

### Task 5.2: Home dashboard

**Files:** `lib/features/home/home_screen.dart`

- [ ] **Step 1:** `CfScaffold(topBar: CfTopBar(showBack: false), body: ...)` with cards:
  - "My order" strip → `context.push(Routes.orders)` (orders list lands in Stage 6; until then push is a no-op route — register a placeholder in Stage 6).
  - `CfListRow('Our warehouses')` → `context.push(Routes.warehouses)`
  - `CfListRow('Locker locations')` → `context.push(Routes.lockers)`
  - `CfListRow('Subscription plans')` → `context.push(Routes.plans)` (Stage 7)
  - `CfButton('Create shipment')` → `context.push(Routes.createShipment)` (Stage 6)
  Use the user's name from `context.watch<AuthProvider>().state.user?.name` for a greeting.

- [ ] **Step 2: Analyze + commit.**

### Task 5.3: Warehouses grid

**Files:** `lib/features/warehouses/warehouses_screen.dart`

- [ ] **Step 1:** Title "Our warehouses", a `Wrap`/`GridView` of `CfFlagCard` for each entry in `warehouses` (`data/warehouses.dart`). Map warehouse `code` (sa/eg/ae/us/cn) → ISO code for `CfFlagCard` (`sa→SA`, etc.). `onTap` → `context.push('/warehouses/${w.code}')`.

```dart
// inside build:
Wrap(
  spacing: 16, runSpacing: 16, alignment: WrapAlignment.center,
  children: [
    for (final w in warehouses)
      CfFlagCard(
        code: w.code.toUpperCase(),
        name: w.displayName,
        onTap: () => context.push('/warehouses/${w.code}'),
      ),
  ],
)
```

- [ ] **Step 2: Analyze + commit.**

### Task 5.4: Warehouse detail

**Files:** `lib/features/warehouses/warehouse_detail_screen.dart`

- [ ] **Step 1:** Look up `warehouses.firstWhere((w) => w.code == code)`. Render flag, "Best for: {bestFor}", "Why buy here" bullets (`whyBuyHere`), categories heading + `categories` bullets, "Best websites" list (`sites` labels). `CfTopBar` back. Reference `html/screens/warehouse-saudi.html`.

- [ ] **Step 2: Analyze + commit.**

### Task 5.5: Lockers map

**Files:** `lib/features/lockers/lockers_screen.dart`

- [ ] **Step 1:** Title "our lockers locations". A row/wrap of `CfCard` country buttons (Saudi Arabia/Egypt/UAE/USA/China) → `context.push('/lockers/${code}')`. (Mirrors the fix applied in `html/screens/lockers.html`.) Optionally show a static world map image above (`assets/maps/` or a `flutter_map` centered on the region).

- [ ] **Step 2: Analyze + commit.**

### Task 5.6: Country lockers (flutter_map)

**Files:** `lib/features/lockers/country_lockers_screen.dart`

- [ ] **Step 1:** Look up the `CountryLockers` for `code` from `data/lockers.dart`. `FlutterMap` centered on `country.center`/`zoom` with OSM `TileLayer` and a `MarkerLayer` from every `Locker.coord` across `country.cities`. Below the map, a scrollable list: one section per `CityLockers` with `name – spot` rows. `CfTopBar` back.

```dart
FlutterMap(
  options: MapOptions(initialCenter: country.center, initialZoom: country.zoom),
  children: [
    TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
        userAgentPackageName: 'com.example.cartfly'),
    MarkerLayer(markers: [
      for (final city in country.cities)
        for (final l in city.lockers)
          Marker(point: l.coord, width: 40, height: 40,
              child: const Icon(Icons.location_pin, color: AppColors.primary)),
    ]),
  ],
)
```

- [ ] **Step 2:** If `data/lockers.dart` ships stub `LatLng(0,0)` entries (per the original spec), the map still renders — note any stubbed coords in the manual check and leave a `// TODO: real coords` where data is missing (data-fill, not code, is out of scope here).

- [ ] **Step 3: Analyze + commit** — `git commit -m "feat(stage5): home + warehouses + lockers"`.

---

## Stage exit check
- `flutter analyze` → No issues found.
- Home → Warehouses → a country detail renders static content; back works.
- Home → Lockers → a country shows an OSM map with pins + a city list.
- Bottom bar remains visible/consistent on Home; detail screens push over it with a back chevron.
