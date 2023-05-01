import 'package:flutter/material.dart';
import 'package:style/src/emphasis.dart';
import 'package:style/src/style_renderer.dart';
import 'package:style/style.dart';
import 'package:utils/utils.dart';

class FlatStyleCardRenderer with IsTypedStyleRenderer<StyledCard> {
  @override
  Widget renderTyped(BuildContext context, StyledCard component) {
    final title = component.titleText?.mapIfNonNull((text) => StyledText.h6.strong(text)) ?? component.title;
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
      shape: component.emphasis != Emphasis.subtle
          ? null
          : RoundedRectangleBorder(
              side: BorderSide(
                color: context.colorPalette().background.regular,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
      child: Padding(
        padding: EdgeInsets.all(4),
        child: StyledList.column(
          children: [
            if (leading != null || title != null || body != null)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: StyledList.row(
                  children: [
                    if (leading != null)
                      Padding(
                        padding: EdgeInsets.all(6),
                        child: leading,
                      ),
                    Expanded(
                      child: Padding(
                        padding: title != null || body != null ? const EdgeInsets.all(4) : EdgeInsets.zero,
                        child: StyledList.column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (title != null) title,
                            if (body != null) body,
                          ],
                        ),
                      ),
                    ),
                    if (trailing != null)
                      Padding(
                        padding: EdgeInsets.all(6),
                        child: trailing,
                      ),
                    if (component.actions.isNotEmpty) StyledMenuButton(actions: component.actions),
                  ],
                ),
              ),
            if (component.children.isNotEmpty) ...[
              StyledDivider.subtle(),
              Padding(
                padding: EdgeInsets.all(4),
                child: StyledList.column(
                  children: [
                    ...component.children,
                  ],
                ),
              ),
            ]
          ],
        ),
      ),
    );
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
        actions: [
          ActionItem(
            titleText: 'Debug',
            descriptionText: 'Print a Debug statement',
            iconData: Icons.bug_report,
            onPerform: (context) {
              print('Hello World!');
            },
          ),
        ],
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
