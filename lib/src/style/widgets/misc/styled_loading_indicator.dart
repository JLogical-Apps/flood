import 'package:flutter/material.dart';

import '../../../widgets/export.dart';
import '../../style.dart';
import '../../style_context.dart';
import '../../styled_widget.dart';

/// Loading indicator.
class StyledLoadingIndicator extends StyledWidget {
  /// Color to use. Defaults to [styleContext.emphasisColor].
  final Color? color;

  final bool isSpinning;

  const StyledLoadingIndicator({Key? key, this.color, this.isSpinning: true}) : super(key: key);

  @override
  Widget buildStyled(BuildContext context, Style style, StyleContext styleContext) {
    return LoadingWidget(
      color: color ?? styleContext.emphasisColor,
      isSpinning: isSpinning,
    );
  }
}
