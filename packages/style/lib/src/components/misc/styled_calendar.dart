import 'package:style/src/style_component.dart';

class StyledCalendar extends StyleComponent {
  final void Function(DateTime date)? onDateSelected;

  final List<CalendarEvent> events;

  StyledCalendar({super.key, this.onDateSelected, this.events = const []});
}

class CalendarEvent {
  final DateTime date;

  const CalendarEvent({required this.date});
}
