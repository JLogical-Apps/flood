import 'package:flutter/material.dart';
import 'package:style/src/components/dialog/styled_dialog.dart';
import 'package:style/src/components/input/styled_button.dart';
import 'package:style/src/components/input/styled_menu_button.dart';
import 'package:style/src/components/layout/styled_container.dart';
import 'package:style/src/components/layout/styled_list.dart';
import 'package:style/src/components/message/styled_message.dart';
import 'package:style/src/components/text/styled_text.dart';
import 'package:style/src/style_build_context_extensions.dart';
import 'package:style/src/style_renderer.dart';
import 'package:style/src/styleguide.dart';
import 'package:utils/utils.dart';

class FlatStyleDialogRenderer with IsTypedStyleRenderer<StyledDialog> {
  @override
  Widget renderTyped(BuildContext context, StyledDialog component) {
    final title =
        component.titleText?.mapIfNonNull((title) => StyledText.lg.bold.strong.display(title)) ?? component.title;
    final body = component.bodyText?.mapIfNonNull((body) => StyledText.body(body)) ?? component.body;

    return StyledContainer(
      color: context.style().colorPalette.background.regular,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      padding: EdgeInsets.only(left: 8, top: 8, right: 8),
      child: StyledList.column.scrollable(
        children: [
          AppBar(
            title: title,
            centerTitle: true,
            foregroundColor: context.colorPalette().foreground.regular,
            backgroundColor: context.colorPalette().background.regular,
            elevation: 0,
            actions: component.actions.isEmpty
                ? null
                : [
                    StyledMenuButton(actions: component.actions),
                  ],
          ),
          if (body != null) body,
          SafeArea(child: Container()),
        ],
      ),
    );
  }

  @override
  void modifyStyleguide(Styleguide styleguide) {
    styleguide.getTabByNameOrCreate('Misc', icon: Icons.interests).getSectionByNameOrCreate('Dialogs')
      ..add(StyledDialog(
        titleText: 'Dialog Title',
        bodyText: 'Here is a body.',
      ))
      ..add(Builder(builder: (context) {
        return StyledButton(
          labelText: 'Show Dialog',
          onPressed: () {
            context.style().showDialog(
                context,
                StyledDialog(
                  titleText: 'Dialog Title',
                  bodyText: 'Here is a body.',
                ));
          },
        );
      }))
      ..add(Builder(builder: (context) {
        return StyledButton(
          labelText: 'Show Message',
          onPressed: () {
            context.style().showMessage(context, StyledMessage(labelText: 'Message Label'));
          },
        );
      }));
  }
}
