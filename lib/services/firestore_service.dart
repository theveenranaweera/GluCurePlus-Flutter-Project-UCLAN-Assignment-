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

  // Store or update the daily sugar goal for the current user.
  Future<void> setDailySugarGoal(double goal) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("No user is logged in.");
    }

    // We'll store user settings in a "users" collection
    final docRef = _db.collection('users').doc(user.uid);

    // Merge = true so we don't overwrite other fields if they exist
    await docRef.set(
      {'dailyTarget': goal},
      SetOptions(merge: true),
    );
  }

  // Retrieve the daily sugar goal. Return a default if none is found.
  Future<double> getDailySugarGoal() async {
    const double defaultDailyTarget = 30.0;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("No user is logged in.");
    }

    final docRef = _db.collection('users').doc(user.uid);
    final snapshot = await docRef.get();
    if (!snapshot.exists) {
      return defaultDailyTarget; // default daily target if doc doesn't exist
    }
    final data = snapshot.data();
    if (data == null) {
      return defaultDailyTarget;
    }

    // Convert the dailyTarget field to double, or default to 30 if missing
    return (data['dailyTarget'] as num?)?.toDouble() ?? defaultDailyTarget;
  }

  Stream<double> streamDailySugarGoal() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const Stream.empty();
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .snapshots()
        .map((snapshot) {
      final data = snapshot.data() as Map<String, dynamic>?;
      return (data?['dailyTarget'] as num?)?.toDouble() ?? 35.0;
    });
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