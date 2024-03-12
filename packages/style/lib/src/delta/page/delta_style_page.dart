import 'package:flutter/material.dart';
import 'package:style/src/components/input/styled_menu_button.dart';
import 'package:style/src/components/page/styled_page.dart';
import 'package:style/src/components/text/styled_text.dart';
import 'package:style/src/style_build_context_extensions.dart';
import 'package:style/src/style_renderer.dart';
import 'package:utils/utils.dart';

class DeltaStylePageRenderer with IsTypedStyleRenderer<StyledPage> {
  @override
  Widget renderTyped(BuildContext context, StyledPage component) {
    final colorPalette = context.colorPalette();

    return PopScope(
      canPop: component.onShouldPop == null,
      onPopInvoked: component.onShouldPop == null
          ? null
          : (_) async {
              final shouldPop = await component.onShouldPop!();
              if (shouldPop) {
                Navigator.of(context).pop();
              }
            },
      child: Scaffold(
        appBar: component.title == null &&
                component.titleText == null &&
                component.actionWidgets.isEmpty &&
                component.actions.isEmpty
            ? null
            : AppBar(
                foregroundColor: context.colorPalette().foreground.regular,
                centerTitle: true,
                title: component.title ?? component.titleText?.mapIfNonNull(StyledText.xl.bold.display),
                backgroundColor: Colors.transparent,
                elevation: 0,
                scrolledUnderElevation: 0,
                actions: [
                  ...component.actionWidgets,
                  if (component.actions.isNotEmpty) StyledMenuButton(actions: component.actions),
                ],
              ),
        backgroundColor: colorPalette.baseBackground,
        body: Padding(padding: component.innerPadding, child: component.body),
      ),
    );
  }
}