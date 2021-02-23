import 'package:flutter/material.dart';

class ClickableCard extends StatelessWidget {
  /// Child of the card.
  final Widget child;

  /// The background color of the card.
  final Color color;

  /// Callback for when it is tapped.
  final VoidCallback onTap;

  /// The elevation of the card.
  final double elevation;

  const ClickableCard({
    @required this.child,
    @required this.onTap,
    this.color: Colors.white,
    this.elevation: 0,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: InkWell(
        borderRadius: (Theme.of(context).cardTheme.shape as RoundedRectangleBorder)?.borderRadius ?? BorderRadius.circular(1),
        child: child,
        onTap: onTap,
      ),
    );
  }
}