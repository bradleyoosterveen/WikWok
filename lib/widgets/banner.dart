import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class WikWokBanner extends StatelessWidget {
  const WikWokBanner({
    required this.src,
    this.showGradient = true,
    super.key,
  });

  final String src;
  final bool showGradient;

  double get _blur => 8;

  double get _opacity => 0.16;

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
          Positioned.fill(
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _image(fit: BoxFit.contain),
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
