import 'package:eat_all_fungus/controllers/authController.dart';
import 'package:eat_all_fungus/views/metaGame/profileScreen.dart';
import 'package:flutter/material.dart';

/// This is an IconButton, mostly for Appbars
IconButton buildProfileButton(BuildContext context, {String? profileID}) {
  return IconButton(
      onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProfileScreen(
                    profileID: profileID,
                  ))),
      icon: Icon(Icons.person));
}
