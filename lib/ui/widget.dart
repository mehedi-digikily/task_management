import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

class BackgroundImage extends StatelessWidget {
  final Widget child;
  const BackgroundImage({super.key, required this.child});


  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        SvgPicture.asset(
          'assets/images/background.svg',
          fit: BoxFit.cover,
        ),
        child, // Placing the child widget on top of the background
      ],
    );
  }
}
