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

class DeltaStyleButtonRenderer with IsTypedStyleRenderer<StyledButton> {
  @override
  Widget renderTyped(BuildContext context, StyledButton component) {
    final backgroundColorPalette =
        component.backgroundColor?.mapIfNonNull((color) => context.style().getColorPaletteFromBackground(color)) ??
            (component.emphasis == Emphasis.strong ? context.colorPalette().background.strong : context.colorPalette());

    final label = component.label ??
        component.labelText?.mapIfNonNull((text) => StyledText.body.display.bold
            .withColor(component.isTextButton
                ? null
                : component.emphasis == Emphasis.regular
                    ? backgroundColorPalette.foreground.strong
                    : null)
            .withEmphasis(component.isTextButton ? component.emphasis : Emphasis.regular)(text));
    final icon = component.icon ??
        component.iconData?.mapIfNonNull((iconData) => StyledIcon(
              iconData,
              color: label != null && component.emphasis == Emphasis.regular
                  ? backgroundColorPalette.foreground.strong
                  : null,
            ));

    final loadingState = useState<bool>(false);

    final onPressed = component.onPressed?.mapIfNonNull(
      (onPressed) => () async {
        if (loadingState.value) {
          return;
        }

        loadingState.value = true;
        try {
          await onPressed();
        } finally {
          loadingState.value = false;
        }
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
            WidgetStateProperty.all(backgroundColorPalette.withOpacity(component.onPressed == null ? 0.6 : 1)),
        elevation: WidgetStateProperty.all(0),
        shape: WidgetStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(1000),
          side: component.emphasis == Emphasis.strong || component.isTextButton
              ? BorderSide.none
              : BorderSide(
                  width: 1,
                  color: component.emphasis == Emphasis.regular
                      ? context.colorPalette().foreground.strong
                      : context.colorPalette().foreground.subtle,
                ),
        )),
        padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 15, vertical: 12)),
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
            isTextButton: true,
            onPressed: () => Future.delayed(Duration(seconds: 1)),
          ),
          StyledButton(
            labelText: 'Regular',
            isTextButton: true,
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
