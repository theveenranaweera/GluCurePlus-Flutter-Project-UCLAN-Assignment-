/// Handles all Firestore operations for sugar logging and user settings.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Save sugar log for a given day (specified by dateString).
  // Creates the day's doc if it doesn't exist (with dailyTarget=30 by default).
  Future<void> saveSugarLogForDay({required String productName, required double sugarAmount, required String dateString}) async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

    final docRef = _db
        .collection('sugarLogs')
        .doc(user.uid)
        .collection('dailyLogs')
        .doc(dateString); // The doc for that day

    // If it doesn't exist, create it with default daily target = 30
    // You can decide whether to auto-create or not.
    await docRef.set({'dailyTarget': 30.0}, SetOptions(merge: true));

    // Now add a new log inside `logs` subcollection
    final logsCollection = docRef.collection('logs');
    await logsCollection.add({
      'productName': productName,
      'sugarAmount': sugarAmount,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Streams the sugar logs for a specific date (e.g. "2025-03-25").
  Stream<List<Map<String, dynamic>>> streamLogsForDay(String dateString) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Stream.empty();
    }

    return _db
        .collection('sugarLogs')
        .doc(user.uid)
        .collection('dailyLogs')
        .doc(dateString)
        .collection('logs')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['docId'] = doc.id;
        return data;
      }).toList();
    });
  }

  // Edit a single sugar log record for the given date/doc ID.
  Future<void> editSugarLogForDay({required String dateString, required String docId, required String productName, required double sugarAmount}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

    final logRef = _db
        .collection('sugarLogs')
        .doc(user.uid)
        .collection('dailyLogs')
        .doc(dateString)
        .collection('logs')
        .doc(docId);

    await logRef.update({
      'productName': productName,
      'sugarAmount': sugarAmount,
    });
  }

  // Delete a single sugar log for the specified date/doc ID.
  Future<void> deleteSugarLogForDay({required String dateString, required String docId}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

    await _db
        .collection('sugarLogs')
        .doc(user.uid)
        .collection('dailyLogs')
        .doc(dateString)
        .collection('logs')
        .doc(docId)
        .delete();
  }

  // Get all existing date docs for the user (e.g. ["2025-03-24", "2025-03-25"]).
  Future<List<String>> getAvailableDates() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return [];
    }
    final querySnapshot = await _db
        .collection('sugarLogs')
        .doc(user.uid)
        .collection('dailyLogs')
        .get();
    // Return the doc IDs (e.g. "2025-03-24", "2025-03-25")
    return querySnapshot.docs.map((doc) {
      return doc.id;
    }).toList();
  }

  // Streams the daily sugar goal for today's date.
  Stream<double> streamDailySugarGoal() {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Stream.value(30.0);
    }

    final String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return _db
        .collection('sugarLogs')
        .doc(user.uid)
        .collection('dailyLogs')
        .doc(today)
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists) {
        return 30.0; // If the document doesn’t exist yet, default to 30g.
      }
      final data = snapshot.data();
      return (data?['dailyTarget'] as num?)?.toDouble() ?? 30.0;
    });
  }

  // Gets today's daily sugar goal, defaulting to 30 if no doc exists yet.
  Future<double> getDailySugarGoal() async {
    final String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("No user is logged in.");
    }
    final docRef = _db
        .collection('sugarLogs')
        .doc(user.uid)
        .collection('dailyLogs')
        .doc(today);
    final snapshot = await docRef.get();
    if (!snapshot.exists) {
      return 30.0;
    }
    final data = snapshot.data();
    return (data?['dailyTarget'] as num?)?.toDouble() ?? 30.0;
  }

  // Sets today's daily sugar goal, creating the doc if necessary.
  Future<void> setDailySugarGoal(double goal) async {
    final String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("No user is logged in.");
    }
    final docRef = _db
        .collection('sugarLogs')
        .doc(user.uid)
        .collection('dailyLogs')
        .doc(today);

    await docRef.set({'dailyTarget': goal}, SetOptions(merge: true));
  }

  // Deletes all logs for the given date, leaving the dailyLogs doc itself intact.
  Future<void> deleteAllLogsForDay(String dateString) async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("User not logged in");
    }
    final logsCollection = _db
        .collection('sugarLogs')
        .doc(user.uid)
        .collection('dailyLogs')
        .doc(dateString)
        .collection('logs');

    final snapshot = await logsCollection.get();
    final batch = _db.batch();

    for (var doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }
}