import 'package:flutter/material.dart';
import 'package:style/src/components/layout/styled_container.dart';
import 'package:style/src/components/misc/styled_divider.dart';
import 'package:style/src/emphasis.dart';
import 'package:style/src/style_build_context_extensions.dart';
import 'package:style/src/style_renderer.dart';
import 'package:style/src/styleguide.dart';

class FlatStyleDividerRenderer with IsTypedStyleRenderer<StyledDivider> {
  @override
  Widget renderTyped(BuildContext context, StyledDivider component) {
    return Divider(
      thickness: 1.2,
      color: _getColorByEmphasis(context, component.emphasis),
    );
  }

  @override
  void modifyStyleguide(Styleguide styleguide) {
    styleguide.getPageByNameOrCreate('Misc', icon: Icons.interests).getSectionByNameOrCreate('Dividers')
      ..add(StyledDivider.subtle())
      ..add(StyledDivider())
      ..add(StyledDivider.strong())
      ..add(StyledContainer(
        child: Column(
          children: [
            StyledDivider.subtle(),
            StyledDivider(),
            StyledDivider.strong(),
          ],
        ),
      ));
  }

  Color _getColorByEmphasis(BuildContext context, Emphasis emphasis) {
    switch (emphasis) {
      case Emphasis.subtle:
        return context.colorPalette().background.regular;
      case Emphasis.regular:
        return context.colorPalette().foreground.subtle;
      case Emphasis.strong:
        return context.colorPalette().foreground.strong;
    }
  }
}
