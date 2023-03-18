import 'package:example/features/envelope_rule/time_rule.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class MonthlyTimeRule extends TimeRule {
  static const dayOfMonthField = 'dayOfMonth';
  late final dayOfMonthProperty = field<int>(name: dayOfMonthField).required();

  static const centsRemainingField = 'centsRemaining';
  late final centsRemainingProperty = field<int>(name: centsRemainingField).required();

  @override
  int getCentsRemaining({required DateTime now}) {
    throw Exception();
  }
}
