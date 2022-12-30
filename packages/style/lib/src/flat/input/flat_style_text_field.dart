import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:style/src/components/input/styled_text_field.dart';
import 'package:style/src/components/layout/styled_container.dart';
import 'package:style/src/components/layout/styled_list.dart';
import 'package:style/src/components/text/styled_text.dart';
import 'package:style/src/style_build_context_extensions.dart';
import 'package:style/src/style_renderer.dart';
import 'package:style/src/styleguide.dart';
import 'package:utils/utils.dart';

class FlatStyleTextFieldRenderer with IsTypedStyleRenderer<StyledTextField> {
  @override
  Widget renderTyped(BuildContext context, StyledTextField component) {
    final label = component.label ?? component.labelText?.mapIfNonNull((text) => StyledText.body(text));
    final textController = useTextEditingController(text: component.text);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Padding(
            padding: EdgeInsets.all(4),
            child: label,
          ),
        TextFormField(
          controller: textController,
          onChanged: (text) => component.onChanged?.call(text),
          style: context.style().getTextStyle(context, StyledText.body.empty),
          cursorColor: context.colorPalette().foreground.regular,
          readOnly: !component.enabled,
          decoration: InputDecoration(
            hoverColor: context.colorPalette().background.regular,
            focusColor: context.colorPalette().background.regular.background.regular,
            fillColor:
                component.enabled ? context.colorPalette().background.regular : context.colorPalette().baseBackground,
            filled: true,
            hintText: component.hintText,
            hintStyle: context.style().getTextStyle(
                context, StyledText.body.italics.withColor(context.colorPalette().foreground.strong).empty),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: component.enabled
                  ? BorderSide.none
                  : BorderSide(color: context.colorPalette().background.regular, width: 3),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: context.colorPalette().background.strong),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: context.colorPalette().error.subtle),
            ),
            errorText: component.errorText,
          ),
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
