import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:style/src/components/layout/styled_container.dart';
import 'package:style/src/components/misc/styled_calendar.dart';
import 'package:style/src/components/misc/styled_icon.dart';
import 'package:style/src/components/text/styled_text.dart';
import 'package:style/src/flat/flat_style.dart';
import 'package:style/src/style_build_context_extensions.dart';
import 'package:style/src/style_renderer.dart';
import 'package:style/src/styleguide.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:utils/utils.dart';

class FlatStyleCalendarRenderer with IsTypedStyleRenderer<StyledCalendar> {
  @override
  Widget renderTyped(BuildContext context, StyledCalendar component) {
    final style = context.style() as FlatStyle;

    final focusedDay = useState<DateTime>(DateTime.now());
    final selectedDay = useState<DateTime>(DateTime.now());

    return TableCalendar<CalendarEvent>(
      focusedDay: focusedDay.value,
      selectedDayPredicate: (date) => selectedDay.value == date,
      eventLoader: (date) => component.events.where((event) => event.date.withoutTime() == date.withoutTime()).toList(),
      onDaySelected: (selected, focused) {
        focusedDay.value = focused;
        selectedDay.value = selected;
        component.onDateSelected?.call(selected);
      },
      firstDay: DateTime.fromMicrosecondsSinceEpoch(0),
      lastDay: DateTime.now().add(Duration(days: 100000)),
      sixWeekMonthsEnforced: true,
      availableCalendarFormats: {CalendarFormat.month: 'Month'},
      calendarStyle: CalendarStyle(
        defaultTextStyle: context.style().getTextStyle(context, StyledText.body.display.bold.empty),
        weekendTextStyle: context.style().getTextStyle(context, StyledText.body.display.bold.empty),
        outsideTextStyle: context.style().getTextStyle(context, StyledText.body.display.thin.empty),
        todayTextStyle: context.style().getTextStyle(context,
            StyledText.body.display.bold.withColor(context.colorPalette().background.strong.foreground.regular).empty),
        selectedTextStyle: context.style().getTextStyle(
            context,
            StyledText.body.display.bold
                .withColor(context.style().getColorPaletteFromBackground(style.accentColor).foreground.regular)
                .empty),
        selectedDecoration: BoxDecoration(
          shape: BoxShape.circle,
          color: style.accentColor,
        ),
        markerSize: 14,
        markerDecoration: BoxDecoration(
          shape: BoxShape.circle,
          color: context.colorPalette().background.strong.withOpacity(0.8),
        ),
        todayDecoration: BoxDecoration(
          shape: BoxShape.circle,
          color: context.colorPalette().background.strong.withOpacity(0.5),
        ),
      ),
      headerStyle: HeaderStyle(
        leftChevronIcon: StyledIcon.strong(Icons.chevron_left),
        rightChevronIcon: StyledIcon.strong(Icons.chevron_right),
        titleTextStyle: context.style().getTextStyle(context, StyledText.lg.strong.bold.display.empty),
        titleCentered: true,
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: context.style().getTextStyle(context, StyledText.body.bold.display.empty),
        weekendStyle: context.style().getTextStyle(context, StyledText.body.bold.display.empty),
      ),
      shouldFillViewport: true,
      availableGestures: AvailableGestures.horizontalSwipe,
    );
  }

  @override
  void modifyStyleguide(Styleguide styleguide) {
    styleguide.getTabByNameOrCreate('Misc', icon: Icons.interests).getSectionByNameOrCreate('Calendar')
      ..add(ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 400),
        child: StyledCalendar(
          events: [
            CalendarEvent(date: DateTime.now().subtract(Duration(days: 1))),
            CalendarEvent(date: DateTime.now().subtract(Duration(days: 3))),
            CalendarEvent(date: DateTime.now().add(Duration(days: 2))),
          ],
        ),
      ))
      ..add(StyledContainer.strong(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 400),
          child: StyledCalendar(
            events: [
              CalendarEvent(date: DateTime.now().subtract(Duration(days: 1))),
              CalendarEvent(date: DateTime.now().subtract(Duration(days: 3))),
              CalendarEvent(date: DateTime.now().add(Duration(days: 2))),
            ],
          ),
        ),
      ));
  }
}
