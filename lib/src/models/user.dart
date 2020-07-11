import 'package:cloud_firestore/cloud_firestore.dart';

class User {

  String id;
  String username;
  int experience;
  int level;
  int points;
  int coins;
  int energy;
  Map<String, dynamic> pointsByDayGraph;

  User({
    this.id,
    this.username,
    this.experience,
    this.level,
    this.points,
    this.coins,
    this.energy,
    this.pointsByDayGraph
  });

  factory User.fromDocument(DocumentSnapshot document) {
    return User(
      id: document.documentID,
      username: document['username'],
      experience: document['experience'] != null ? document['experience'].toInt() : 0,
      level: document['level'] != null ? document['level'].toInt() : 0,
      points: document['points'] != null ? document['points'].toInt() : 0,
      coins: document['coins'] != null ? document['coins'].toInt() : 0,
      energy: document['energy'] != null ? document['energy'].toInt() : 0,
      pointsByDayGraph: document['pointsByDayGraph'],
    );
  }
}