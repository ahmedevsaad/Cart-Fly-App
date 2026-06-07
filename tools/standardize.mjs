// tools/standardize.mjs — enforce ONE canonical bottom nav + clean watermark using
// EXPLICIT per-screen categories (derived from tools/classify.mjs + visual checks).
import { readFileSync, writeFileSync, readdirSync } from 'fs';
import { join } from 'path';
import { JSDOM } from 'jsdom';

const dir = 'w:/cart-fly/html/screens';

// Screens that must NOT get an app bottom nav (auth / external Shein / modal popups)
const NO_NAV = new Set([
  'home.html', 'login.html', 'welcome.html', 'register.html',
  'shein-checkout.html', 'shein-checkout-final.html',
  'cartfly-popup-1.html', 'cartfly-popup-2.html', 'cartfly-popup-3.html', 'cartfly-popup-4.html',
]);

// HTML-content screens whose baked full-frame -bg.png causes duplication → replace with watermark
const SWAP_BG = new Set([
  'our-plans-6.html', 'our-plans-7.html', 'our-plans-9.html', 'our-plans-10.html',
  'menu.html', 'menu-2.html', 'order-details.html', 'main.html', 'my-profile.html',
  'plan-basic.html', 'plan-prime.html', 'plan-smart.html',
  'settings.html', 'settings-currency.html', 'settings-language.html',
  'about-us.html', 'have-an-issue.html', 'how-it-works.html', 'policy.html',
  'cartfly-popup-1.html', 'cartfly-popup-2.html', 'cartfly-popup-3.html', 'cartfly-popup-4.html',
  'register.html', 'our-plans-3.html', 'our-plans-8.html',
]);
// (every other screen keeps its image untouched)

function navHtml(doc) {
  const nav = doc.createElement('nav');
  nav.className = 'cf-bottomnav';
  nav.innerHTML = `
        <a href="main.html" class="cf-nav-item" aria-label="Home"><img src="../assets/icons/home.svg" alt=""><span>Home</span></a>
        <a href="my-profile.html" class="cf-nav-item" aria-label="Profile"><img src="../assets/icons/account_circle.svg" alt=""></a>
        <a href="menu.html" class="cf-nav-item cf-nav-menu" aria-label="Menu">&#9776;</a>
        <a href="settings.html" class="cf-nav-item" aria-label="Settings"><img src="../assets/icons/settings.svg" alt=""></a>`;
  return nav;
}

const report = [];
for (const file of readdirSync(dir).filter(f => f.endsWith('.html'))) {
  const path = join(dir, file);
  const dom = new JSDOM(readFileSync(path, 'utf8'));
  const doc = dom.window.document;
  const main = doc.querySelector('main.cf-frame') || doc.querySelector('main') || doc.body;
  const changed = [];

  // 1) remove any existing real HTML bottom nav
  doc.querySelectorAll('.cf-bottomnav').forEach(n => { n.remove(); changed.push('removed old nav'); });

  // 2) remove transparent baked-nav overlay links (empty absolute <a aria-label=Home/Profile/Menu/Settings>)
  doc.querySelectorAll('a[aria-label]').forEach(a => {
    const lbl = (a.getAttribute('aria-label') || '').toLowerCase();
    const empty = a.children.length === 0 && a.textContent.trim() === '';
    if (['home', 'profile', 'menu', 'settings'].includes(lbl) && empty) { a.remove(); changed.push('removed overlay ' + lbl); }
  });

  // 3) swap baked full-frame bg -> shared watermark (only for confirmed hybrids)
  if (SWAP_BG.has(file)) {
    const bg = [...doc.querySelectorAll('img')].find(i => /-bg\.png/.test(i.getAttribute('src') || ''));
    if (bg) bg.remove();
    if (main.tagName === 'MAIN') {
      const prev = main.getAttribute('style') || '';
      if (!/airplane_box/.test(prev)) {
        main.setAttribute('style', (prev ? prev.replace(/;?$/, ';') : '') +
          'background-image:url(../assets/pattern/airplane_box.svg);background-size:240px;background-repeat:repeat;');
      }
    }
    changed.push('bg -> watermark');
  }

  // 4) append canonical nav unless excluded
  if (!NO_NAV.has(file)) { main.appendChild(navHtml(doc)); changed.push('added canonical nav'); }

  writeFileSync(path, '<!doctype html>\n' + doc.documentElement.outerHTML + '\n');
  report.push(`${file}: ${changed.join('; ') || 'no change'}`);
}
console.log(report.join('\n'));
