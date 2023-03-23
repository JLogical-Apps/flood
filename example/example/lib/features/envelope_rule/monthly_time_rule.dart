import 'package:example/features/envelope_rule/time_rule.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class MonthlyTimeRule extends TimeRule {
  static const dayOfMonthField = 'dayOfMonth';
  late final dayOfMonthProperty = field<int>(name: dayOfMonthField).withDisplayName('Day of Month').required();

  @override
  List<ValueObjectBehavior> get behaviors => [dayOfMonthProperty];

  /// Returns the difference of months from the two dates.
  /// If [date1] is the last day of the month and [date2] is the first day of the next month, it returns 1.
  /// If the dates are in the same month, returns 0.
  @override
  int getPeriodsBetween(DateTime date1, DateTime date2) {
    final monthValue1 = date1.month + date1.year * 12;
    final monthValue2 = date2.month + date2.year * 12;

    return monthValue1 - monthValue2;
  }
}
