import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:provider/provider.dart';

/// Provides a new [StyleContext] its children.
class StyleContextProvider extends StatelessWidget {
  /// The [StyleContext] to pass down to the children.
  final StyleContext styleContext;

  final Widget child;

  const StyleContextProvider({Key? key, required this.styleContext, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: styleContext,
      child: child,
    );
  }
}
