import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/app_user.dart';

class UserRepository {
  UserRepository({required FirebaseFirestore db, required this.uid}) : _db = db;
  final FirebaseFirestore _db;
  final String uid;

  DocumentReference<Map<String, dynamic>> get _doc =>
      _db.collection('users').doc(uid);

  Future<AppUser> getProfile() async {
    final d = await _doc.get();
    return AppUser.fromMap(uid, d.data() ?? {});
  }

  Future<void> updateProfile({String? name, String? phone, String? country}) =>
      _doc.update({
        if (name != null) 'name': name,
        if (phone != null) 'phone': phone,
        if (country != null) 'country': country,
      });

  Future<void> setPlan(String plan) => _doc.update({'plan': plan});
  Future<void> setCurrency(String currency) => _doc.update({'currency': currency});
}
