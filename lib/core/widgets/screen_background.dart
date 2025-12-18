import 'package:flutter/material.dart';
import 'package:task_manager/core/constants/app_colors.dart';

class ScreenBackground extends StatelessWidget {
  const ScreenBackground({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  AppColors.backgroundTop,
                  AppColors.backgroundMid,
                  AppColors.backgroundBottom,
                ],
              ),
            ),
          ),
        ),
        const Positioned(
          top: -140,
          left: -120,
          child: _GlowBlob(
            size: 360,
            color: AppColors.glowBlueSoft,
          ),
        ),
        const Positioned(
          top: 120,
          right: -140,
          child: _GlowBlob(
            size: 340,
            color: AppColors.glowPurpleSoft,
          ),
        ),
        const Positioned(
          bottom: -160,
          left: -130,
          child: _GlowBlob(
            size: 380,
            color: AppColors.glowBlueDeep,
          ),
        ),
        Positioned.fill(child: child),
      ],
    );
  }
}

class _GlowBlob extends StatelessWidget {
  const _GlowBlob({
    required this.size,
    required this.color,
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: <Color>[
            color.withOpacity(0.55),
            color.withOpacity(0.0),
          ],
        ),
      ),
    );
  }
}
