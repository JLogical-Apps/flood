import 'package:flutter/material.dart';
import 'package:style/src/components/layout/styled_container.dart';
import 'package:style/src/components/layout/styled_list.dart';
import 'package:style/src/components/misc/styled_icon.dart';
import 'package:style/src/style_build_context_extensions.dart';
import 'package:style/src/style_renderer.dart';
import 'package:style/src/styleguide.dart';

class FlatStyleIconRenderer with IsTypedStyleRenderer<StyledIcon> {
  @override
  Widget renderTyped(BuildContext context, StyledIcon component) {
    return Icon(
      component.iconData,
      color: component.color ?? context.colorPalette().foreground.getByEmphasis(component.emphasis),
      size: component.size ?? 21,
    );
  }

  @override
  void modifyStyleguide(Styleguide styleguide) {
    styleguide.getTabByNameOrCreate('Misc', icon: Icons.interests).getSectionByNameOrCreate('Icons')
      ..add(StyledList.row.centered(children: [
        StyledIcon(Icons.check, size: 30),
        StyledIcon.subtle(Icons.check, size: 30),
        StyledIcon.strong(Icons.check, size: 30),
      ]))
      ..add(StyledContainer.strong(
        child: StyledList.row.centered(children: [
          StyledIcon(Icons.check, size: 30),
          StyledIcon.subtle(Icons.check, size: 30),
          StyledIcon.strong(Icons.check, size: 30),
        ]),
      ));
  }
}
