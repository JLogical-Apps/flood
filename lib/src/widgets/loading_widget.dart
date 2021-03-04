import 'package:flutter/material.dart';

/// A centered loading widget.
class LoadingWidget extends StatelessWidget {
  /// The color of the spinner.
  final Color? color;

  const LoadingWidget({this.color});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = color ?? Theme.of(context).primaryColor;
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(backgroundColor),
      ),
    );
  }
}
