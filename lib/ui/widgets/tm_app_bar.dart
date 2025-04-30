import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:task_managemnt/ui/controlar/auth_controlar.dart';
import 'package:task_managemnt/ui/screens/onBoardingScreen/login_screen.dart';
import 'package:task_managemnt/ui/widgets/snack_bar_message.dart';

import '../screens/main_screens/profile_update_screen.dart';

class TMAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TMAppBar({super.key, this.fromProfileScreen});

  final bool? fromProfileScreen;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.green,
      leading: Padding(
        padding: const EdgeInsets.only(left: 10,top: 3,bottom: 3,right: 3),
        child: CircleAvatar(
          backgroundImage: _shouldShowImage(AuthController.userModel?.photo)
              ? MemoryImage(
                  base64Decode(AuthController.userModel?.photo ?? ''),
                )
              : null,
        ),
      ),
      title: GestureDetector(
        onTap: () {
          if (fromProfileScreen ?? false) {
            return;
          }
          _onTapProfileSection(context);
        },
        child: Row(
          children: [
            Column(
              children: [
                Text(
                  AuthController.userModel!.fullName,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white70,
                  ),
                ),
                Text(
                  AuthController.userModel?.email ?? '',
                  style: TextStyle(fontSize: 10, color: Colors.white70),
                ),
              ],
            ),
            const Spacer(),
            TextButton(
              onPressed: () {
                _onTabLogOut(context);
              },
              child: Icon(Icons.login_outlined),
            )
          ],
        ),
      ),
    );
  }
  bool _shouldShowImage(String? photo) {
    return photo != null && photo.isNotEmpty;
  }
  void _onTapProfileSection(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileUpdateScreen(),
        ),
    );
  }

  void _onTabLogOut(BuildContext context) {
    AuthController.clearUserData();
    showSnackBarMessage(context, 'Logout Successful',);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
      (route) => false,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
