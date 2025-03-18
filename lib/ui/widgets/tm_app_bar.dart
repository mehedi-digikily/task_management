import 'package:flutter/material.dart';

import '../screens/main_screens/profile_update_screen.dart';

class TMAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TMAppBar({
    super.key,this.fromProfileScreen
  });

  final bool? fromProfileScreen;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.green,
      title: GestureDetector(
        onTap: () {
          if (fromProfileScreen ?? false) {
            return;
          }
          _onTapProfileSection(context);
        },
        child: Row(
          children: [
            CircleAvatar(
              radius: 16,
            ),
            SizedBox(
              width: 16,
            ),
            Column(
              children: [
                Text(
                  'Mehedi Hasan',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white70,
                  ),
                ),
                Text(
                  'info.itsmehedi@gmail.com',
                  style: TextStyle(fontSize: 10, color: Colors.white70),
                ),
              ],
            ),
            const Spacer(),
            TextButton(
              onPressed: () {},
              child: Icon(Icons.login_outlined),
            )
          ],
        ),
      ),
    );
  }

  void _onTapProfileSection(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileUpdateScreen(),
        ));
  }

  @override
  Size get preferredSize =>  Size.fromHeight(kToolbarHeight);
}
