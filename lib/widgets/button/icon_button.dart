import 'package:flutter/material.dart';

class WikWokIconButton extends StatelessWidget {
  const WikWokIconButton({
    required this.icon,
    this.label,
    this.onPressed,
    super.key,
  });

  final IconData icon;
  final String? label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final label = this.label;

    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: Container(
          width: 48,
          height: 48,
          padding: const EdgeInsets.all(4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Theme.of(context).iconTheme.color,
                size: 24,
              ),
              if (label != null) ...{
                Flexible(
                  child: FittedBox(
                    child: Text(
                      label,
                      style: const TextStyle().copyWith(
                        color: Theme.of(context).iconTheme.color,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              },
            ],
          ),
        ),
      ),
    );
  }
}
