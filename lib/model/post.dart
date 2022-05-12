import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final caption;
  final profImage;
  final postPhotoUrl;
  final postId;
  final datePublished;
  final likes;
  final username;
  final uid;

  Post({
    required this.caption,
    required this.profImage,
    required this.postPhotoUrl,
    required this.datePublished,
    required this.likes,
    required this.postId,
    required this.uid,
    required this.username,
  });

  Map<String, dynamic> toJson() => {
        'caption': caption,
        'profImage': profImage,
        'postPhotourl': postPhotoUrl,
        'datePublished': datePublished,
        'likes': likes,
        'postid': postId,
        'uid': uid,
        'username': username,
      };

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
      caption: snapshot['caption'],
      profImage: snapshot['profImage'],
      postPhotoUrl: snapshot['postPhotoUrl'],
      datePublished: snapshot['datePublished'],
      likes: snapshot['likes'],
      uid: snapshot['uid'],
      username: snapshot['username'],
      postId: snapshot['postId'],
    );
  }
}
