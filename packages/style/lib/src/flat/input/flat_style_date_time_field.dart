import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:style/src/components/input/styled_date_time_field.dart';
import 'package:style/src/components/input/styled_text_field.dart';
import 'package:style/src/components/text/styled_text.dart';
import 'package:style/src/style_renderer.dart';
import 'package:style/src/styleguide.dart';
import 'package:style/style.dart';
import 'package:utils/utils.dart';

class FlatStyleDateFieldRenderer with IsTypedStyleRenderer<StyledDateTimeField> {
  @override
  Widget renderTyped(BuildContext context, StyledDateTimeField component) {
    final valueState = useState<DateTime?>(component.value);
    return StyledTextField(
      labelText: component.labelText,
      label: component.label,
      enabled: component.onChanged != null,
      readonly: true,
      errorText: component.errorText,
      hintText: component.hintText,
      leadingIcon: Icons.date_range,
      text: valueState.value?.format(showDate: component.showDate, showTime: component.showTime),
      onTapped: component.onChanged == null
          ? null
          : () async {
              final result = await showDatePicker(
                context: context,
                builder: (context, child) {
                  return Theme(
                    data: ThemeData.light().copyWith(
                      colorScheme: ColorScheme.dark(
                        primary: context.colorPalette().background.strong,
                        onPrimary: context.colorPalette().background.strong.foreground.regular,
                        surface: context.colorPalette().background.regular,
                        onSurface: context.colorPalette().background.regular.foreground.regular,
                        brightness: context.colorPalette().background.regular.computeLuminance() > 0.5
                            ? Brightness.dark
                            : Brightness.light,
                      ),
                      inputDecorationTheme: InputDecorationTheme(
                        labelStyle: TextStyle(
                          color: context.colorPalette().background.regular.foreground.strong,
                        ),
                      ),
                      textTheme: Theme.of(context).textTheme.apply(
                        bodyColor: context.colorPalette().foreground.regular,
                      ),
                      dialogTheme: DialogTheme(
                        backgroundColor: context.colorPalette().background.regular,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    child: child ?? Container(),
                  );
                },
                useRootNavigator: false,
                initialDate: valueState.value ?? DateTime.now(),
                firstDate: DateTime.fromMillisecondsSinceEpoch(0),
                lastDate: DateTime.now().add(Duration(days: 1000)),
              );

              FocusScope.of(context).requestFocus(FocusNode());

              if (result != null) component.onChanged!(result);
            },
    );
  }

  @override
  void modifyStyleguide(Styleguide styleguide) {
    styleguide.getTabByNameOrCreate('Input', icon: Icons.input).getSectionByNameOrCreate('Date Field')
      ..add(StyledDateTimeField(
        labelText: 'DateTime Field',
        hintText: 'Hint here',
        onChanged: (date) {
          print('Selected Date: $date');
        },
      ))
      ..add(StyledDateTimeField(
        labelText: 'Only Date Field',
        value: DateTime.now(),
        showTime: false,
        onChanged: (date) {},
      ))
      ..add(StyledDateTimeField(
        labelText: 'Only Time Field',
        value: DateTime.now(),
        showDate: false,
        onChanged: (date) {},
      ))
      ..add(StyledDateTimeField(
        labelText: 'Yesterday',
        value: DateTime.now().subtract(Duration(days: 1)),
        onChanged: (date) {},
      ))
      ..add(StyledDateTimeField(
        labelText: 'Date Field',
        errorText: 'Here is an error',
        onChanged: (date) {},
      ))
      ..add(StyledDateTimeField(
        value: DateTime.now(),
        labelText: 'Disabled',
      ))
      ..add(StyledDateTimeField(
        labelText: 'Disabled Error',
        value: DateTime.now(),
        errorText: 'Oops here is an error',
      ));
  }
}
