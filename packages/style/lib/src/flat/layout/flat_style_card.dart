import 'package:flutter/material.dart';
import 'package:style/src/color_palette.dart';
import 'package:style/src/components/input/styled_button.dart';
import 'package:style/src/components/layout/styled_card.dart';
import 'package:style/src/components/layout/styled_container.dart';
import 'package:style/src/components/layout/styled_list.dart';
import 'package:style/src/components/misc/styled_divider.dart';
import 'package:style/src/components/misc/styled_icon.dart';
import 'package:style/src/components/text/styled_text.dart';
import 'package:style/src/flat/flat_style.dart';
import 'package:style/src/style_build_context_extensions.dart';
import 'package:style/src/style_renderer.dart';
import 'package:style/src/styleguide.dart';
import 'package:tinycolor2/tinycolor2.dart';
import 'package:utils/utils.dart';

class FlatStyleCardRenderer with IsTypedStyleRenderer<StyledCard> {
  @override
  Widget renderTyped(BuildContext context, StyledCard component) {
    final title = component.titleText?.mapIfNonNull((text) => StyledText.h6(text)) ?? component.title;
    final body = component.bodyText?.mapIfNonNull((text) => StyledText.body(text)) ?? component.body;
    final leading = component.leadingIcon?.mapIfNonNull((icon) => StyledIcon(icon)) ?? component.leading;
    final trailing = component.trailingIcon?.mapIfNonNull((icon) => StyledIcon(icon)) ?? component.trailing;

    return StyledContainer(
      color: component.color,
      width: component.width,
      height: component.height,
      onPressed: component.onPressed,
      padding: component.padding,
      emphasis: component.emphasis,
      child: StyledList.column(
        children: [
          StyledList.row(
            children: [
              if (leading != null)
                Padding(
                  padding: EdgeInsets.all(6),
                  child: leading,
                ),
              Expanded(
                child: StyledList.column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (title != null) title,
                    if (body != null) body,
                  ],
                ),
              ),
              if (trailing != null)
                Padding(
                  padding: EdgeInsets.all(6),
                  child: trailing,
                ),
            ],
          ),
          if (component.children.isNotEmpty) StyledDivider.subtle(),
          ...component.children,
        ],
      ),
    );
  }

  ColorPalette getBackgroundColor(BuildContext context, {required StyledCard card}) {
    final flatStyle = context.style() as FlatStyle;

    final color = card.color;
    if (color != null) {
      if (color.opacity < 1) {
        final mixedColor = context.colorPalette().baseBackground.mix(color, (color.opacity * 100).round());
        return flatStyle.getColorPaletteFromBackground(mixedColor);
      }
      return flatStyle.getColorPaletteFromBackground(color);
    }

    return context.colorPalette().background.getByEmphasis(card.emphasis);
  }

  @override
  void modifyStyleguide(Styleguide styleguide) {
    styleguide.getTabByNameOrCreate('Containers', icon: Icons.layers_outlined).getSectionByNameOrCreate('Cards')
      ..add(StyledCard.subtle(
        titleText: 'Card Title',
        bodyText: 'Card Body',
        leadingIcon: Icons.abc,
        onPressed: () {
          print('Hello World!');
        },
        children: [
          StyledButton(
            labelText: 'CTA',
            onPressed: () {},
          ),
        ],
      ))
      ..add(StyledCard(
        titleText: 'Card Title',
        bodyText: 'Card Body',
        leadingIcon: Icons.abc,
        children: [
          StyledButton(
            labelText: 'CTA',
            onPressed: () {},
          ),
        ],
      ))
      ..add(StyledCard.strong(
        titleText: 'Card Title',
        bodyText: 'Card Body',
        leadingIcon: Icons.abc,
        children: [
          StyledButton(
            labelText: 'CTA',
            onPressed: () {},
          ),
        ],
      ));
  }
}
