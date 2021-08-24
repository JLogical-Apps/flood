import 'package:flutter/material.dart';
import 'package:jlogical_utils/src/style/style.dart';
import 'package:provider/provider.dart';

class StyleProvider extends StatelessWidget {
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
