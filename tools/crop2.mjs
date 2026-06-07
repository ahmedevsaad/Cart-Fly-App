import { chromium } from 'playwright';
import { pathToFileURL } from 'url';
const [,, img, out, x, y, w, h] = process.argv;
const browser = await chromium.launch();
const page = await browser.newPage();
const url = pathToFileURL(img).href;
await page.goto(url);
const nat = await page.evaluate(() => ({ w: document.images[0].naturalWidth, h: document.images[0].naturalHeight }));
console.log('natural', JSON.stringify(nat));
if (w && h) {
  const scale = 3;
  await page.setViewportSize({ width: Math.round(nat.w * scale), height: Math.round(nat.h * scale) });
  await page.evaluate((s) => { document.body.style.margin='0'; const i = document.images[0]; i.style.width = i.naturalWidth * s + 'px'; }, scale);
  const clip = { x: +x * scale, y: +y * scale, width: +w * scale, height: +h * scale };
  await page.screenshot({ path: out, clip });
  console.log('cropped', out);
}
await browser.close();
