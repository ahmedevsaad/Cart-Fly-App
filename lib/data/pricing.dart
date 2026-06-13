class CalcResult {
  CalcResult(this.shipping, this.customs, this.service, this.minDays, this.maxDays);
  final double shipping, customs, service;
  final int minDays, maxDays;
  double get total => shipping + customs + service;
}

const _perKg = <String, double>{
  'cn-eg': 4.8, 'us-eg': 6.0, 'ae-eg': 3.0, 'sa-eg': 2.4, 'cn-sa': 4.0,
  'us-sa': 6.4, 'cn-ae': 4.2, 'us-ae': 6.2,
  'ae-sa': 2.8, 'sa-ae': 2.8,
};
const _customsPct = <String, double>{
  'electronics': 0.10, 'fashion': 0.05, 'accessories': 0.04, 'other': 0.06,
};

CalcResult estimate({
  required String from,
  required String to,
  required double weightKg,
  required String category,
  double value = 80,
}) {
  final rate = _perKg['$from-$to'] ?? 4.8;
  final rawShip = rate * weightKg;
  final shipping = double.parse((rawShip < 5 ? 5.0 : rawShip).toStringAsFixed(2));
  final customs = double.parse(((_customsPct[category] ?? 0.06) * value).toStringAsFixed(2));
  const service = 3.0;
  return CalcResult(shipping, customs, service, 7, 10);
}
