// tools/linkmap.mjs — dump each screen's interactive elements (links/buttons) + their current target
import { readFileSync, readdirSync } from 'fs';
import { join } from 'path';
import { JSDOM } from 'jsdom';

const dir = 'w:/cart-fly/html/screens';
for (const f of readdirSync(dir).filter(f => f.endsWith('.html')).sort()) {
  const doc = new JSDOM(readFileSync(join(dir, f), 'utf8')).window.document;
  const main = doc.querySelector('main') || doc.body;
  const title = (doc.querySelector('title')?.textContent || '').replace('CartFly — ', '').trim();
  const links = [];
  main.querySelectorAll('a').forEach(a => {
    // skip the canonical bottom-nav items (already standardized)
    if (a.closest('.cf-bottomnav')) return;
    const href = a.getAttribute('href') || '';
    let label = (a.getAttribute('aria-label') || a.textContent || '').replace(/\s+/g, ' ').trim();
    if (!label) label = '(empty/overlay)';
    links.push(`      • "${label}"  ->  ${href}`);
  });
  console.log(`\n### ${f}   [${title}]`);
  console.log(links.length ? links.join('\n') : '      (no interactive links besides bottom nav)');
}
