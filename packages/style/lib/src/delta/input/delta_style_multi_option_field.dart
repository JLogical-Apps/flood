import 'package:flutter/material.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:style/src/color_palette_provider.dart';
import 'package:style/src/components/input/styled_multi_option_field.dart';
import 'package:style/src/components/layout/styled_container.dart';
import 'package:style/src/components/layout/styled_list.dart';
import 'package:style/src/components/misc/styled_icon.dart';
import 'package:style/src/components/text/styled_text.dart';
import 'package:style/src/style_build_context_extensions.dart';
import 'package:style/src/style_renderer.dart';
import 'package:style/src/styleguide.dart';
import 'package:utils/utils.dart';

class DeltaStyleMultiOptionFieldRenderer with IsTypedStyleRenderer<StyledMultiOptionField> {
  @override
  Widget renderTyped(BuildContext context, StyledMultiOptionField component) {
    final label = component.label ?? component.labelText?.mapIfNonNull((text) => StyledText.body.bold.display(text));

    return StyledList.column(
      itemPadding: EdgeInsets.zero,
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
        IgnorePointer(
          ignoring: !component.enabled,
          child: MultiSelectDropDown(
            selectedOptions:
                component.values.map((value) => ValueItem(label: component.getLabel(value), value: value)).toList(),
            options: component.options
                .map((option) => ValueItem(
                      label: component.getLabel(option),
                      value: option,
                    ))
                .toList(),
            onOptionSelected: (options) => component.change(options.map((valueItem) => valueItem.value).toList()),
            optionsBackgroundColor:
                component.enabled ? context.colorPalette().background.regular : context.colorPalette().baseBackground,
            fieldBackgroundColor:
                component.enabled ? context.colorPalette().background.regular : context.colorPalette().baseBackground,
            dropdownBackgroundColor:
                component.enabled ? context.colorPalette().background.regular : context.colorPalette().baseBackground,
            selectedOptionBackgroundColor: context.colorPalette().background.regular,
            focusedBorderColor: component.errorText != null
                ? context.colorPalette().error.strong
                : context.colorPalette().background.strong,
            focusedBorderWidth: 1,
            borderRadius: 8,
            borderColor: component.errorText == null
                ? context.colorPalette().background.regular
                : context.colorPalette().error.subtle,
            borderWidth: 1,
            dropdownHeight: 140,
            dropdownBorderRadius: 12,
            chipConfig: ChipConfig(
              backgroundColor: context.colorPalette().background.strong,
              labelStyle: context.style().getTextStyle(
                  context,
                  StyledText.sm.bold.display
                      .withColor(context.colorPalette().background.strong.foreground.regular)
                      .empty),
              deleteIconColor: context.colorPalette().background.strong.foreground.regular,
            ),
            optionTextStyle: context.style().getTextStyle(context, StyledText.sm.bold.display.empty),
            hint: 'Select',
            hintStyle: context.style().getTextStyle(context, StyledText.sm.bold.display.subtle.empty),
            selectedOptionIcon: Icon(
              Icons.check,
              color: context.colorPalette().foreground.strong,
            ),
            clearIcon: Icon(
              Icons.cancel,
              color: context.colorPalette().foreground.regular,
            ),
            suffixIcon: Icon(
              Icons.expand_more,
              color: context.colorPalette().foreground.subtle,
            ),
            optionBuilder: (context, item, selected) => ColorPaletteProvider(
              colorPalette: context.colorPalette().background.regular,
              child: SizedBox(
                height: 50,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Center(
                    child: StyledList.row(
                      children: [
                        SizedBox(
                          width: 30,
                          child: selected ? StyledIcon(Icons.check) : null,
                        ),
                        Expanded(child: StyledText.body.display.bold(item.label)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        if (component.errorText != null)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: StyledText.body.error.bold(component.errorText!),
          ),
      ],
    );
  }

  @override
  void modifyStyleguide(Styleguide styleguide) {
    styleguide.getTabByNameOrCreate('Input', icon: Icons.input).getSectionByNameOrCreate('Multi Options')
      ..add(StyledMultiOptionField<String>(
        values: ['Red'],
        labelText: 'Colors',
        options: [
          'Red',
          'Green',
          'Blue',
        ],
      ))
      ..add(StyledMultiOptionField<String>(
        values: ['Red'],
        labelText: 'Colors',
        options: [
          'Red',
          'Green',
          'Blue',
        ],
        errorText: 'Here is an error',
      ))
      ..add(StyledMultiOptionField<String>(
        values: ['Red'],
        labelText: 'Colors',
        options: [
          'Red',
          'Green',
          'Blue',
        ],
        enabled: false,
      ))
      ..add(StyledMultiOptionField<String>(
        values: ['Red'],
        labelText: 'Colors',
        options: [
          'Red',
          'Green',
          'Blue',
        ],
        errorText: 'Here is an error',
        enabled: false,
      ))
      ..add(StyledContainer.strong(
        padding: EdgeInsets.all(4),
        child: StyledList.column(
          children: [
            StyledMultiOptionField<String>(
              values: ['Red'],
              labelText: 'Colors',
              options: [
                'Red',
                'Green',
                'Blue',
              ],
            ),
            StyledMultiOptionField<String>(
              values: ['Red'],
              labelText: 'Colors',
              options: [
                'Red',
                'Green',
                'Blue',
              ],
              errorText: 'Here is an error',
            ),
            StyledMultiOptionField<String>(
              values: ['Red'],
              labelText: 'Colors',
              options: [
                'Red',
                'Green',
                'Blue',
              ],
              enabled: false,
            ),
            StyledMultiOptionField<String>(
              values: ['Red'],
              labelText: 'Colors',
              options: [
                'Red',
                'Green',
                'Blue',
              ],
              errorText: 'Here is an error',
              enabled: false,
            ),
          ],
        ),
      ));
  }
}
