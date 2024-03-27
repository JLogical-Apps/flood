import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:style/src/color_palette_provider.dart';
import 'package:style/src/components/input/styled_button.dart';
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

class FlatStyleButtonRenderer with IsTypedStyleRenderer<StyledButton> {
  @override
  Widget renderTyped(BuildContext context, StyledButton component) {
    final label = component.label ?? component.labelText?.mapIfNonNull((text) => StyledText.body.bold.display(text));
    final icon = component.icon ?? component.iconData?.mapIfNonNull((iconData) => StyledIcon(iconData));
    final backgroundColorPalette = context.colorPalette().background.getByEmphasis(component.emphasis);

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

    if (label == null && icon != null) {
      return IconButton(
        icon: Stack(
          children: [
            Opacity(
              opacity: loadingState.value ? 0 : 1,
              child: icon,
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
        onPressed: onPressed,
      );
    }

    return ElevatedButton(
      child: ColorPaletteProvider(
        colorPalette: backgroundColorPalette,
        child: Stack(
          children: [
            Opacity(
              opacity: loadingState.value ? 0 : 1,
              child: StyledList.row.shrink(
                itemPadding: EdgeInsets.all(2),
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
      style: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.all(backgroundColorPalette.withOpacity(component.onPressed == null ? 0.6 : 1)),
        textStyle: MaterialStateProperty.all(context.style().getTextStyle(context, StyledText.body.empty)),
        elevation: MaterialStateProperty.all(0),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
          side: component.emphasis != Emphasis.subtle
              ? BorderSide.none
              : BorderSide(width: 1.5, color: context.colorPalette().background.regular),
        )),
        padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 4, vertical: 2)),
      ),
      onPressed: onPressed,
    );
  }

  @override
  void modifyStyleguide(Styleguide styleguide) {
    styleguide.getTabByNameOrCreate('Input', icon: Icons.input).getSectionByNameOrCreate('Button')
      ..add(StyledList.row.withScrollbar(
        children: [
          StyledButton.subtle(
            labelText: 'Subtle',
            onPressed: () => Future.delayed(Duration(seconds: 1)),
          ),
          StyledButton(
            labelText: 'Regular',
            onPressed: () => Future.delayed(Duration(seconds: 1)),
          ),
          StyledButton.strong(
            labelText: 'Strong',
            onPressed: () => Future.delayed(Duration(seconds: 1)),
          )
        ],
      ))
      ..add(StyledContainer.strong(
        padding: EdgeInsets.all(4),
        child: StyledList.row.withScrollbar(
          children: [
            StyledButton.subtle(
              labelText: 'Subtle',
              onPressed: () => Future.delayed(Duration(seconds: 1)),
            ),
            StyledButton(
              labelText: 'Regular',
              onPressed: () => Future.delayed(Duration(seconds: 1)),
            ),
            StyledButton.strong(
              labelText: 'Strong',
              onPressed: () => Future.delayed(Duration(seconds: 1)),
            )
          ],
        ),
      ))
      ..add(StyledList.row.withScrollbar(
        children: [
          StyledButton.subtle(
            labelText: 'Subtle',
            iconData: Icons.add,
            onPressed: () => Future.delayed(Duration(seconds: 1)),
          ),
          StyledButton(
            labelText: 'Regular',
            iconData: Icons.add,
            onPressed: () => Future.delayed(Duration(seconds: 1)),
          ),
          StyledButton.strong(
            labelText: 'Strong',
            iconData: Icons.add,
            onPressed: () => Future.delayed(Duration(seconds: 1)),
          )
        ],
      ))
      ..add(StyledList.row.withScrollbar(
        children: [
          StyledButton.subtle(
            iconData: Icons.face,
            onPressed: () => Future.delayed(Duration(seconds: 1)),
          ),
          StyledButton(
            iconData: Icons.face,
            onPressed: () => Future.delayed(Duration(seconds: 1)),
          ),
          StyledButton.strong(
            iconData: Icons.face,
            onPressed: () => Future.delayed(Duration(seconds: 1)),
          )
        ],
      ));
  }
}
