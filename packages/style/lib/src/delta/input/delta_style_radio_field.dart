import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:style/src/components/input/styled_radio_field.dart';
import 'package:style/src/components/layout/styled_container.dart';
import 'package:style/src/components/layout/styled_list.dart';
import 'package:style/src/components/misc/styled_icon.dart';
import 'package:style/src/components/text/styled_text.dart';
import 'package:style/src/style_build_context_extensions.dart';
import 'package:style/src/style_renderer.dart';
import 'package:style/src/styleguide.dart';
import 'package:utils/utils.dart';

class DeltaStyleRadioFieldRenderer with IsTypedStyleRenderer<StyledRadioField> {
  @override
  Widget renderTyped(BuildContext context, StyledRadioField component) {
    final label = component.label ?? component.labelText?.mapIfNonNull((text) => StyledText.body(text));

    return StyledList.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      itemPadding: EdgeInsets.zero,
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
        StyledList.row.centered.withScrollbar(
          children: component.options
              .map((option) => GestureDetector(
                    onTap: component.enabled ? () => component.changeValue(option) : null,
                    child: StyledList.row.shrink(
                      itemPadding: EdgeInsets.zero,
                      children: [
                        StyledText.body(component.getOptionText(option)),
                        Radio<dynamic>(
                          groupValue: component.value,
                          value: option,
                          onChanged: component.enabled ? (_) => component.changeValue(option) : null,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          fillColor: component.errorText != null
                              ? MaterialStateProperty.all(Colors.red)
                              : MaterialStateProperty.resolveWith((states) => states.contains(MaterialState.selected)
                                  ? context.colorPalette().foreground.strong
                                  : context.colorPalette().foreground.regular),
                        ),
                      ],
                    ),
                  ))
              .toList(),
        ),
        if (component.errorText != null) StyledText.body.error.bold(component.errorText!),
      ],
    );
  }

  @override
  void modifyStyleguide(Styleguide styleguide) {
    styleguide.getTabByNameOrCreate('Input', icon: Icons.input).getSectionByNameOrCreate('Radio')
      ..add(HookBuilder(builder: (context) {
        final selectedOption = useState<String>('Red');
        return StyledRadioField<String>(
          value: selectedOption.value,
          labelText: 'Colors',
          onChanged: (r) => selectedOption.value = r,
          options: [
            'Red',
            'Green',
            'Blue',
          ],
        );
      }))
      ..add(StyledRadioField<String>(
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
            StyledRadioField<String>(
              value: 'Red',
              labelText: 'Colors',
              options: [
                'Red',
                'Green',
                'Blue',
              ],
            ),
            StyledRadioField<String>(
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
