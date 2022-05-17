import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Comment {
  final label;
  final username;
  final uid;
  final profImage;
  final datePublished;
  final likes;
  final commentId;

  Comment({
    required this.label,
    required this.username,
    required this.uid,
    required this.profImage,
    required this.datePublished,
    required this.likes,
    required this.commentId,
  });

  Map<String, dynamic> toJson() => {
        'label': label,
        'username': username,
        'uid': uid,
        'profImage': profImage,
        'datePublished': datePublished,
        'likes': likes,
        'commentId': commentId
      };

  static Comment fromSnap(DocumentSnapshot snap) {
    var snapShot = snap.data() as Map<String, dynamic>;

    return Comment(
        label: snapShot['label'],
        username: snapShot['username'],
        uid: snapShot['uid'],
        profImage: snapShot['profImage'],
        datePublished: snapShot['datePublished'],
        likes: snapShot['likes'],
        commentId: snapShot['commentId']);
  }
}
