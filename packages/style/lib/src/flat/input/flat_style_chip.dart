import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:style/src/color_palette_provider.dart';
import 'package:style/src/components/input/styled_chip.dart';
import 'package:style/src/components/layout/styled_container.dart';
import 'package:style/src/components/layout/styled_list.dart';
import 'package:style/src/components/misc/styled_icon.dart';
import 'package:style/src/components/misc/styled_loading_indicator.dart';
import 'package:style/src/components/text/styled_text.dart';
import 'package:style/src/style_build_context_extensions.dart';
import 'package:style/src/style_renderer.dart';
import 'package:style/src/styleguide.dart';
import 'package:utils/utils.dart';

class FlatStyleChipRenderer with IsTypedStyleRenderer<StyledChip> {
  @override
  Widget renderTyped(BuildContext context, StyledChip component) {
    final label = component.label ?? component.labelText?.mapIfNonNull((text) => StyledText.body.bold(text));
    final icon = component.icon ?? component.iconData?.mapIfNonNull((iconData) => StyledIcon(iconData));
    final backgroundColorPalette =
        component.backgroundColor?.mapIfNonNull((color) => context.style().getColorPaletteFromBackground(color)) ??
            context.colorPalette().background.getByEmphasis(component.emphasis);

    final loadingState = useState<bool>(false);

    final onPressed = component.onPressed?.mapIfNonNull(
      (onPressed) => () async {
        if (loadingState.value) {
          return;
        }

        loadingState.value = true;
        await onPressed();
        loadingState.value = false;
      },
    );

    return IntrinsicWidth(
      child: ActionChip(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
          side: BorderSide(
            color: backgroundColorPalette.background.regular,
            width: 1,
          ),
        ),
        label: ColorPaletteProvider(
          colorPalette: backgroundColorPalette,
          child: Stack(
            children: [
              Opacity(
                opacity: loadingState.value ? 0 : 1,
                child: StyledList.row(
                  children: [
                    if (icon != null) icon,
                    if (label != null) label,
                  ],
                ),
              ),
              Positioned.fill(
                child: Center(
                  child: Visibility(
                    visible: loadingState.value,
                    child: StyledLoadingIndicator(),
                  ),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: backgroundColorPalette,
        onPressed: onPressed,
      ),
    );
  }

  @override
  void modifyStyleguide(Styleguide styleguide) {
    styleguide.getTabByNameOrCreate('Input', icon: Icons.input).getSectionByNameOrCreate('Chip')
      ..add(StyledList.row.withScrollbar(
        children: [
          StyledChip.subtle(
            labelText: 'Subtle',
            onPressed: () => Future.delayed(Duration(seconds: 1)),
          ),
          StyledChip(
            labelText: 'Regular',
            onPressed: () => Future.delayed(Duration(seconds: 1)),
          ),
          StyledChip.strong(
            labelText: 'Strong',
            onPressed: () => Future.delayed(Duration(seconds: 1)),
          )
        ],
      ))
      ..add(StyledContainer.strong(
        child: StyledList.row.withScrollbar(
          children: [
            StyledChip.subtle(
              labelText: 'Subtle',
              onPressed: () => Future.delayed(Duration(seconds: 1)),
            ),
            StyledChip(
              labelText: 'Regular',
              onPressed: () => Future.delayed(Duration(seconds: 1)),
            ),
            StyledChip.strong(
              labelText: 'Strong',
              onPressed: () => Future.delayed(Duration(seconds: 1)),
            )
          ],
        ),
      ))
      ..add(StyledList.row.withScrollbar(
        children: [
          StyledChip.subtle(
            labelText: 'Subtle',
            iconData: Icons.add,
            onPressed: () => Future.delayed(Duration(seconds: 1)),
          ),
          StyledChip(
            labelText: 'Regular',
            iconData: Icons.add,
            onPressed: () => Future.delayed(Duration(seconds: 1)),
          ),
          StyledChip.strong(
            labelText: 'Strong',
            iconData: Icons.add,
            onPressed: () => Future.delayed(Duration(seconds: 1)),
          )
        ],
      ));
  }
}
