// tools/apply-links.mjs — apply the approved content-based navigation plan.
import { readFileSync, writeFileSync } from 'fs';
import { join } from 'path';
import { JSDOM } from 'jsdom';

const dir = 'w:/cart-fly/html/screens';
const log = [];

function edit(file, fn) {
  const path = join(dir, file);
  const dom = new JSDOM(readFileSync(path, 'utf8'));
  const doc = dom.window.document;
  fn(doc, dom.window);
  writeFileSync(path, '<!doctype html>\n' + doc.documentElement.outerHTML + '\n');
}
const findByText = (doc, re) =>
  [...doc.querySelectorAll('a')].find(a => re.test((a.textContent || '').replace(/\s+/g, ' ').trim()));
const setHref = (a, href, file, what) => { if (a) { a.setAttribute('href', href); log.push(`${file}: ${what} -> ${href}`); } else log.push(`${file}: ${what} NOT FOUND`); };

// 1) main: order-status strip -> Track your order (menu-2)
edit('main.html', doc => {
  const a = [...doc.querySelectorAll('a')].find(x => /order-details\.html$/.test(x.getAttribute('href') || ''));
  setHref(a, 'menu-2.html', 'main.html', 'order strip');
});

// 3) plan Subscribe now -> Payment Details (our-plans-3)
for (const f of ['plan-smart.html', 'plan-prime.html', 'plan-basic.html']) {
  edit(f, doc => setHref(findByText(doc, /Subscribe/i), 'our-plans-3.html', f, 'Subscribe now'));
}

// 4) payment flow
edit('our-plans-3.html', doc => setHref(findByText(doc, /^Confirm$/i), 'our-plans-7.html', 'our-plans-3.html', 'Confirm'));
edit('our-plans-8.html', doc => setHref(findByText(doc, /^Confirm$/i), 'our-plans-7.html', 'our-plans-8.html', 'Confirm'));
edit('our-plans-6.html', doc => setHref(findByText(doc, /^Confirm$/i), 'our-plans-3.html', 'our-plans-6.html', 'Confirm(retry)'));
edit('our-plans-9.html', doc => setHref(findByText(doc, /^Confirm$/i), 'our-plans-3.html', 'our-plans-9.html', 'Confirm(retry)'));
// 7/10 already -> main.html (success), leave

// 5) settings: Edit profiles -> my-profile
edit('settings.html', doc => setHref(findByText(doc, /Edit profiles/i), 'my-profile.html', 'settings.html', 'Edit profiles'));

// 6) shein-checkout widget -> widget menu (popup-2)
edit('shein-checkout.html', doc => {
  const a = findByText(doc, /cartfly/i) || [...doc.querySelectorAll('a')].find(x => /cartfly-popup-1\.html$/.test(x.getAttribute('href') || ''));
  setHref(a, 'cartfly-popup-2.html', 'shein-checkout.html', 'widget');
});

// 2) lockers: add a country button row linking to each locker page (reliable vs map hotspots)
edit('lockers.html', (doc) => {
  const main = doc.querySelector('main') || doc.body;
  const nav = main.querySelector('.cf-bottomnav');
  const row = doc.createElement('div');
  row.className = 'flex flex-wrap justify-center gap-2 px-4 mt-4';
  const countries = [
    ['Saudi Arabia', 'lockers-saudi.html'], ['Egypt', 'lockers-egypt.html'],
    ['UAE', 'lockers-uae.html'], ['USA', 'lockers-usa.html'], ['China', 'lockers-china.html'],
  ];
  row.innerHTML = countries.map(([n, h]) =>
    `<a href="${h}" class="cf-card px-3 py-2 text-sm font-medium text-[#16447b]">${n}</a>`).join('\n    ');
  if (nav) main.insertBefore(row, nav); else main.appendChild(row);
  log.push('lockers.html: added 5 country buttons -> locker pages');
});

console.log(log.join('\n'));
