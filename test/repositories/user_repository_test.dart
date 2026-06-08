import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cartfly/data/repositories/user_repository.dart';

void main() {
  test('setPlan and setCurrency write user fields', () async {
    final db = FakeFirebaseFirestore();
    await db.collection('users').doc('u1').set({'name': 'A'});
    final repo = UserRepository(db: db, uid: 'u1');
    await repo.setPlan('prime');
    await repo.setCurrency('SAR');
    final doc = await db.collection('users').doc('u1').get();
    expect(doc.data()!['plan'], 'prime');
    expect(doc.data()!['currency'], 'SAR');
  });
}
