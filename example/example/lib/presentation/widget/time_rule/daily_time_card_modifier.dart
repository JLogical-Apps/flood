import 'package:example/features/envelope_rule/daily_time_rule.dart';
import 'package:example/features/envelope_rule/repeating_goal_envelope_rule.dart';
import 'package:example/presentation/widget/time_rule/time_rule_card_modifier.dart';
import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class DailyTimeCardModifier extends TimeRuleCardModifier<DailyTimeRule?> {
  @override
  Widget getIcon(DailyTimeRule? rule) {
    return StyledIcon(Icons.calendar_view_week);
  }

  @override
  String getPeriodMarkdown(RepeatingGoalEnvelopeRule envelopeRule, DailyTimeRule? rule) {
    return '`${rule?.daysProperty.valueOrNull ?? '?'}` days';
  }

  @override
  String getCurrentPeriodMarkdown(RepeatingGoalEnvelopeRule envelopeRule, DailyTimeRule? rule) {
    final daysSinceLastUpdate = DateTime.now().difference(envelopeRule.lastAppliedDateProperty.value.time).inDays.abs();
    final daysRemaining = rule == null ? null : (rule.daysProperty.value - daysSinceLastUpdate);
    return 'the next `${daysRemaining ?? '?'}` day${daysRemaining == null || daysRemaining != 1 ? 's' : ''}';
  }
}
