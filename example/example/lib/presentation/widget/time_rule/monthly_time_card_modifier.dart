import 'package:example/features/envelope_rule/monthly_time_rule.dart';
import 'package:example/features/envelope_rule/repeating_goal_envelope_rule.dart';
import 'package:example/presentation/widget/time_rule/time_rule_card_modifier.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class MonthlyTimeCardModifier extends TimeRuleCardModifier<MonthlyTimeRule?> {
  @override
  Widget getIcon(MonthlyTimeRule? rule) {
    return StyledIcon(Icons.calendar_month);
  }

  @override
  String getPeriodMarkdown(RepeatingGoalEnvelopeRule envelopeRule, MonthlyTimeRule? rule) {
    return '1st day of the month';
  }

  @override
  String getCurrentPeriodMarkdown(RepeatingGoalEnvelopeRule envelopeRule, MonthlyTimeRule? rule) {
    return 'the month of `${_getCurrentMonthName()}`';
  }

  String _getCurrentMonthName() => DateFormat('MMMM').format(DateTime.now());
}
