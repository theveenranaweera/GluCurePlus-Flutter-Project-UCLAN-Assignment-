import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Save a sugar log for the current user.
  Future<void> saveSugarLog({
    required String productName,
    required double sugarAmount,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

    // Create a new document in firebase; sugarLogs -> user.uid -> dailyLogs
    final docRef = _db
        .collection('sugarLogs')
        .doc(user.uid)
        .collection('dailyLogs')
        .doc();

    await docRef.set({
      'productName': productName,
      'sugarAmount': sugarAmount,
    });
  }

  // Stream all sugar logs for the current user.
  Stream<List<Map<String, dynamic>>> streamAllLogs() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Return an empty stream if the user is not logged in.
      return const Stream.empty();
    }

    return _db
        .collection('sugarLogs')
        .doc(user.uid)
        .collection('dailyLogs')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }
}