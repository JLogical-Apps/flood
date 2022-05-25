import 'package:flutter/material.dart';

/// A centered loading widget.
class LoadingWidget extends StatelessWidget {
  /// The color of the spinner.
  final Color? color;

  /// Whether the loading indicator is spinning.
  final bool isSpinning;

  const LoadingWidget({this.color, this.isSpinning: true});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = color ?? Theme.of(context).primaryColor;
    return Center(
      child: CircularProgressIndicator(
        value: isSpinning ? null : 1,
        valueColor: AlwaysStoppedAnimation(backgroundColor),
      ),
    );
  }
}
