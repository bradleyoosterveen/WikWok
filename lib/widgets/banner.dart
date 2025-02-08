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
          child: Image.network(
            src,
            fit: BoxFit.cover,
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF101212).withOpacity(0.76),
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
