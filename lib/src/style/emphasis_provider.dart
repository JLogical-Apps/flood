import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/src/style/style_context_provider.dart';

class EmphasisProvider extends StyledWidget {
  final Emphasis emphasis;
  final Widget child;

  const EmphasisProvider({Key? key, required this.emphasis, required this.child}) : super(key: key);

  const EmphasisProvider.high({Key? key, required this.child}) : emphasis = Emphasis.high;
  const EmphasisProvider.medium({Key? key, required this.child}) : emphasis = Emphasis.medium;
  const EmphasisProvider.low({Key? key, required this.child}) : emphasis = Emphasis.low;

  @override
  Widget buildStyled(BuildContext context, Style style, StyleContext styleContext) {
    return StyleContextProvider(
      styleContext: styleContext.copyWith(emphasis: emphasis),
      child: child,
    );
  }
}
