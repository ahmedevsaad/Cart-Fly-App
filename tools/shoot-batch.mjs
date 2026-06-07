// tools/shoot-batch.mjs — render many screens in ONE browser instance.
// usage: node tools/shoot-batch.mjs <screensDir> <outDir> <name1> <name2> ...
// renders <screensDir>/<name>.html -> <outDir>/<name>.actual.png
import { chromium } from 'playwright';

const [, , screensDir, outDir, ...names] = process.argv;
const browser = await chromium.launch();
const ctx = await browser.newContext({ viewport: { width: 390, height: 844 }, deviceScaleFactor: 2 });
for (const name of names) {
  const page = await ctx.newPage();
  const htmlPath = `${screensDir}/${name}.html`.replace(/\\/g, '/');
  try {
    await page.goto('file:///' + htmlPath, { waitUntil: 'networkidle', timeout: 20000 });
  } catch { /* networkidle can time out on CDN; continue to screenshot anyway */ }
  await page.waitForTimeout(700);
  await page.screenshot({ path: `${outDir}/${name}.actual.png`, fullPage: true });
  await page.close();
  console.log('shot', name);
}
await browser.close();
