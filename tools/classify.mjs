// tools/classify.mjs — classify each screen as HTML-content vs pure-image
import { readFileSync, readdirSync } from 'fs';
import { join } from 'path';
import { JSDOM } from 'jsdom';

const dir = 'w:/cart-fly/html/screens';
for (const f of readdirSync(dir).filter(f => f.endsWith('.html'))) {
  const dom = new JSDOM(readFileSync(join(dir, f), 'utf8'));
  const doc = dom.window.document;
  const hasBg = !![...doc.querySelectorAll('img')].find(i => /-bg\.png/.test(i.getAttribute('src') || ''));
  const hasHero = !![...doc.querySelectorAll('img')].find(i => /hero/.test(i.getAttribute('src') || ''));
  // visible text length (trim, collapse)
  const text = (doc.querySelector('main')?.textContent || '').replace(/\s+/g, ' ').trim();
  const visibleEls = [...doc.querySelectorAll('main *')].filter(e => (e.textContent || '').trim().length > 0 && !['SCRIPT','STYLE'].includes(e.tagName)).length;
  const kind = text.length > 25 ? 'HTML-CONTENT' : (hasBg || hasHero ? 'PURE-IMAGE' : 'EMPTY');
  console.log(`${kind.padEnd(13)} bg=${hasBg?'Y':'-'} hero=${hasHero?'Y':'-'} txt=${String(text.length).padStart(4)} | ${f}`);
}
