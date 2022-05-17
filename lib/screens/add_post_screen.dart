import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone_app/model/user.dart';
import 'package:instagram_clone_app/providers.dart/user_provider.dart';
import 'package:instagram_clone_app/resources/firestore_methods.dart';
import 'package:instagram_clone_app/screens/feed_screen.dart';
import 'package:instagram_clone_app/utils/utils.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  final TextEditingController _captionController = TextEditingController();
  bool _isLoading = false;

  void postImage(
    String uid,
    String username,
    String profImage,
  ) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await FireStoreMethods().uploadPost(
          _captionController.text, profImage, uid, _file!, username);
      if (res == 'success') {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(context, 'Posted');
        clearImage();
      } else {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(context, res);
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Choose an image'),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(12),
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(12),
                child: const Text('Select from gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(12),
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).getUser;
    return _file == null
        ? IconButton(
            onPressed: () => _selectImage(context),
            icon: const Icon(Icons.upload),
          )
        : Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {},
              ),
              title: const Text('Post'),
              centerTitle: false,
              actions: [
                IconButton(
                  onPressed: () {
                    postImage(user.uid, user.username, user.photoUrl);
                    // Navigator.of(context).pushReplacement(
                    //   MaterialPageRoute(
                    //     builder: (context) => const FeedScreen(),
                    //   ),
                    // );
                  },
                  icon: const Icon(
                    Icons.done,
                    color: Colors.indigoAccent,
                  ),
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(children: [
                _isLoading
                    ? const LinearProgressIndicator()
                    : const Padding(
                        padding: EdgeInsets.all(0),
                      ),
                const Divider(),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(user.photoUrl),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: TextField(
                          controller: _captionController,
                          decoration: const InputDecoration(
                              hintText: 'Write Something...',
                              border: InputBorder.none),
                          maxLines: 8,
                        ),
                      ),
                      _file == null
                          ? Container()
                          : Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: MemoryImage(_file!),
                                  fit: BoxFit.fill,
                                  alignment: FractionalOffset.topCenter,
                                ),
                              ),
                            ),
                    ]),
                const Divider(),
                TextButton(
                  onPressed: () => _selectImage(context),
                  child: const Text('Add an image'),
                ),
              ]),
            ),
          );
  }
}
