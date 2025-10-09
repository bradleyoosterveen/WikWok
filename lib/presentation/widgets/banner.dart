import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:wikwok/presentation/widgets/cached_network_image.dart';

class WBanner extends StatelessWidget {
  const WBanner({
    required this.src,
    this.showGradient = true,
    this.fill = false,
    this.showBackground = true,
    this.shouldWrapInSafeArea = true,
    super.key,
  });

  final String src;
  final bool showGradient;
  final bool fill;
  final bool showBackground;
  final bool shouldWrapInSafeArea;

  double get _blur => 16;

  double get _opacity => 0.16;

  EdgeInsetsGeometry get _padding => fill
      ? EdgeInsets.zero
      : const EdgeInsets.symmetric(horizontal: 24).add(
          EdgeInsets.only(top: shouldWrapInSafeArea ? 64 : 0),
        );

  @override
  Widget build(BuildContext context) {
    final backgroundColor = context.theme.scaffoldStyle.backgroundColor;

    return ClipRect(
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          if (showBackground) ...[
            Positioned.fill(
              child: Opacity(
                opacity: _opacity,
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: _blur, sigmaY: _blur),
                  child: Transform.scale(
                    scale: 1.1,
                    child: WCachedNetworkImage(
                      src: src,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ],
          if (showGradient && showBackground) ...[
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      backgroundColor,
                      backgroundColor.withValues(alpha: 0),
                      backgroundColor.withValues(alpha: 0),
                      backgroundColor,
                    ],
                    stops: const [0, 0.2, 0.8, 1],
                  ),
                ),
              ),
            ),
          ],
          Positioned.fill(
            child: SafeArea(
              bottom: false,
              top: shouldWrapInSafeArea,
              child: Padding(
                padding: _padding,
                child: WCachedNetworkImage(
                  src: src,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
