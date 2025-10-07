import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:wikwok/widgets/cached_network_image.dart';

class WBanner extends StatelessWidget {
  const WBanner({
    required this.src,
    this.showGradient = true,
    this.fill = false,
    super.key,
  });

  final String src;
  final bool showGradient;
  final bool fill;

  double get _blur => 16;

  double get _opacity => 0.16;

  Color get _backgroundColor => FThemes.zinc.dark.scaffoldStyle.backgroundColor;

  EdgeInsetsGeometry get _padding => fill
      ? EdgeInsets.zero
      : const EdgeInsets.symmetric(horizontal: 24).add(
          const EdgeInsets.only(top: 64),
        );

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
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
          if (showGradient) ...[
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      _backgroundColor,
                      Colors.transparent,
                      Colors.transparent,
                      _backgroundColor,
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
              top: fill ? false : true,
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
