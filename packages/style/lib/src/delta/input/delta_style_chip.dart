import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:style/src/color_palette_provider.dart';
import 'package:style/src/components/input/styled_chip.dart';
import 'package:style/src/components/layout/styled_container.dart';
import 'package:style/src/components/layout/styled_list.dart';
import 'package:style/src/components/misc/styled_icon.dart';
import 'package:style/src/components/misc/styled_loading_indicator.dart';
import 'package:style/src/components/text/styled_text.dart';
import 'package:style/src/emphasis.dart';
import 'package:style/src/style_build_context_extensions.dart';
import 'package:style/src/style_renderer.dart';
import 'package:style/src/styleguide.dart';
import 'package:utils/utils.dart';

class DeltaStyleChipRenderer with IsTypedStyleRenderer<StyledChip> {
  @override
  Widget renderTyped(BuildContext context, StyledChip component) {
    final label = component.label ??
        component.labelText?.mapIfNonNull((text) => StyledText.body.bold.withColor(component.foregroundColor)(text));
    final icon = component.icon ??
        component.iconData?.mapIfNonNull((iconData) => StyledIcon(
              iconData,
              color: component.foregroundColor,
            ));
    final backgroundColorPalette = component.emphasis == Emphasis.strong
        ? context.colorPalette().background.strong
        : context.colorPalette();

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
      child: RawChip(
        padding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        labelPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: backgroundColorPalette.foreground.subtle,
            width: 0.5,
          ),
          borderRadius: BorderRadius.circular(1200),
        ),
        materialTapTargetSize: MaterialTapTargetSize.padded,
        visualDensity: VisualDensity.compact,
        label: ColorPaletteProvider(
          colorPalette: backgroundColorPalette,
          child: Stack(
            children: [
              Opacity(
                opacity: loadingState.value ? 0 : 1,
                child: StyledList.row.centered(
                  itemPadding: EdgeInsets.all(3),
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
        padding: EdgeInsets.all(4),
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
