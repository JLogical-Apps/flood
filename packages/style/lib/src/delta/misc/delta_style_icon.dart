import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:style/src/components/layout/styled_container.dart';
import 'package:style/src/components/layout/styled_list.dart';
import 'package:style/src/components/misc/styled_icon.dart';
import 'package:style/src/style_build_context_extensions.dart';
import 'package:style/src/style_renderer.dart';
import 'package:style/src/styleguide.dart';

class DeltaStyleIconRenderer with IsTypedStyleRenderer<StyledIcon> {
  @override
  Widget renderTyped(BuildContext context, StyledIcon component) {
    var widget = _getRawIcon(component);
    if (component.backgroundColor != null) {
      widget = StyledContainer(
        color: component.backgroundColor,
        shape: CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: widget,
        ),
      );
    }
    return widget;
  }

  Widget _getRawIcon(StyledIcon component) {
    final iconData = component.iconData;
    if (iconData.fontFamily == 'MaterialIcons') {
      return Builder(
        builder: (context) {
          return Icon(
            component.iconData,
            color: component.color ?? context.colorPalette().foreground.getByEmphasis(component.emphasis),
            size: component.size ?? 21,
          );
        },
      );
    } else {
      return Builder(
        builder: (context) {
          return FaIcon(
            component.iconData,
            color: component.color ?? context.colorPalette().foreground.getByEmphasis(component.emphasis),
            size: component.size ?? 21,
          );
        },
      );
    }
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
