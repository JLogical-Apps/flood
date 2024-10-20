import 'package:flutter/material.dart';
import 'package:style/src/components/input/styled_menu_button.dart';
import 'package:style/src/components/layout/styled_list.dart';
import 'package:style/src/components/layout/styled_section.dart';
import 'package:style/src/components/misc/styled_icon.dart';
import 'package:style/src/components/text/styled_text.dart';
import 'package:style/src/style_renderer.dart';
import 'package:utils/utils.dart';

class FlatStyleSectionRenderer with IsTypedStyleRenderer<StyledSection> {
  @override
  Widget renderTyped(BuildContext context, StyledSection component) {
    final title = component.titleText?.mapIfNonNull((text) => StyledText.lg.display.bold(text)) ?? component.title;
    final leading = component.leadingIcon?.mapIfNonNull((icon) => StyledIcon(icon)) ?? component.leading;
    final trailing = component.trailingIcon?.mapIfNonNull((icon) => StyledIcon(icon)) ?? component.trailing;

    return StyledList.column(
      children: [
        StyledList.row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: 4),
            if (leading != null) leading,
            Expanded(child: title ?? Container()),
            if (trailing != null) trailing,
            if (component.actions.isNotEmpty) StyledMenuButton(actions: component.actions),
          ],
        ),
        ...component.children,
      ],
    );
  }
}
