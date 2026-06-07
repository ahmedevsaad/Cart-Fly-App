import { chromium } from 'playwright';
const [,, img, out, x,y,w,h] = process.argv;
const browser = await chromium.launch();
const page = await browser.newPage();
const url='file:///'+img.replace(/\\/g,'/');
await page.goto(url);
const dim = await page.evaluate(()=>{const i=document.querySelector('img');return {w:i.naturalWidth,h:i.naturalHeight};});
if(out){
  await page.setViewportSize({width:+w,height:+h});
  await page.evaluate(([x,y])=>{const i=document.querySelector('img');i.style.position='absolute';i.style.left=(-x)+'px';i.style.top=(-y)+'px';document.body.style.margin='0';},[+x,+y]);
  await page.screenshot({path:out, clip:{x:0,y:0,width:+w,height:+h}});
}
console.log('natural', dim);
await browser.close();
