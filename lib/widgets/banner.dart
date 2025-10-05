import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

class WikWokBanner extends StatelessWidget {
  const WikWokBanner({
    required this.src,
    this.showGradient = true,
    this.fill = false,
    super.key,
  });

  final String src;
  final bool showGradient;
  final bool fill;

  double get _blur => 4;

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
                child: _image(fit: BoxFit.cover),
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
                      _backgroundColor.withValues(alpha: 0.64),
                      Colors.transparent,
                      Colors.transparent,
                      _backgroundColor,
                    ],
                    stops: const [0, 0.3, 0.7, 1],
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
                child: _image(fit: BoxFit.contain),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _image({required BoxFit fit}) => CachedNetworkImage(
        fadeInDuration: const Duration(milliseconds: 300),
        fadeOutDuration: const Duration(milliseconds: 300),
        fadeInCurve: Curves.easeInOut,
        fadeOutCurve: Curves.easeInOut,
        imageUrl: src,
        fit: fit,
        errorWidget: (context, url, error) => const Center(
          child: Icon(Icons.error),
        ),
      );
}
