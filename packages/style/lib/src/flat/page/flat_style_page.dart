import 'package:flutter/material.dart';
import 'package:style/src/components/input/styled_menu_button.dart';
import 'package:style/src/components/page/styled_page.dart';
import 'package:style/src/components/text/styled_text.dart';
import 'package:style/src/style_build_context_extensions.dart';
import 'package:style/src/style_renderer.dart';
import 'package:utils/utils.dart';

class FlatStylePageRenderer with IsTypedStyleRenderer<StyledPage> {
  @override
  Widget renderTyped(BuildContext context, StyledPage component) {
    final colorPalette = context.colorPalette();

    return WillPopScope(
      onWillPop: () async {
        return await component.shouldPop?.call() ?? true;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: component.title ?? component.titleText?.mapIfNonNull(StyledText.h2.strong),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            ...component.actionWidgets,
            if (component.actions.isNotEmpty) StyledMenuButton(actions: component.actions),
          ],
        ),
        backgroundColor: colorPalette.baseBackground,
        body: component.body,
      ),
    );
  }
}
