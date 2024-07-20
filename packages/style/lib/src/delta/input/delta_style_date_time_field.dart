import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pattern_formatter/pattern_formatter.dart';
import 'package:style/src/components/input/styled_date_time_field.dart';
import 'package:style/src/components/input/styled_text_field.dart';
import 'package:style/src/components/text/styled_text.dart';
import 'package:style/src/delta/delta_style.dart';
import 'package:style/src/style_build_context_extensions.dart';
import 'package:style/src/style_renderer.dart';
import 'package:style/src/styleguide.dart';
import 'package:utils/utils.dart';

class DeltaStyleDateFieldRenderer with IsTypedStyleRenderer<StyledDateTimeField> {
  @override
  Widget renderTyped(BuildContext context, StyledDateTimeField component) {
    return StyledTextField(
      labelText: component.labelText,
      label: component.label,
      showRequiredIndicator: component.showRequiredIndicator,
      enabled: component.onChanged != null,
      readonly: false,
      errorText: component.errorText,
      hintText: component.hintText,
      leadingIcon: Icons.date_range,
      action: TextInputAction.next,
      inputFormatters: [DateInputFormatter()],
      text: component.value?.formatWith((dateFormat) {
        if (component.showTime) {
          return dateFormat.add_yMd().addPattern('h:mm a');
        } else {
          return dateFormat.add_yMd();
        }
      }),
      onSubmitted: (text) {
        final dateFormat = DateFormat('MM/dd/yyyy');
        final dateTime = guard(() => dateFormat.parse(text));
        if (dateTime != null) {
          component.onChanged?.call(dateTime);
        }
      },
      onTapped: component.onChanged == null
          ? null
          : () async {
              var result = await getDate(context, component);
              if (result == null) {
                FocusScope.of(context).requestFocus(FocusNode());
                return;
              }

              if (component.showTime) {
                final time = await getTime(context, component);
                if (time == null) {
                  FocusScope.of(context).requestFocus(FocusNode());
                  return;
                }

                result = result.copyWith(
                  hour: time.hour,
                  minute: time.minute,
                );
              }

              FocusScope.of(context).requestFocus(FocusNode());
              component.onChanged!(result);
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

  Future<DateTime?> getDate(BuildContext context, StyledDateTimeField component) async {
    final colorPalette = (context.style() as DeltaStyle).colorPalette;
    return await showDatePicker(
      context: context,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.dark(
              primary: colorPalette.background.strong,
              onPrimary: colorPalette.background.strong.foreground.regular,
              surface: colorPalette.baseBackground,
              onSurface: colorPalette.foreground.regular,
              brightness: colorPalette.baseBackground.computeLuminance() > 0.5 ? Brightness.dark : Brightness.light,
            ),
            inputDecorationTheme: InputDecorationTheme(
              labelStyle: context.style().getTextStyle(context, StyledText.sm.bold.display.empty),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: colorPalette.background.regular.background.regular,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: colorPalette.background.regular.background.regular,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: colorPalette.background.regular.background.strong,
                  width: 2,
                ),
              ),
            ),
            dialogTheme: DialogTheme(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            textTheme: TextTheme(
              displayLarge: context.style().getTextStyle(context, StyledText.xs.bold.display.empty),
              headlineLarge: context.style().getTextStyle(context, StyledText.lg.bold.display.empty),
              labelLarge: context.style().getTextStyle(context, StyledText.sm.bold.display.empty),
              bodyLarge: context.style().getTextStyle(context, StyledText.sm.bold.display.empty),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: colorPalette.foreground.regular,
                textStyle: context.style().getTextStyle(context, StyledText.sm.display.bold.empty),
              ),
            ),
          ),
          child: child ?? Container(),
        );
      },
      useRootNavigator: false,
      initialDate: component.value ?? DateTime.now(),
      firstDate: DateTime.fromMillisecondsSinceEpoch(0),
      lastDate: DateTime.now().add(Duration(days: 1000)),
    );
  }

  Future<TimeOfDay?> getTime(BuildContext context, StyledDateTimeField component) async {
    final style = context.style() as DeltaStyle;
    final colorPalette = style.colorPalette;
    return await showTimePicker(
      context: context,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.dark(
              primary: colorPalette.background.strong,
              onPrimary: colorPalette.background.strong.foreground.regular,
              secondary: style.accentColor,
              onSecondary: style.getColorPaletteFromBackground(style.accentColor).foreground.regular,
              surface: colorPalette.baseBackground,
              onSurface: colorPalette.foreground.regular,
              brightness: colorPalette.baseBackground.computeLuminance() > 0.5 ? Brightness.dark : Brightness.light,
            ),
            inputDecorationTheme: InputDecorationTheme(
              labelStyle: context.style().getTextStyle(context, StyledText.sm.bold.display.empty),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: colorPalette.background.regular.background.regular,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: colorPalette.background.regular.background.regular,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: colorPalette.background.regular.background.strong,
                  width: 2,
                ),
              ),
            ),
            dialogTheme: DialogTheme(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            textTheme: TextTheme(
              displayLarge: context.style().getTextStyle(context, StyledText.xs.bold.display.empty),
              headlineLarge: context.style().getTextStyle(context, StyledText.lg.bold.display.empty),
              labelLarge: context.style().getTextStyle(context, StyledText.sm.bold.display.empty),
              bodyLarge: context.style().getTextStyle(context, StyledText.sm.bold.display.empty),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: colorPalette.foreground.regular,
                textStyle: context.style().getTextStyle(context, StyledText.sm.display.bold.empty),
              ),
            ),
          ),
          child: child ?? Container(),
        );
      },
      useRootNavigator: false,
      initialTime: component.value != null ? TimeOfDay.fromDateTime(component.value!) : TimeOfDay.now(),
    );
  }
}
