import 'package:flutter/material.dart';
import 'package:jlogical_utils/src/style/style.dart';
import 'package:provider/provider.dart';

/// Provides a new [Style] its children.
class StyleProvider extends StatelessWidget {
  /// The [Style] to pass down to the children.
  final Style style;

  final Widget child;

  const StyleProvider({Key? key, required this.style, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: style,
      child: Provider.value(
        value: style.initialStyleContext,
        child: child,
      ),
    );
  }
}
