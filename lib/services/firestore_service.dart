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

  // Edit an existing sugar log using its document ID.
  Future<void> editSugarLog({
    required String docId,
    required String productName,
    required double sugarAmount,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

    await _db
        .collection('sugarLogs')
        .doc(user.uid)
        .collection('dailyLogs')
        .doc(docId)
        .update({
      'productName': productName,
      'sugarAmount': sugarAmount,
    });
  }

  // Delete a sugar log using its document ID.
  Future<void> deleteSugarLog({required String docId}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

    await _db
        .collection('sugarLogs')
        .doc(user.uid)
        .collection('dailyLogs')
        .doc(docId)
        .delete();
  }

  Future<void> deleteAllLogs() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("User not logged in");
    }
    // Reference to the dailyLogs subcollection
    final logsCollection = _db.collection('sugarLogs').doc(user.uid).collection('dailyLogs');
    final snapshot = await logsCollection.get();
    final batch = _db.batch();
    for (var doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  // Stream all sugar logs for the current user (include docId).
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
        .map((snapshot) => snapshot.docs.map((doc) {
      final data = doc.data();
      // Add document id to the map so we can reference it later.
      data['docId'] = doc.id;
      return data;
    }).toList());
  }
}