import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class WikWokBanner extends StatelessWidget {
  const WikWokBanner({
    required this.src,
    super.key,
  });

  final String src;

  double get _blur => 48;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          Positioned.fill(
            child: Transform.scale(
              scale: 2,
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(
                  sigmaX: _blur,
                  sigmaY: _blur,
                ),
                child: _image(fit: BoxFit.cover),
              ),
            ),
          ),
          Positioned.fill(
            child: _image(fit: BoxFit.contain),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF101212).withValues(alpha: 0.76),
                    Colors.transparent,
                    Colors.transparent,
                    const Color(0xFF101212),
                  ],
                  stops: const [0, 0.2, 0.6, 1],
                ),
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
