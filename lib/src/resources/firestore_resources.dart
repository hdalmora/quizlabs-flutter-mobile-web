import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:quizlabsmock/src/models/user.dart';

class FirestoreResources {
  Firestore _firestore = Firestore.instance;

  Stream<DocumentSnapshot> userDoc(String userUUId) => _firestore
      .collection("users")
      .document(userUUId)
      .snapshots();

  Future<void> changeFirestoreUsername(String userUUID, String username) {
    return _firestore.collection("users").document(userUUID).updateData(
        {'username': username},);
  }

  Stream<QuerySnapshot> getTenFirstRakingUsersAsc() => _firestore
      .collection("users")
      .orderBy('points', descending: true)
      .limit(12)
      .snapshots();

  Future<void> addUserPointsAndPointsToUserGraphMap(String userUUId) => _firestore
      .runTransaction((transaction) async {
        DocumentSnapshot doc = await _firestore.collection('users').document(userUUId).get();

        if (doc.data != null && doc.exists) {
          User user = User.fromDocument(doc);

          // add user points
          int currentUserPoints = user.points ?? 0;
          currentUserPoints += 25;

          // update points graph
          Map<String, dynamic> pointsByDayGraph = user.pointsByDayGraph ?? {};
          // get current day string formated
          var dateFormat = DateFormat("yy-MM-dd");
          DateTime currDt = DateTime.now();
          String todayDateFormatted = dateFormat.format(currDt);

          if(pointsByDayGraph.containsKey(todayDateFormatted)) {
            // add points
            int currentDayPoints = pointsByDayGraph[todayDateFormatted];
            pointsByDayGraph[todayDateFormatted] = currentDayPoints + 25;
          } else {
            // create key with points
            pointsByDayGraph[todayDateFormatted] = 25;
          }

          // updated user Doc
          await _firestore.collection("users").document(userUUId).updateData(
              {'points': currentUserPoints, 'pointsByDayGraph': pointsByDayGraph});
        }
  });
}