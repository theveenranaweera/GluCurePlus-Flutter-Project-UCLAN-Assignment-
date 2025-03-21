import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Handles all Firestore operations for sugar logging and user settings.
class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Save a sugar log for the current user.
  Future<void> saveSugarLog({
    required String productName,
    required double sugarAmount,
  }) async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

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

  /// Edit an existing sugar log using its document ID.
  Future<void> editSugarLog({
    required String docId,
    required String productName,
    required double sugarAmount,
  }) async {
    final User? user = FirebaseAuth.instance.currentUser;
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

  /// Delete a sugar log using its document ID.
  Future<void> deleteSugarLog({required String docId}) async {
    final User? user = FirebaseAuth.instance.currentUser;
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

  /// Delete all logs for the current user.
  Future<void> deleteAllLogs() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("User not logged in");
    }

    final logsCollection = _db
        .collection('sugarLogs')
        .doc(user.uid)
        .collection('dailyLogs');
    final snapshot = await logsCollection.get();
    final batch = _db.batch();

    for (var doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  /// Store or update the daily sugar goal for the current user.
  Future<void> setDailySugarGoal(double goal) async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("No user is logged in.");
    }

    final docRef = _db.collection('users').doc(user.uid);

    await docRef.set(
      {'dailyTarget': goal},
      SetOptions(merge: true),
    );
  }

  /// Retrieve the daily sugar goal, returning a default if none is found.
  Future<double> getDailySugarGoal() async {
    const double defaultDailyTarget = 30.0;
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("No user is logged in.");
    }

    final docRef = _db.collection('users').doc(user.uid);
    final snapshot = await docRef.get();
    if (!snapshot.exists) {
      return defaultDailyTarget;
    }
    final data = snapshot.data();
    if (data == null) {
      return defaultDailyTarget;
    }

    return (data['dailyTarget'] as num?)?.toDouble() ?? defaultDailyTarget;
  }

  /// Stream the daily sugar goal in real time.
  Stream<double> streamDailySugarGoal() {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return const Stream.empty();

    return _db
        .collection('users')
        .doc(user.uid)
        .snapshots()
        .map((snapshot) {
      final data = snapshot.data();
      return (data?['dailyTarget'] as num?)?.toDouble() ?? 30.0;
    });
  }

  /// Stream all sugar logs for the current user (include docId in each map).
  Stream<List<Map<String, dynamic>>> streamAllLogs() {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Stream.empty();
    }

    return _db
        .collection('sugarLogs')
        .doc(user.uid)
        .collection('dailyLogs')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['docId'] = doc.id;
        return data;
      }).toList();
    });
  }
}
