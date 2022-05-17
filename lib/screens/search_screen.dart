import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone_app/utils/colors.dart';
import 'package:instagram_clone_app/widgets/search_container.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: TextFormField(
          controller: _searchController,
          decoration: const InputDecoration(
            labelText: 'Search a user',
          ),
          onFieldSubmitted: (String _) {
            print(_);
          },
        ),
      ),
      body: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('users')
              .where('username', isGreaterThanOrEqualTo: _searchController.text)
              .get(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        snapshot.data!.docs[index]['photoUrl'],
                      ),
                    ),
                    title: Text(
                      snapshot.data!.docs[index]['username'],
                    ),
                  );
                });
          }),
    );
  }
}
