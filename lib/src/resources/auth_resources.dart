import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faker/faker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:quizlabsmock/src/models/basic_response.dart';

class AuthResponse {
  static const ERROR_INVALID_EMAIL = "auth/invalid-email";
  static const ERROR_WRONG_PASSWORD = "auth/wrong-password";
  static const ERROR_USER_NOT_FOUND = "auth/user-not-found";
  static const ERROR_USER_DISABLED = "auth/user-disabled";
  static const ERROR_TOO_MANY_REQUESTS = "auth/too-many-requests";
  static const ERROR_OPERATION_NOT_ALLOWED = "auth/operation-not-allowed";
  static const ERROR_WEAK_PASSWORD = "auth/weak-password";
  static const ERROR_EMAIL_ALREADY_IN_USE = "auth/email-already-in-use";
}

class AuthResources {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;

  Stream<FirebaseUser> get onAuthStateChange => _firebaseAuth.onAuthStateChanged;

  Future<BasicResponse> loginWithEmailAndPassword(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);


      return BasicResponse(success: true, message: "auth_success");
    } catch (e) {
      print("Exception: Error: " + e.toString());

      switch(e.code) {
        case AuthResponse.ERROR_INVALID_EMAIL:
          return BasicResponse(success: false, message: "auth_failed_invalid_email");
        case AuthResponse.ERROR_WRONG_PASSWORD:
          return BasicResponse(success: false, message: "auth_failed_wrong_password");
        case AuthResponse.ERROR_USER_NOT_FOUND:
          return BasicResponse(success: false, message: "auth_failed_user_not_found");
        case AuthResponse.ERROR_USER_DISABLED:
          return BasicResponse(success: false, message: "auth_failed_user_disabled");
        case AuthResponse.ERROR_TOO_MANY_REQUESTS:
          return BasicResponse(success: false, message: "auth_failed_too_many_requests");
        case AuthResponse.ERROR_OPERATION_NOT_ALLOWED:
          return BasicResponse(success: false, message: "auth_failed_operation_not_allowed");
        default:
          return BasicResponse(success: false, message: "unknown_error_auth");
      }
    }
  }

  Future<BasicResponse> signUpWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult authResult = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);

      var faker = new Faker();

      String displayName = faker.internet.userName();

      await setUserDisplayName(authResult.user, displayName);
      await createUserProfile(authResult.user, displayName);

      return BasicResponse(success: true, message: "auth_success");
    } catch (e) {
      print("Exception: Authentication: " + e.code);

      switch(e.code) {
        case AuthResponse.ERROR_WEAK_PASSWORD:
          return BasicResponse(success: false, message: "auth_failed_weak_password");
        case AuthResponse.ERROR_INVALID_EMAIL:
          return BasicResponse(success: false, message: "auth_failed_invalid_email");
        case AuthResponse.ERROR_EMAIL_ALREADY_IN_USE:
          return BasicResponse(success: false, message: "auth_failed_email_already_in_use");
        default:
          return BasicResponse(success: false, message: "unknown_error_auth");
      }
    }
  }

  Future<void> setUserDisplayName(FirebaseUser user, String displayName) async {
    UserUpdateInfo updateInfo = UserUpdateInfo();
    updateInfo.displayName = displayName;
    await user.updateProfile(updateInfo);
  }

  Future<void> createUserProfile(FirebaseUser user, String displayName) => _firestore
      .collection("users")
      .document(user.uid)
      .setData({
    'id': user.uid,
    'username': displayName != null ? displayName : user.displayName,
    'experience': 0,
    'level': 1,
    'points': 0,
    'energy': 0,
    'coins': 0
  });

  Future<void> get signOut async {
    _firebaseAuth.signOut();
  }
}