import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String bio;
  final String username;
  final String uid;
  final String photoUrl;
  final List followers;
  final List following;

  const User({
    required this.bio,
    required this.email,
    required this.followers,
    required this.following,
    required this.photoUrl,
    required this.uid,
    required this.username,
  });

  Map<String, dynamic> toJson() => {
        'usernme': username,
        'bio': bio,
        'email': email,
        'photoUrl': photoUrl,
        'uid': uid,
        'followers': followers,
        'Following': following,
      };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
        bio: snapshot['bio'],
        email: snapshot['email'],
        followers: snapshot['followers'],
        following: snapshot['following'],
        photoUrl: snapshot['photoUrl'],
        uid: snapshot['uid'],
        username: snapshot['username']);
  }
}
