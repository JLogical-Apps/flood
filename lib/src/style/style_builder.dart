import 'package:flutter/material.dart';
import 'package:jlogical_utils/src/style/style.dart';
import 'package:jlogical_utils/src/style/style_context.dart';
import 'package:provider/provider.dart';

/// Builds a widget based on a [Style] and [StyleContext].
class StyleBuilder extends StatelessWidget {
  /// Widget builder that provides the [Style] and [StyleContext] found in the widget tree.
  final Widget Function(BuildContext buildContext, Style style, StyleContext styleContext) builder;

  const StyleBuilder({Key? key, required this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final style = Provider.of<Style>(context);
    final styleContext = Provider.of<StyleContext>(context);

    return builder(context, style, styleContext);
  }
}