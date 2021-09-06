import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class Dense extends StyledWidget {
  final Widget child;

  const Dense({Key? key, required this.child}) : super(key: key);

  @override
  Widget buildStyled(BuildContext context, Style style, StyleContext styleContext) {
    return StyleContextProvider(
      styleContext: styleContext.copyWith(isDense: true),
      child: child,
    );
  }
}
