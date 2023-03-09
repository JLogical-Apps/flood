import 'package:cron/cron.dart';

class TaskSchedule<I> {
  final I Function() inputGetter;
  final Schedule schedule;

  TaskSchedule({required this.inputGetter, required this.schedule});

  I get input => inputGetter();
}
