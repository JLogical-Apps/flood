import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:style/src/color_palette_provider.dart';
import 'package:style/src/components/dialog/styled_dialog.dart';
import 'package:style/src/components/input/styled_button.dart';
import 'package:style/src/components/input/styled_option_field.dart';
import 'package:style/src/components/input/styled_text_field.dart';
import 'package:style/src/components/layout/styled_container.dart';
import 'package:style/src/components/layout/styled_list.dart';
import 'package:style/src/components/misc/styled_icon.dart';
import 'package:style/src/components/text/styled_text.dart';
import 'package:style/src/style_build_context_extensions.dart';
import 'package:style/src/style_renderer.dart';
import 'package:style/src/styleguide.dart';
import 'package:utils/utils.dart';

class FlatStyleOptionFieldRenderer with IsTypedStyleRenderer<StyledOptionField> {
  @override
  Widget renderTyped(BuildContext context, StyledOptionField component) {
    final label = component.label ?? component.labelText?.mapIfNonNull((text) => StyledText.body.bold.display(text));

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
        DropdownButtonFormField(
          isExpanded: true,
          value: component.value,
          dropdownColor: context.colorPalette().background.regular,
          hint: StyledText.body.italics.strong('Select an option'),
          onChanged: component.enabled ? (value) => component.change(value) : null,
          icon: StyledIcon(Icons.arrow_drop_down),
          style: context.style().getTextStyle(context, StyledText.body.empty),
          isDense: false,
          items: component.options
              .map((value) => DropdownMenuItem(
                    value: value,
                    child: ColorPaletteProvider(
                      colorPalette: context.colorPalette().background.regular,
                      child: component.getOptionChild(value),
                    ),
                  ))
              .toList(),
          decoration: InputDecoration(
            suffixIcon: component.stringSearchMapper == null || !component.enabled
                ? null
                : Padding(
                    padding: EdgeInsets.all(4),
                    child: StyledButton(
                      iconData: Icons.search,
                      onPressed: () async {
                        final result = await context.showStyledDialog(StyledDialog(
                          titleText: 'Search',
                          body: SearchDialog(optionField: component),
                        ));
                        if (result == null) {
                          return;
                        }

                        component.change(result);
                      },
                    ),
                  ),
            contentPadding: EdgeInsets.all(8),
            hoverColor: context.colorPalette().background.regular,
            focusColor: context.colorPalette().background.regular.background.regular,
            fillColor:
                component.enabled ? context.colorPalette().background.regular : context.colorPalette().baseBackground,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: component.enabled
                  ? component.errorText != null
                      ? BorderSide(color: context.colorPalette().error.subtle)
                      : BorderSide.none
                  : BorderSide(color: context.colorPalette().background.regular, width: 3),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: component.errorText != null
                    ? context.colorPalette().error.strong
                    : context.colorPalette().background.strong,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: context.colorPalette().error.subtle),
            ),
            errorText: component.errorText?.nullIfBlank,
            errorStyle: context
                .style()
                .getTextStyle(context, StyledText.body.bold.withColor(context.colorPalette().error.regular).empty),
          ),
        ),
      ],
    );
  }

  @override
  void modifyStyleguide(Styleguide styleguide) {
    styleguide.getTabByNameOrCreate('Input', icon: Icons.input).getSectionByNameOrCreate('Options')
      ..add(StyledOptionField<String>(
        value: 'Red',
        labelText: 'Colors',
        options: [
          'Red',
          'Green',
          'Blue',
        ],
      ))
      ..add(StyledOptionField<String>(
        value: 'Red',
        labelText: 'Colors',
        options: [
          'Red',
          'Green',
          'Blue',
        ],
        errorText: 'Here is an error',
      ))
      ..add(StyledOptionField<String>(
        value: 'Red',
        labelText: 'Colors',
        options: [
          'Red',
          'Green',
          'Blue',
        ],
        enabled: false,
      ))
      ..add(StyledOptionField<String>(
        value: 'Red',
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
            StyledOptionField<String>(
              value: 'Red',
              labelText: 'Colors',
              options: [
                'Red',
                'Green',
                'Blue',
              ],
            ),
            StyledOptionField<String>(
              value: 'Red',
              labelText: 'Colors',
              options: [
                'Red',
                'Green',
                'Blue',
              ],
              errorText: 'Here is an error',
            ),
            StyledOptionField<String>(
              value: 'Red',
              labelText: 'Colors',
              options: [
                'Red',
                'Green',
                'Blue',
              ],
              enabled: false,
            ),
            StyledOptionField<String>(
              value: 'Red',
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

class SearchDialog extends HookWidget {
  final StyledOptionField optionField;

  const SearchDialog({super.key, required this.optionField});

  @override
  Widget build(BuildContext context) {
    final searchState = useState<String>('');
    return StyledList.column(
      children: [
        StyledTextField(
          labelText: 'Search',
          leadingIcon: Icons.search,
          onChanged: (value) => searchState.value = value,
          autofocus: true,
        ),
        SizedBox(
          height: 200,
          child: StyledList.column.withScrollbar(
              ifEmptyText: 'No Results!',
              children: optionField.options
                  .where((option) => option != null)
                  .where((option) =>
                      searchState.value.isBlank ||
                      optionField
                          .getSearchString(option)
                          .any((searchString) => searchString.toUpperCase().contains(searchState.value.toUpperCase())))
                  .map((option) => StyledContainer.subtle(
                        child: optionField.getOptionChild(option),
                        onPressed: () => Navigator.of(context).pop(option),
                      ))
                  .toList()),
        ),
      ],
    );
  }
}
