import 'package:flutter/material.dart';
import 'package:instagram_clone_app/screens/add_post_screen.dart';
import 'package:instagram_clone_app/screens/feed_screen.dart';
import 'package:instagram_clone_app/screens/notification_screen.dart';
import 'package:instagram_clone_app/screens/profile_screen.dart';
import 'package:instagram_clone_app/screens/search_screen.dart';

const webScreenSize = 600;

const homeScreenItems = [
  FeedScreen(),
  SearchScreen(),
  AddPostScreen(),
  NotificationScreen(),
  ProfileScreen(),
];
