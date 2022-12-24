import 'package:flutter/material.dart';
import 'package:style/src/components/page/styled_page.dart';
import 'package:style/src/components/text/styled_text.dart';
import 'package:style/src/style_build_context_extensions.dart';
import 'package:style/src/style_renderer.dart';
import 'package:utils/utils.dart';

class FlatStylePageRenderer with IsTypedStyleRenderer<StyledPage> {
  @override
  Widget renderTyped(BuildContext context, StyledPage component) {
    final colorPalette = context.colorPalette();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: component.title ?? component.titleText?.mapIfNonNull(StyledText.h1),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: colorPalette.baseBackground,
      body: component.body,
    );
  }
}
