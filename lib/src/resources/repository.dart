import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quizlabsmock/src/models/basic_response.dart';
import 'package:quizlabsmock/src/resources/firestore_resources.dart';

import 'auth_resources.dart';

class Repository {
  final _authResources = AuthResources();
  final _firestoreResources = FirestoreResources();

  /// Authentication
  Stream<FirebaseUser> get onAuthStateChange => _authResources.onAuthStateChange;
  Future<FirebaseUser> get firebaseUser => _authResources.firebaseUser;
  Future<BasicResponse> loginWithEmailAndPassword(String email, String password) => _authResources.loginWithEmailAndPassword(email, password);
  Future<BasicResponse> signUpWithEmailAndPassword(String email, String password) => _authResources.signUpWithEmailAndPassword(email, password);
  Future<void> signOut() => _authResources.signOut;

  /// Firestore
  Stream<DocumentSnapshot> userDoc(String userUID) => _firestoreResources.userDoc(userUID);
  Stream<QuerySnapshot> getTenFirstRakingUsersAsc() => _firestoreResources.getTenFirstRakingUsersAsc();
  Future<void> addUserPointsAndPointsToUserGraphMap(String userUID) => _firestoreResources.addUserPointsAndPointsToUserGraphMap(userUID);
  Future<void> changeFirestoreUsername(String userUUID, String username) => _firestoreResources.changeFirestoreUsername(userUUID, username);
}