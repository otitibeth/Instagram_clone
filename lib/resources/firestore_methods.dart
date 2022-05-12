import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone_app/model/Post.dart';
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

      _firestore.collection('posts').doc(postId).set(
            post.toJson(),
          );
      res = 'Posted!';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
