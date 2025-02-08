import 'package:flutter/material.dart';

class WikWokIconButton extends StatelessWidget {
  const WikWokIconButton({
    required this.icon,
    required this.label,
    this.onPressed,
    super.key,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onPressed,
      child: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        width: 64,
        height: 64,
        padding: const EdgeInsets.all(4),
        child: Column(
          children: [
            Icon(
              icon,
              color: Theme.of(context).iconTheme.color,
              size: 24,
            ),
            Text(
              label,
            ),
          ],
        ),
      ),
    );
  }
}
