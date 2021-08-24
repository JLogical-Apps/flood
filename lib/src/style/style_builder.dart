import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:provider/provider.dart';

class StyleBuilder extends StatelessWidget {
  final Widget Function(BuildContext buildContext, Style style, StyleContext styleContext) builder;

  const StyleBuilder({Key? key, required this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final style = Provider.of<Style>(context);
    final styleContext = Provider.of<StyleContext>(context);

    return builder(context, style, styleContext);
  }
}
