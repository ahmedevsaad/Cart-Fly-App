import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../data/repositories/user_repository.dart';

class PlanProvider extends ChangeNotifier {
  PlanProvider({required this.uid, FirebaseFirestore? db, bool demo = false})
      : _demo = demo,
        _repo = demo
            ? null
            : UserRepository(
                db: db ?? FirebaseFirestore.instance, uid: uid);
  final String uid;
  final bool _demo;
  final UserRepository? _repo;

  Future<void> subscribe(String code) async {
    if (_demo) {
      notifyListeners();
      return;
    }
    try {
      await _repo!
          .setPlan(code)
          .timeout(const Duration(seconds: 6));
    } catch (_) {
      // timeout or Firestore error — non-fatal
    }
    notifyListeners();
  }
}
