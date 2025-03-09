import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:task_managemnt/ui/utility/assets_path.dart';

class ScreenBackground extends StatelessWidget {
  const ScreenBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SvgPicture.asset(
            width: double.maxFinite,
            height: double.maxFinite,
            fit: BoxFit.cover,
            AssetsPath.backgroundSvg
        ),
        SafeArea(
          child: Center(
            child: child,
          ),
        ),
      ],
    );
  }
}
