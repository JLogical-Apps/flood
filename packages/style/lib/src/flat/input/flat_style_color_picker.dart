import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:style/src/components/dialog/styled_dialog.dart';
import 'package:style/src/components/input/styled_button.dart';
import 'package:style/src/components/input/styled_color_picker.dart';
import 'package:style/src/components/input/styled_text_field.dart';
import 'package:style/src/components/misc/styled_icon.dart';
import 'package:style/src/flat/flat_style.dart';
import 'package:style/src/style_build_context_extensions.dart';
import 'package:style/src/style_renderer.dart';
import 'package:style/src/styleguide.dart';
import 'package:utils/utils.dart';

class FlatStyleColorPickerRenderer with IsTypedStyleRenderer<StyledColorPicker> {
  @override
  Widget renderTyped(BuildContext context, StyledColorPicker component) {
    return StyledTextField(
      key: ObjectKey(component.value),
      labelText: component.labelText,
      label: component.label,
      showRequiredIndicator: component.showRequiredIndicator,
      enabled: component.onChanged != null,
      readonly: true,
      errorText: component.errorText,
      leading: component.value == null
          ? StyledIcon(Icons.radio_button_unchecked)
          : Padding(
              padding: EdgeInsets.all(8),
              child: Container(
                width: 0, // Prevent it from fully expanding.
                decoration: BoxDecoration(
                  color: component.value,
                  shape: BoxShape.circle,
                  border: Border.fromBorderSide(
                    BorderSide(
                      color: context.colorPalette().foreground.regular,
                      width: 3,
                    ),
                  ),
                ),
              ),
            ),
      text: component.value?.mapIfNonNull((color) => '#${color.value.toRadixString(16).padLeft(6, '0')}') ?? '',
      hintText: component.value == null ? 'Select Color...' : null,
      onTapped: component.onChanged != null
          ? () async {
              final result = await context.showStyledDialog(
                StyledDialog(
                  titleText: 'Select Color',
                  body: HookBuilder(
                    builder: (context) {
                      final selectedColor = useState<Color?>(component.value);
                      final canBeNone = component.canBeNone;
                      return Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              alignment: WrapAlignment.center,
                              children: (component.allowedColors ?? _defaultColorChoices).map((color) {
                                final isSelected = selectedColor.value == color;
                                return GestureDetector(
                                  onTap: () {
                                    selectedColor.value = color;
                                  },
                                  child: Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: color,
                                      shape: BoxShape.circle,
                                      border: Border.fromBorderSide(
                                        BorderSide(
                                          color: (context.style() as FlatStyle).colorPalette.foreground.regular,
                                          width: isSelected ? 3 : 0,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (canBeNone)
                                StyledButton.subtle(
                                  labelText: 'Clear',
                                  iconData: Icons.clear,
                                  onPressed: () {
                                    selectedColor.value = null;
                                  },
                                ),
                              StyledButton(
                                labelText: 'OK',
                                onPressed: () {
                                  Navigator.of(context).pop([selectedColor.value]);
                                },
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
              );

              FocusScope.of(context).requestFocus(FocusNode());

              if (result != null) {
                final newColor = result[0] as Color?;

                component.onChanged!(newColor);
              }
            }
          : null,
    );
  }

  @override
  void modifyStyleguide(Styleguide styleguide) {
    styleguide.getTabByNameOrCreate('Input', icon: Icons.input).getSectionByNameOrCreate('Color Field')
      ..add(StyledColorPicker(
        labelText: 'Color Field',
        onChanged: (color) {
          print('Selected Color: $color');
        },
      ))
      ..add(StyledColorPicker(
        labelText: 'Color Field',
        onChanged: null,
      ));
  }
}

const List<Color> _defaultColorChoices = [
  Colors.blue,
  Colors.orange,
  Colors.green,
  Color(0xFFb0d266),
  Colors.pink,
  Colors.purpleAccent,
  Colors.deepPurpleAccent,
  Color(0xFFcc9900),
  Colors.teal,
];
