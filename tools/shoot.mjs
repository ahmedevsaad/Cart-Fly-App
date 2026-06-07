// tools/shoot.mjs  —  usage: node tools/shoot.mjs <htmlPath> <outPng>
// Renders an HTML screen to a PNG at 390px mobile width via Playwright + Chromium.
import { chromium } from 'playwright';

const [, , htmlPath, outPng] = process.argv;
if (!htmlPath || !outPng) {
  console.error('usage: node tools/shoot.mjs <htmlPath> <outPng>');
  process.exit(1);
}

const browser = await chromium.launch();
const page = await browser.newPage({
  viewport: { width: 390, height: 844 },
  deviceScaleFactor: 2,
});
const url = 'file:///' + htmlPath.replace(/\\/g, '/');
await page.goto(url, { waitUntil: 'networkidle' });
await page.waitForTimeout(800); // let Tailwind CDN + Google Fonts settle
await page.screenshot({ path: outPng, fullPage: true });
await browser.close();
console.log('shot ->', outPng);
