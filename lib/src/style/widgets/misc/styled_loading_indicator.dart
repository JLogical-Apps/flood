import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

/// Loading indicator.
class StyledLoadingIndicator extends StyledWidget {
  /// Color to use. Defaults to [styleContext.emphasisColor].
  final Color? color;

  const StyledLoadingIndicator({Key? key, this.color}) : super(key: key);

  @override
  Widget buildStyled(BuildContext context, Style style, StyleContext styleContext) {
    return LoadingWidget(
      color: color ?? styleContext.emphasisColor,
    );
  }
}
