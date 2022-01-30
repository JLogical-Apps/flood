import 'package:flutter/material.dart';
import 'package:jlogical_utils/src/style/emphasis.dart';
import 'package:jlogical_utils/src/style/style.dart';
import 'package:jlogical_utils/src/style/style_context.dart';

import '../../styled_widget.dart';
import 'action_item.dart';

class StyledMenuButton extends StyledWidget {
  /// The actions this button should provide.
  final List<ActionItem> actions;

  final Emphasis emphasis;

  const StyledMenuButton({Key? key, required this.actions, required this.emphasis}) : super(key: key);

  const StyledMenuButton.low({Key? key, required this.actions})
      : emphasis = Emphasis.low,
        super(key: key);

  const StyledMenuButton.medium({Key? key, required this.actions})
      : emphasis = Emphasis.medium,
        super(key: key);

  const StyledMenuButton.high({Key? key, required this.actions})
      : emphasis = Emphasis.high,
        super(key: key);

  @override
  Widget buildStyled(BuildContext context, Style style, StyleContext styleContext) {
    return style.menuButton(context, styleContext, this);
  }
}
