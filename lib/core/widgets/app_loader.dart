import 'package:flutter/cupertino.dart';

class AppLoader extends StatelessWidget {
  const AppLoader({
    super.key,
    this.radius = 12,
  });

  final double radius;

  @override
  Widget build(BuildContext context) {
    return CupertinoActivityIndicator(radius: radius);
  }
}
