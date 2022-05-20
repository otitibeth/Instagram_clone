import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone_app/responsive/global_variable.dart';
import 'package:instagram_clone_app/screens/profile_screen.dart';
import 'package:instagram_clone_app/utils/colors.dart';
import 'package:instagram_clone_app/widgets/search_container.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool isShowUsers = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: TextFormField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search a user',
          ),
          onFieldSubmitted: (String _) {
            setState(() {
              isShowUsers = true;
            });
            ;
          },
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: isShowUsers
            ? FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .where('username',
                        isGreaterThanOrEqualTo: _searchController.text)
                    .get(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ProfileScreen(
                                  uid: snapshot.data!.docs[index]['uid'],
                                ),
                              ),
                            );
                          },
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                snapshot.data!.docs[index]['photoUrl'],
                              ),
                            ),
                            title: Text(
                              snapshot.data!.docs[index]['username'],
                            ),
                          ),
                        );
                      });
                })
            : FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('posts')
                    .orderBy('datePublished')
                    .get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return const Text('Staggered Grid View Posts');
                  // StaggeredGridView.countBuilder(
                  //   crossAxisCount: 3,
                  //   itemCount: (snapshot.data! as dynamic).docs.length,
                  //   itemBuilder: (context, index) => Image.network(
                  //     (snapshot.data! as dynamic).docs[index]['postPhotourl'],
                  //     fit: BoxFit.cover,
                  //   ),
                  //   staggeredTileBuilder: (index) => MediaQuery.of(context)
                  //               .size
                  //               .width >
                  //           webScreenSize
                  //       ? StaggeredTile.count(
                  //           (index % 7 == 0) ? 1 : 1, (index % 7 == 0) ? 1 : 1)
                  //       : StaggeredTile.count(
                  //           (index % 7 == 0) ? 2 : 1, (index % 7 == 0) ? 2 : 1),
                  //   mainAxisSpacing: 8.0,
                  //   crossAxisSpacing: 8.0,
                  // );
                },
              ),
      ),
    );
  }
}
