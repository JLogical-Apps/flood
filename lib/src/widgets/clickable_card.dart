import 'package:flutter/material.dart';

class ClickableCard extends StatelessWidget {
  /// Child of the card.
  final Widget child;

  /// The background color of the card.
  final Color color;

  final Color? splashColor;

  /// Callback for when it is tapped.
  final VoidCallback? onTap;

  /// The elevation of the card.
  final double elevation;

  /// The margin of the card.
  final EdgeInsets? margin;

  /// The border radius of the card. If null, defaults to circular of radius 12.
  final BorderRadius? borderRadius;

  const ClickableCard({
    required this.child,
    required this.onTap,
    this.color: Colors.white,
    this.splashColor,
    this.elevation: 0,
    this.margin,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      margin: margin,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: borderRadius ??
            ((Theme.of(context).cardTheme.shape as RoundedRectangleBorder?)?.borderRadius as BorderRadius?) ??
            BorderRadius.circular(1),
        child: child,
        onTap: onTap,
        splashColor: splashColor,
      ),
    );
  }
}
