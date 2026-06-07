# CartFly — Content-Based Navigation Plan (for review)

Derived from each screen's **actual content** (not just the Figma prototype links). Rows marked **CHANGE** differ from the current link; **NEW** adds a missing link; unmarked = already correct, kept.

## Real purpose of each screen (Figma names were misleading)
| File | Figma name | Actual content |
|---|---|---|
| our-plans-3, our-plans-8 | "our plans 3/8" | **Payment Details** (card holder / number / CVV) |
| our-plans-6, our-plans-9 | "our plans 6/9" | **Payment Error** |
| our-plans-7, our-plans-10 | "our plans 7/10" | **Payment Success** |
| menu-2 | "menu" | **Track your order** (status timeline) |
| menu | "menu" | **Shipping method** (Lockers / Home Delivery) |
| cartfly-popup-1 | popup | Widget: **warehouse address + Copy** |
| cartfly-popup-2 | popup | Widget **menu** (warehouse location / cart cost) |
| cartfly-popup-3 | popup | Widget: **cart cost calculator** |
| cartfly-popup-4 | popup | Widget: **calculation result** |
| shein-checkout(-final) | shein | External Shein site w/ CartFly widget |

---

## 1. Auth
| Screen | Element | Target | |
|---|---|---|---|
| home | Login | login.html | ✓ |
| home | Don't have an account | register.html | ✓ |
| login | Login | welcome.html | ✓ |
| login | Forget password? | (disabled — no screen exists) | keep void |
| login | Don't have an account | register.html | ✓ |
| register | Create account | welcome.html | ✓ |
| register | Back | home.html | ✓ |
| welcome | Tap to create shipment | main.html | ✓ |

## 2. Main hub
| Screen | Element | Target | |
|---|---|---|---|
| main | Order status strip ("Order Placed → Delivered") | **menu-2.html** (Track your order) | **CHANGE** (was order-details) |
| main | Our warehouses | warehouses.html | ✓ |
| main | Locker locations | lockers.html | ✓ |
| main | Subscription plans | our-plans.html | ✓ |

## 3. Warehouses
| Screen | Element | Target | |
|---|---|---|---|
| warehouses | Saudi / Egypt / UAE / USA / China flag | warehouse-<country>.html | ✓ |
| warehouses | Back | history.back() | ✓ |
| warehouse-<country> | Back | history.back() | ✓ |

## 4. Lockers
| Screen | Element | Target | |
|---|---|---|---|
| lockers (map) | Tap Saudi region | **lockers-saudi.html** | **NEW** |
| lockers (map) | Tap Egypt region | **lockers-egypt.html** | **NEW** |
| lockers (map) | Tap UAE region | **lockers-uae.html** | **NEW** |
| lockers (map) | Tap USA region | **lockers-usa.html** | **NEW** |
| lockers (map) | Tap China region | **lockers-china.html** | **NEW** |
| lockers-<country> | Back | history.back() | ✓ |

> The 5 map regions get transparent clickable overlays (the map is one image). If precise per-country hotspots are hard, fall back to a small country-name button row under the map.

## 5. Plans → Payment (the biggest content fix)
| Screen | Element | Target | |
|---|---|---|---|
| our-plans | Basic / Smart / Prime cart | plan-basic/smart/prime.html | ✓ |
| plan-basic | Subscribe now | **our-plans-3.html** (Payment Details) | **CHANGE** (was → popup-1) |
| plan-smart | Subscribe now | **our-plans-3.html** | **CHANGE** (was → popup-1) |
| plan-prime | Subscribe now | **our-plans-3.html** | **CHANGE** (was → popup-1) |
| our-plans-3 / -8 (Payment Details) | Confirm | **our-plans-7.html** (Success) | **CHANGE** (was → popup-1 / -7) |
| our-plans-6 / -9 (Payment Error) | Confirm / Try again | **our-plans-3.html** (retry) | **CHANGE** |
| our-plans-7 / -10 (Payment Success) | Confirm / Done | main.html | ✓ |
| our-plans-3..10 | Back | history.back() | ✓ |

> Canonical flow: **plan → Payment Details (3) → Confirm → Success (7) → Home**. Error screens (6/9) loop back to Payment Details. Screens 8/9/10 are duplicate states of 3/6/7 — I recommend keeping them wired identically (or deleting the duplicates later).

## 6. Order
| Screen | Element | Target | |
|---|---|---|---|
| order-details | Confirm | main.html | ✓ |
| order-details | Menu | menu.html | ✓ |
| menu-2 (Track order) | Back | history.back() | ✓ |

## 7. Settings & info
| Screen | Element | Target | |
|---|---|---|---|
| settings | Languages | settings-language.html | ✓ |
| settings | Currency | settings-currency.html | ✓ |
| settings | Edit profiles | **my-profile.html** | **CHANGE** (was void) |
| settings | Have an issue / Report a problem | have-an-issue.html | ✓ |
| settings | About us | about-us.html | ✓ |
| settings | Policy | policy.html | ✓ |
| settings | Sign out | login.html | ✓ |
| settings | Saved addresses / Change password / Notifications / Help center | (disabled — no screen) | keep void |
| settings-language / -currency | same as settings + option rows | (option rows void) | ✓ |
| about-us / have-an-issue / policy | Back | main.html | ✓ |
| my-profile | Sign out | login.html | ✓ |

## 8. Shipping method
| Screen | Element | Target | |
|---|---|---|---|
| menu | Lockers | lockers.html | ✓ |
| menu | Home Delivery | **warehouses.html** (keep) or order-details | review |
| menu | Back | history.back() | ✓ |

## 9. CartFly widget over Shein (browser-extension flow)
| Screen | Element | Target | |
|---|---|---|---|
| shein-checkout | CartFly widget button | **cartfly-popup-2.html** (widget menu) | **CHANGE** (was → popup-1) |
| cartfly-popup-2 | warehouse location | cartfly-popup-1.html | ✓ |
| cartfly-popup-2 | cart cost | cartfly-popup-3.html | ✓ |
| cartfly-popup-1 | Copy (address) | shein-checkout-final.html | ✓ |
| cartfly-popup-3 | calculate | cartfly-popup-4.html | ✓ |
| cartfly-popup-4 | Done | shein-checkout-final.html | ✓ |

---

## Summary of changes to apply
1. **main** order strip → `menu-2` (track order).
2. **lockers** map → add 5 country overlays → `lockers-<country>`.
3. **plan-basic/smart/prime** "Subscribe now" → `our-plans-3` (Payment Details).
4. **Payment flow**: Details(3/8) Confirm → Success(7); Error(6/9) Confirm → Details(3).
5. **settings** "Edit profiles" → `my-profile`.
6. **shein-checkout** widget → `cartfly-popup-2` (menu).
