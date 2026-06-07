// tools/verify.mjs — dead-link, missing-asset, and design-system wiring scan over html/
import { readFileSync, readdirSync, existsSync } from 'fs';
import { join, dirname, resolve } from 'path';

const ROOT = 'w:/cart-fly/html';
const screensDir = join(ROOT, 'screens');
const screenFiles = readdirSync(screensDir).filter(f => f.endsWith('.html'));
const screenNames = new Set(screenFiles);

const deadLinks = [];
const missingAssets = [];
const noDesignSystem = [];
const noTailwind = [];

// all html pages: index + screens
const pages = [{ dir: ROOT, file: 'index.html' }, ...screenFiles.map(f => ({ dir: screensDir, file: f }))];

for (const { dir, file } of pages) {
  const full = join(dir, file);
  if (!existsSync(full)) continue;
  const html = readFileSync(full, 'utf8');

  // dead internal .html links
  for (const m of html.matchAll(/href="(?!https?:|javascript:|#|mailto:)([^"]+\.html)"/g)) {
    const target = m[1].split('/').pop();
    if (!screenNames.has(target) && target !== 'index.html') deadLinks.push(`${file} -> ${m[1]}`);
  }

  // missing local assets (src=)
  for (const m of html.matchAll(/src="(?!https?:|data:)([^"]+)"/g)) {
    const rel = m[1];
    const abs = resolve(dir, rel);
    if (!existsSync(abs)) missingAssets.push(`${file} -> ${rel}`);
  }
  // missing local assets referenced via url() or background-image / <img> already covered; also CSS url()
  for (const m of html.matchAll(/url\((?!['"]?https?:|['"]?data:)['"]?([^'")]+)['"]?\)/g)) {
    const rel = m[1].trim();
    const abs = resolve(dir, rel);
    if (!existsSync(abs)) missingAssets.push(`${file} -> url(${rel})`);
  }

  if (file !== 'index.html') {
    if (!/design-system\.css/.test(html)) noDesignSystem.push(file);
    if (!/cdn\.tailwindcss\.com/.test(html)) noTailwind.push(file);
  }
}

const u = a => [...new Set(a)];
console.log('SCREENS:', screenFiles.length);
console.log('DEAD_LINKS:', JSON.stringify(u(deadLinks), null, 2));
console.log('MISSING_ASSETS:', JSON.stringify(u(missingAssets), null, 2));
console.log('NO_DESIGN_SYSTEM:', JSON.stringify(noDesignSystem));
console.log('NO_TAILWIND:', JSON.stringify(noTailwind));
