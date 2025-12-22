import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import '../../models/user.dart';
import '../../models/solution_log.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? currentUserId;

  // User Id
  String? getCurrentUserId() {
    currentUserId = _auth.currentUser?.uid;
    return currentUserId;
  }

  // Update user data
  Future<void> updateUserData(Map<String, dynamic> newData) async {
    final userId = getCurrentUserId();
    if (userId == null) throw Exception("User not logged in");

    try {
      await _firestore.collection('users').doc(userId).update(newData);
    } catch (e, stack) {
      debugPrint('Error updating user data for $userId: $e');
      debugPrintStack(stackTrace: stack);
      rethrow;
    }
  }

  // Signup
  Future<AppUser> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final firebaseUser = userCredential.user!;

      final appUser = AppUser(
        id: firebaseUser.uid,
        email: firebaseUser.email ?? '',
        name: name,
        phoneNumber: phone
      );

      await _firestore.collection('users').doc(firebaseUser.uid).set(appUser.toJson());

      return appUser;
    } catch (e) {
      rethrow;
    }
  }

   // Login
  Future<AppUser> login({
    required String email,
    required String password,
  }) async {
    final userCredential = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );

    final firebaseUser = userCredential.user!;
    final doc = await _firestore.collection('users').doc(firebaseUser.uid).get();
    return AppUser.fromJson(doc.data()!);
  }



  // Load User data
  Future<AppUser?> getCurrentUserData() async {
    final userId = getCurrentUserId();
    if (userId == null) return null;

    final doc = await _firestore.collection('users').doc(userId).get();
    if (!doc.exists) return null;

    return AppUser.fromJson(doc.data()!);
  }

  // Reset Password using email link
  Future<void> sendPasswordResetEmail(String email) async {
    final cleanEmail = email.trim();

    if (cleanEmail.isEmpty) {
      throw FirebaseAuthException(
        code: 'empty-email',
        message: 'Enter email please',
      );
    }

    final query = await _firestore
        .collection('users')
        .where('email', isEqualTo: cleanEmail)
        .get();

    if (query.docs.isEmpty) {
      throw FirebaseAuthException(
        code: 'user-not-found',
        message: 'No user found with this email',
      );
    }

    // Email exists → Send password reset link
    await _auth.sendPasswordResetEmail(email: cleanEmail);
  }

  // Change password after login
  Future<void> changePassword(String newPassword) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception("No user is currently logged in.");
    }

    try {
      await user.updatePassword(newPassword);
      debugPrint("Password updated successfully!");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        throw FirebaseAuthException(
          code: e.code,
          message: "Please re-login to change your password.",
        );
      } else {
        throw e;
      }
    }
  }

  // Get Password
  // Verify current password
  Future<void> verifyCurrentPassword({
    required String email,
    required String currentPassword,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("No user is currently logged in");

    try {
      final credential = EmailAuthProvider.credential(
        email: email,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(credential);
      debugPrint("Current password verified successfully!");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        throw FirebaseAuthException(
          code: e.code,
          message: "The current password is incorrect",
        );
      } else {
        throw e;
      }
    }
  }

  // Logout
  Future<void> logout() async {
    // Sign out from Firebase Auth
    await _auth.signOut();
  }

  /// Add a solution log entry under a user
  Future<void> addSolutionLog({
    required String userId,
    required String solutionName,
    required String amount,
    required String duration,
    required DateTime loggedAt,
  }) async {
    final doc = _firestore
        .collection('users')
        .doc(userId)
        .collection('solutionLogs')
        .doc();
    final entry = SolutionLog(
      id: doc.id,
      solutionName: solutionName,
      amount: amount,
      duration: duration,
      loggedAt: loggedAt,
    );
    await doc.set(entry.toJson());
  }

  /// Get all solution logs for a user ordered by date desc
  Future<List<SolutionLog>> getSolutionLogs(String userId) async {
    final query = await _firestore
        .collection('users')
        .doc(userId)
        .collection('solutionLogs')
        .orderBy('loggedAt', descending: true)
        .get();
    return query.docs
        .map((d) => SolutionLog.fromJson(d.id, d.data()))
        .toList();
  }

  // Get points history for a user
  Future<List<Map<String, dynamic>>> getPointsHistory(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('dailyPoints')
          .get();

      // Convert to list and sort by date (descending)
      final list = querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();

      // Sort by date string in descending order (newest first)
      list.sort((a, b) {
        final dateA = a['date'] as String? ?? '';
        final dateB = b['date'] as String? ?? '';
        return dateB.compareTo(dateA); // descending order
      });

      return list;
    } catch (e) {
      debugPrint('Error getting points history: $e');
      rethrow;
    }
  }

  // Get total points for a user (sum of all daily points)
  Future<int> getTotalPoints(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('dailyPoints')
          .get();

      int totalPoints = 0;
      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        totalPoints += (data['points'] as int? ?? 0);
      }
      return totalPoints;
    } catch (e) {
      debugPrint('Error getting total points: $e');
      rethrow;
    }
  }

  // Get points for a specific date
  Future<int> getPointsForDate(String userId, String date) async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('dailyPoints')
          .doc(date)
          .get();

      if (doc.exists && doc.data() != null) {
        return (doc.data()!['points'] as int? ?? 0);
      }
      return 0;
    } catch (e) {
      debugPrint('Error getting points for date: $e');
      rethrow;
    }
  }

}
