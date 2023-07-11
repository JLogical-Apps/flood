import 'package:example_core/features/envelope_rule/repeating_goal_envelope_rule.dart';
import 'package:jlogical_utils_core/jlogical_utils_core.dart';

abstract class TimeRule extends ValueObject {
  int getPeriodsBetween(DateTime date1, DateTime date2);

  DateTime getStartOfPeriod(DateTime date, DateTime lastAppliedDate);

  int getCentsRemaining({required RepeatingGoalEnvelopeRule rule, required DateTime now}) {
    final monthsDifference = getPeriodsBetween(now, rule.lastAppliedDateProperty.value.time);
    final adjustedRemainingGoalCents =
        monthsDifference * rule.goalCentsProperty.value + rule.remainingGoalCentsProperty.value;

    return adjustedRemainingGoalCents;
  }
}
