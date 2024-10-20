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
    final label = component.label ??
        component.labelText?.mapIfNonNull((text) => StyledText.body.bold.display
            .withEmphasis(component.isTextButton ? component.emphasis : Emphasis.regular)(text));
    final icon = component.icon ?? component.iconData?.mapIfNonNull((iconData) => StyledIcon(iconData));
    final backgroundColorPalette =
        component.backgroundColor?.mapIfNonNull((color) => context.style().getColorPaletteFromBackground(color)) ??
            context.colorPalette().background.getByEmphasis(component.emphasis);
    final background = component.background;

    final loadingState = useState<bool>(false);
    final errorState = useState<bool>(false);

    final onPressed = component.onPressed?.mapIfNonNull(
      (onPressed) => () async {
        if (loadingState.value || errorState.value) {
          return;
        }

        loadingState.value = true;
        try {
          await onPressed();
        } catch (e) {
          errorState.value = true;
          rethrow;
        } finally {
          loadingState.value = false;
        }
      },
    );

    final canPress = !loadingState.value && !errorState.value;

    if (label == null && (icon != null || background != null)) {
      return IconButton(
        style: ButtonStyle(
          shape: WidgetStateProperty.all(CircleBorder()),
          backgroundColor: WidgetStateProperty.all(backgroundColorPalette),
          backgroundBuilder: background == null
              ? null
              : (context, states, child) => ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: background,
                    ),
                  ),
        ),
        icon: ColorPaletteProvider(
          colorPalette: backgroundColorPalette,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Opacity(
                opacity: canPress ? 1 : 0,
                child: icon,
              ),
              Positioned.fill(
                child: Center(
                  child: Visibility(
                    visible: !canPress,
                    child: loadingState.value
                        ? StyledLoadingIndicator()
                        : StyledIcon(Icons.error, color: context.colorPalette().error.regular),
                  ),
                ),
              ),
            ],
          ),
        ),
        onPressed: onPressed,
      );
    }

    if (component.isTextButton) {
      return TextButton(
        child: Stack(
          children: [
            Opacity(
              opacity: canPress ? 1 : 0,
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
                  visible: !canPress,
                  child: loadingState.value
                      ? StyledLoadingIndicator()
                      : StyledIcon(Icons.error, color: context.colorPalette().error.regular),
                ),
              ),
            ),
          ],
        ),
        style: ButtonStyle(
          shape: WidgetStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          )),
          textStyle: WidgetStateProperty.all(
              context.style().getTextStyle(context, StyledText.body.underline.withEmphasis(component.emphasis).empty)),
          padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 8, vertical: 4)),
        ),
        onPressed: onPressed,
      );
    } else {
      return ElevatedButton(
        child: ColorPaletteProvider(
          colorPalette: backgroundColorPalette,
          child: Stack(
            children: [
              Opacity(
                opacity: canPress ? 1 : 0,
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
                    visible: !canPress,
                    child: loadingState.value
                        ? StyledLoadingIndicator()
                        : StyledIcon(Icons.error, color: context.colorPalette().error.regular),
                  ),
                ),
              ),
            ],
          ),
        ),
        style: ButtonStyle(
          backgroundColor:
              WidgetStateProperty.all(backgroundColorPalette.withOpacity(component.onPressed == null ? 0.6 : 1)),
          textStyle: WidgetStateProperty.all(context.style().getTextStyle(context, StyledText.body.empty)),
          elevation: WidgetStateProperty.all(0),
          shape: WidgetStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
            side: component.emphasis != Emphasis.subtle
                ? BorderSide.none
                : BorderSide(width: 1.5, color: context.colorPalette().background.regular),
          )),
          padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 4, vertical: 2)),
        ),
        onPressed: onPressed,
      );
    }
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
            labelText: 'Subtle',
            isTextButton: true,
            iconData: Icons.add,
            onPressed: () => Future.delayed(Duration(seconds: 1)),
          ),
          StyledButton(
            labelText: 'Regular',
            isTextButton: true,
            iconData: Icons.add,
            onPressed: () => Future.delayed(Duration(seconds: 1)),
          ),
          StyledButton.strong(
            labelText: 'Strong',
            isTextButton: true,
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
