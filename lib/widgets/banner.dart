import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class WikWokBanner extends StatelessWidget {
  const WikWokBanner({
    required this.src,
    super.key,
  });

  final String src;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: CachedNetworkImage(
            fadeInDuration: const Duration(milliseconds: 300),
            fadeOutDuration: const Duration(milliseconds: 300),
            fadeInCurve: Curves.easeInOut,
            fadeOutCurve: Curves.easeInOut,
            imageUrl: src,
            fit: BoxFit.cover,
            errorWidget: (context, url, error) => const Center(
              child: Icon(Icons.error),
            ),
          ),
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
    );
  }
}
