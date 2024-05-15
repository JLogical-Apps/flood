import 'package:flutter/material.dart';
import 'package:style/src/action/action_item.dart';
import 'package:style/src/components/dialog/styled_dialog.dart';
import 'package:style/src/components/input/styled_menu_button.dart';
import 'package:style/src/components/misc/styled_icon.dart';
import 'package:style/src/style_build_context_extensions.dart';
import 'package:style/src/style_renderer.dart';
import 'package:style/src/styleguide.dart';

class FlatStyleMenuButtonRenderer with IsTypedStyleRenderer<StyledMenuButton> {
  @override
  Widget renderTyped(BuildContext context, StyledMenuButton component) {
    return IconButton(
      icon: StyledIcon(Icons.more_vert),
      onPressed: () {
        context.showStyledDialog(StyledDialog.actionList(context: context, actions: component.actions));
      },
    );
  }

  @override
  void modifyStyleguide(Styleguide styleguide) {
    styleguide
        .getTabByNameOrCreate('Input', icon: Icons.input)
        .getSectionByNameOrCreate('Button')
        .add(StyledMenuButton(actions: [
          ActionItem(
              titleText: 'Debug',
              descriptionText: 'Print a Debug statement',
              iconData: Icons.bug_report,
              onPerform: (context) {
                print('Hello World!');
              }),
        ]));
  }
}
