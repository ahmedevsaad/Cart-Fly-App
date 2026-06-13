import 'models/warehouse.dart';
import 'models/website_ref.dart';

const warehouses = <Warehouse>[
  Warehouse(
    code: 'sa',
    displayName: 'Saudi Arabia',
    bestFor: 'Perfumes & Beauty',
    whyBuyHere: [
      'Authentic Arabian & international perfumes',
      'Strong discounts on beauty products',
    ],
    categoriesHeading: 'Buy from Saudi Arabia',
    categories: [
      'Luxury & Arabic perfumes',
      'Makeup & skincare',
      'Fashion during sales',
    ],
    sites: [
      WebsiteRef('noon.sa'),
      WebsiteRef('amazon.sa'),
      WebsiteRef('golden-scent.com', note: 'perfumes'),
      WebsiteRef('faces.com', note: 'beauty'),
      WebsiteRef('niceonesa.com', note: 'skincare'),
    ],
  ),
  Warehouse(
    code: 'eg',
    displayName: 'Egypt',
    bestFor: 'Urgent or Local Purchases',
    whyBuyHere: ['Faster delivery', 'Easier returns & warranty'],
    categoriesHeading: 'Best websites',
    categories: [],
    sites: [
      WebsiteRef('amazon.eg'),
      WebsiteRef('noon.eg'),
      WebsiteRef('jumia.com.eg'),
      WebsiteRef('locallyeg.com'),
      WebsiteRef('gonative.eg'),
      WebsiteRef('genz-s.com'),
    ],
  ),
  Warehouse(
    code: 'ae',
    displayName: 'United Arab Emirates',
    bestFor: 'Electronics, Fashion, Perfumes & Beauty',
    whyBuyHere: [
      'Only 5% VAT',
      'Competitive electronics market',
      'Easy shipping to many countries',
    ],
    categoriesHeading: 'Buy from UAE',
    categories: [
      'Smartphones & laptops',
      'Designer clothing & shoes',
      'Original perfumes',
      'Makeup & skincare',
    ],
    sites: [
      WebsiteRef('noon.com'),
      WebsiteRef('amazon.ae'),
      WebsiteRef('sharafdg.com', note: 'electronics'),
      WebsiteRef('sephora.ae'),
      WebsiteRef('namshi.com', note: 'fashion'),
    ],
  ),
  Warehouse(
    code: 'us',
    displayName: 'USA',
    bestFor: 'Electronics & Clothing',
    whyBuyHere: [
      'Lowest global prices for tech',
      'Huge seasonal discounts (Black Friday, Back-to-School)',
      'Wide availability of global brands',
    ],
    categoriesHeading: 'Buy from USA',
    categories: [
      'Phones & laptops',
      'Apple products & gaming consoles',
      'Brand clothing & accessories',
      'Watches & gadgets',
    ],
    sites: [
      WebsiteRef('apple.com'),
      WebsiteRef('walmart.com'),
      WebsiteRef('nike.com / levis.com'),
      WebsiteRef('sephora.com'),
    ],
  ),
  Warehouse(
    code: 'cn',
    displayName: 'China',
    bestFor: 'Wholesale & Affordable Goods',
    whyBuyHere: [
      'Lowest manufacturer prices',
      'Wide variety of consumer electronics',
    ],
    categoriesHeading: 'Buy from China',
    categories: [
      'Smartphones & accessories',
      'Home gadgets',
      'Tools & wearables',
    ],
    sites: [
      WebsiteRef('aliexpress.com'),
      WebsiteRef('taobao.com'),
      WebsiteRef('jd.com'),
      WebsiteRef('tmall.com'),
    ],
  ),
];

Warehouse warehouseByCode(String code) => warehouses.firstWhere(
      (w) => w.code == code,
      orElse: () => warehouses.first,
    );
