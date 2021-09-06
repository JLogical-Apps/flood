import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

/// Loading indicator.
class StyledLoadingIndicator extends StyledWidget {
  const StyledLoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget buildStyled(BuildContext context, Style style, StyleContext styleContext) {
    return LoadingWidget(
      color: styleContext.emphasisColor,
    );
  }
}
