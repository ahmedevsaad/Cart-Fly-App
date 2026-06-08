import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../data/repositories/user_repository.dart';

class PlanProvider extends ChangeNotifier {
  PlanProvider({required this.uid, FirebaseFirestore? db})
      : _repo = UserRepository(
            db: db ?? FirebaseFirestore.instance, uid: uid);
  final String uid;
  final UserRepository _repo;

  Future<void> subscribe(String code) async {
    await _repo.setPlan(code);
    notifyListeners();
  }
}
