import 'package:flutter/material.dart';
import 'package:jlogical_utils/src/style/style.dart';

import '../../style_context.dart';
import '../../styled_widget.dart';

class StyledCalendar extends StyledWidget {
  final void Function(DateTime date)? onDateSelected;

  final List<CalendarEvent> events;

  const StyledCalendar({super.key, this.onDateSelected, this.events: const []});

  @override
  Widget buildStyled(BuildContext context, Style style, StyleContext styleContext) {
    return style.calendar(context, styleContext, this);
  }
}

class CalendarEvent {
  final DateTime date;

  const CalendarEvent({required this.date});
}
