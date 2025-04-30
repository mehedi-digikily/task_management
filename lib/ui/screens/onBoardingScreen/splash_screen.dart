
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../controlar/auth_controlar.dart';
import '../../utility/assets_path.dart';
import '../../widgets/screen_background.dart';
import '../main_screens/main_bottom_nav_screen';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _moveToNextScreen();
  }

  Future<void> _moveToNextScreen() async {
    await Future.delayed(const Duration(seconds: 2));
    final bool isLoggedIn = await AuthController.checkIfUserLoggedIn();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
        isLoggedIn ? const MainBottomNavScreen() : const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Center(
          child: SvgPicture.asset(
            AssetsPath.logoSvg,
            width: 120,
          ),
        ),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:task_managemnt/ui/controlar/auth_controlar.dart';
// import 'package:task_managemnt/ui/screens/main_screens/main_bottom_nav_screen';
//
// import '../../utility/assets_path.dart';
// import '../../widgets/screen_background.dart';
// import 'login_screen.dart';
//
//
// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});
//
//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     _moveToNextScreen();
//   }
//
//   Future<void> _moveToNextScreen() async {
//     await Future.delayed(const Duration(seconds: 2));
//
//     final bool isLoggedIn  = await AuthController.checkIfUserLoggedIn();
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//         builder: (context) => isLoggedIn  ? MainBottomNavScreen() : const LoginScreen(),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: ScreenBackground(
//         child: Center(
//           child: SvgPicture.asset(
//             AssetsPath.logoSvg,
//             width: 120,
//           ),
//         ),
//       ),
//     );
//   }
// }