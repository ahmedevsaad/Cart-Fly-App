class Plan {
  const Plan({
    required this.code,
    required this.name,
    required this.price,
    required this.features,
  });
  final String code;
  final String name;
  final String price;
  final List<String> features;
}

const plans = <Plan>[
  Plan(code: 'basic', name: 'Basic cart', price: 'Free', features: [
    'Standard shipping rates',
    'Basic support',
  ]),
  Plan(code: 'smart', name: 'Smart cart', price: '9.99 USD/per month', features: [
    'Discounted shipping',
    'Cart cost calculator',
    'Priority support',
  ]),
  Plan(code: 'prime', name: 'Prime cart', price: '19.99 USD/per month', features: [
    'Higher discount rates',
    'Discounts on liquid products',
    'Smart calculator service',
  ]),
];
