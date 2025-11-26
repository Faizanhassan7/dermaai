import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AuthViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  bool _loading = false;
  bool get loading => _loading;

  // 🔹 User info fields
  String userName = "";
  String userEmail = "";
  String userImage = "";

  /// ✅ Load user data (for HomeScreen etc.)
  Future<void> loadUserData() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      _loading = true;
      notifyListeners();

      final doc = await _firestore.collection('users').doc(user.uid).get();

      if (doc.exists) {
        final data = doc.data();
        userName = data?['name'] ?? user.displayName ?? "User";
        userEmail = data?['email'] ?? user.email ?? "";
        userImage = data?['image'] ?? user.photoURL ?? "";
      } else {
        userName = user.displayName ?? "User";
        userEmail = user.email ?? "";
        userImage = user.photoURL ?? "";
      }
    } catch (e) {
      debugPrint("❌ loadUserData error: $e");
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  /// ✅ Email/Password Sign-Up
  Future<User?> signUp(String name, String email, String password) async {
    try {
      _loading = true;
      notifyListeners();

      final userCred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCred.user;
      if (user == null) return null;

      await user.updateDisplayName(name);
      await user.reload();

      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'name': name,
        'email': email,
        'image': '',
        'createdAt': DateTime.now(),
      });

      // 🔹 Update local data
      userName = name;
      userEmail = email;
      userImage = '';
      notifyListeners();

      debugPrint("✅ User saved to Firestore with name: $name");
      return user;
    } catch (e) {
      debugPrint("❌ Sign-up error: $e");
      throw Exception('Sign-up failed.');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  /// ✅ Email/Password Login
  Future<User?> signIn(String email, String password) async {
    try {
      _loading = true;
      notifyListeners();

      final userCred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      await loadUserData(); // 👈 user data load after login
      return userCred.user;
    } catch (e) {
      debugPrint("❌ Sign-in error: $e");
      throw Exception('Sign-in failed.');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  /// ✅ Google Sign-In (with Firestore)
  Future<UserCredential?> signInWithGoogle() async {
    try {
      _loading = true;
      notifyListeners();

      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCred = await _auth.signInWithCredential(credential);
      final user = userCred.user;
      if (user == null) return null;

      final docRef = _firestore.collection('users').doc(user.uid);
      final doc = await docRef.get();

      if (!doc.exists) {
        await docRef.set({
          'uid': user.uid,
          'name': user.displayName ?? "User",
          'email': user.email ?? "",
          'image': user.photoURL ?? "",
          'createdAt': DateTime.now(),
        });
      }

      // 🔹 Update local fields
      userName = user.displayName ?? "User";
      userEmail = user.email ?? "";
      userImage = user.photoURL ?? "";
      notifyListeners();

      return userCred;
    } catch (e) {
      debugPrint("❌ Google Sign-In error: $e");
      throw Exception('Google Sign-In failed.');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  /// ✅ Password Reset
  Future<void> sendPasswordReset(String email) async {
    try {
      _loading = true;
      notifyListeners();
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      debugPrint("❌ Password reset error: $e");
      throw Exception('Password reset failed.');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  /// ✅ Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();

    userName = "";
    userEmail = "";
    userImage = "";
    notifyListeners();

    debugPrint("👋 User signed out successfully");
  }
  // ---------------------- 🔧 Settings Logic ----------------------

  bool isDarkMode = false;
  bool notificationsEnabled = true;

  /// ✅ Load Settings (when app starts)
  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    isDarkMode = prefs.getBool('isDarkMode') ?? false;
    notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
    notifyListeners();
  }

  /// ✅ Toggle Dark Mode
  Future<void> toggleDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', value);
    isDarkMode = value;
    notifyListeners();
  }

  /// ✅ Toggle Notifications
  Future<void> toggleNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationsEnabled', value);
    notificationsEnabled = value;
    notifyListeners();
  }

}

