import 'package:flutter/material.dart';
import 'package:instagram_clone_app/model/user.dart' as model;
import 'package:instagram_clone_app/providers.dart/user_provider.dart';
import 'package:instagram_clone_app/resources/firestore_methods.dart';
import 'package:instagram_clone_app/utils/colors.dart';
import 'package:instagram_clone_app/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CommentCard extends StatefulWidget {
  final snap;
  const CommentCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  bool isLikeAnimating = false;
  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 18,
        horizontal: 16,
      ).copyWith(right: 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage(widget.snap['profImage']),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(color: primaryColor),
                          children: [
                            TextSpan(
                              text: widget.snap['username'],
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: ' ${widget.snap['label']}',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat.yMMMd().format(
                            widget.snap['datePublished'].toDate(),
                          ),
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          'Likes',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          'Reply',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          LikeAnimation(
            isanimating: widget.snap['likes'].contains(user.uid),
            smallLike: true,
            child: Container(
              padding: const EdgeInsets.all(8),
              child: IconButton(
                icon: widget.snap['likes'].contains(user.uid)
                    ? const Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: 16,
                      )
                    : const Icon(Icons.favorite_border),
                onPressed: () async {
                  await FireStoreMethods().likeComment(
                    widget.snap['uid'],
                    widget.snap['postid'],
                    widget.snap['commentId'],
                    widget.snap['likes'],
                  );

                  setState(() {
                    isLikeAnimating = true;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
