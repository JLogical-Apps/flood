import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:style/src/color_palette_provider.dart';
import 'package:style/src/components/input/styled_button.dart';
import 'package:style/src/components/input/styled_text_field.dart';
import 'package:style/src/components/layout/styled_container.dart';
import 'package:style/src/components/layout/styled_list.dart';
import 'package:style/src/components/misc/styled_icon.dart';
import 'package:style/src/components/text/styled_text.dart';
import 'package:style/src/style_build_context_extensions.dart';
import 'package:style/src/style_renderer.dart';
import 'package:style/src/styleguide.dart';
import 'package:utils/utils.dart';

class FlatStyleTextFieldRenderer with IsTypedStyleRenderer<StyledTextField> {
  @override
  Widget renderTyped(BuildContext context, StyledTextField component) {
    final label = component.label ?? component.labelText?.mapIfNonNull((text) => StyledText.body.bold.display(text));
    final leading = component.leading ?? component.leadingIcon?.mapIfNonNull((icon) => StyledIcon(icon));

    final textController = useTextEditingController(text: component.text);
    final textFieldColor =
        component.enabled ? context.colorPalette().background.regular : context.colorPalette().baseBackground;

    final revealSecretState = useState<bool>(false);

    final previousText = usePrevious(component.text);

    if (previousText != component.text && component.text != textController.text) {
      final text = component.text ?? '';
      final isAtEnd =
          textController.text.length + 1 == text.length && textController.selection.baseOffset + 1 == text.length;
      final offset = isAtEnd ? text.length : min(text.length, textController.selection.baseOffset);

      textController.value = textController.value.copyWith(
        text: text,
        selection: TextSelection.collapsed(offset: offset),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null || component.showRequiredIndicator)
          Padding(
            padding: EdgeInsets.all(4),
            child: StyledList.row(
              itemPadding: EdgeInsets.all(2),
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (label != null) label,
                if (component.showRequiredIndicator)
                  StyledIcon.strong(
                    Icons.emergency,
                    size: 8,
                  ),
              ],
            ),
          ),
        ColorPaletteProvider(
          colorPalette: context.style().getColorPaletteFromBackground(textFieldColor),
          child: Builder(builder: (textFieldContext) {
            return TextFormField(
              controller: textController,
              onChanged: (text) => component.onChanged?.call(text),
              onTap: component.onTapped,
              style: context.style().getTextStyle(textFieldContext, StyledText.body.empty),
              cursorColor: textFieldContext.colorPalette().foreground.regular,
              readOnly: component.readonly || !component.enabled,
              obscureText: component.obscureText && !revealSecretState.value,
              maxLines: component.maxLines,
              keyboardType: component.keyboard,
              onFieldSubmitted: component.onSubmitted == null ? null : (text) => component.onSubmitted!(text),
              decoration: InputDecoration(
                hoverColor: textFieldContext.colorPalette().background.regular,
                focusColor: textFieldContext.colorPalette().background.regular.background.regular,
                fillColor: textFieldColor,
                prefixIcon: leading,
                suffixIcon: !component.obscureText || textController.text.isEmpty
                    ? null
                    : Padding(
                        padding: EdgeInsets.only(right: 2),
                        child: revealSecretState.value
                            ? StyledButton.subtle(
                                iconData: Icons.visibility,
                                onPressed: () => revealSecretState.value = false,
                              )
                            : StyledButton.subtle(
                                iconData: Icons.visibility_off,
                                onPressed: () => revealSecretState.value = true,
                              ),
                      ),
                filled: true,
                hintText: component.hintText,
                hintStyle: context.style().getTextStyle(textFieldContext,
                    StyledText.body.italics.withColor(textFieldContext.colorPalette().foreground.strong).empty),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: component.enabled
                      ? BorderSide(color: textFieldContext.colorPalette().foreground.subtle, width: 0.5)
                      : BorderSide(color: textFieldContext.colorPalette().background.regular, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: textFieldContext.colorPalette().foreground.strong, width: 1.5),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: textFieldContext.colorPalette().error.regular),
                ),
                errorText: component.errorText,
                errorMaxLines: 2,
                errorStyle: context
                    .style()
                    .getTextStyle(context, StyledText.body.bold.withColor(context.colorPalette().error.regular).empty),
              ),
            );
          }),
        ),
      ],
    );
  }

  @override
  void modifyStyleguide(Styleguide styleguide) {
    styleguide.getTabByNameOrCreate('Input', icon: Icons.input).getSectionByNameOrCreate('Text Field')
      ..add(StyledTextField(
        labelText: 'Text Field',
        hintText: 'Hint here',
      ))
      ..add(StyledTextField(
        labelText: 'Text Field',
        text: 'Oopsie an error',
        errorText: 'Here is an error',
      ))
      ..add(StyledTextField(
        labelText: 'Disabled',
        text: 'This is disabled',
        enabled: false,
      ))
      ..add(StyledTextField(
        labelText: 'Disabled Error',
        text: 'This is disabled and an error',
        errorText: 'Oops here is an error',
        enabled: false,
      ))
      ..add(StyledContainer.strong(
        padding: EdgeInsets.all(4),
        child: StyledList.column(children: [
          StyledTextField(
            labelText: 'Text Field',
            hintText: 'Hint Text here',
          ),
          StyledTextField(
            labelText: 'Text Field',
            text: 'Oopsie an error',
            errorText: 'Here is an error',
          ),
          StyledTextField(
            labelText: 'Disabled',
            text: 'This is disabled',
            enabled: false,
          ),
          StyledTextField(
            labelText: 'Disabled Error',
            text: 'This is disabled and an error',
            errorText: 'Oops here is an error',
            enabled: false,
          ),
        ]),
      ));
  }
}
