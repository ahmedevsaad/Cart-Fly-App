import 'package:flutter_test/flutter_test.dart';
import 'package:cartfly/data/pricing.dart';

void main() {
  test('design example cn->eg 2.5kg electronics = 23', () {
    final r = estimate(from: 'cn', to: 'eg', weightKg: 2.5, category: 'electronics', value: 80);
    expect(r.shipping, 12.0);
    expect(r.customs, 8.0);
    expect(r.service, 3.0);
    expect(r.total, 23.0);
  });
  test('weight scales shipping', () {
    final r = estimate(from: 'cn', to: 'eg', weightKg: 5, category: 'fashion', value: 100);
    expect(r.shipping, 24.0);
    expect(r.customs, 5.0);
  });
}
