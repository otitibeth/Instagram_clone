import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone_app/model/Post.dart';
import 'package:instagram_clone_app/model/comment.dart';
import 'package:instagram_clone_app/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // upload post
  Future<String> uploadPost(
    String caption,
    String profImage,
    String uid,
    Uint8List file,
    String username,
  ) async {
    String res = 'some error ocurred';
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);

      String postId = const Uuid().v1();
      Post post = Post(
        caption: caption,
        profImage: profImage,
        postPhotoUrl: photoUrl,
        datePublished: DateTime.now(),
        postId: postId,
        uid: uid,
        username: username,
        likes: [],
      );

      await _firestore.collection('posts').doc(postId).set(
            post.toJson(),
          );
      res = 'Posted!';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> likePost(String uid, String postId, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update(
          {
            'likes': FieldValue.arrayRemove([uid]),
          },
        );
      } else {
        await _firestore.collection('posts').doc(postId).update(
          {
            'likes': FieldValue.arrayUnion([uid]),
          },
        );
      }
    } catch (e) {
      print(
        e.toString(),
      );
    }
  }

  // upload comment
  Future<String> uploadComment(
    String text,
    String postId,
    String username,
    String profImage,
    String uid,
  ) async {
    String res = 'Some error occured';

    if (text.isNotEmpty) {
      try {
        if (text.isNotEmpty) {
          String commentId = const Uuid().v1();

          Comment comment = Comment(
              label: text,
              username: username,
              uid: uid,
              likes: [],
              profImage: profImage,
              datePublished: DateTime.now(),
              commentId: commentId);

          await _firestore
              .collection('posts')
              .doc(postId)
              .collection('comments')
              .doc(commentId)
              .set(comment.toJson());
          //       {
          //   'profilePic': profImage,
          //   'text': text,
          //   'username': username,
          //   'uid': uid,
          //   'commentId': commentId,
          //   'datePublished': DateTime.now(),
          // });

          res = 'comment added';
        } else {
          res = 'comment is empty';
        }
      } catch (e) {
        print(
          e.toString(),
        );
      }
    }
    return res;
  }

  Future<void> likeComment(
      String uid, String postId, String commentId, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc('commentId')
            .update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        await _firestore
            .collection('posts')
            .doc('postId')
            .collection('comments')
            .doc(commentId)
            .update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> followUser(String uid, String followerId) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(followerId)) {
        await _firestore.collection('users').doc(followerId).update({
          'followers': FieldValue.arrayRemove([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followerId])
        });
      } else {
        await _firestore.collection('users').doc(followerId).update({
          'followers': FieldValue.arrayUnion([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followerId])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
