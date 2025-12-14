import 'package:flutter/cupertino.dart';

class AppLoader extends StatelessWidget {
  final double radius;

  const AppLoader({
    super.key,
    this.radius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoActivityIndicator(radius: radius);
  }
}
