import 'package:example/presentation/widget/envelope_rule/envelope_card_modifier.dart';
import 'package:example/presentation/widget/time_rule/time_rule_card_modifier.dart';
import 'package:example_core/features/envelope_rule/repeating_goal_envelope_rule.dart';
import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class RepeatingGoalEnvelopeCardModifier extends EnvelopeRuleCardModifier<RepeatingGoalEnvelopeRule> {
  @override
  Widget getIcon(RepeatingGoalEnvelopeRule rule, {Color? color}) {
    return StyledIcon(Icons.calendar_month, color: color);
  }

  @override
  Widget getDescription(RepeatingGoalEnvelopeRule rule) {
    final timeRule = rule.timeRuleProperty.valueOrNull;
    final timeRuleWrapper = TimeRuleCardModifier.getModifierOrNull(timeRule);
    final currentPeriod = timeRuleWrapper?.getCurrentPeriodMarkdown(rule, timeRule);
    final period = timeRuleWrapper?.getPeriodMarkdown(rule, timeRule);

    return StyledMarkdown(
        'Valet will prioritize getting `${rule.goalCentsProperty.valueOrNull?.formatCentsAsCurrency() ?? '?'}` every $period. For $currentPeriod, you have `${rule.remainingGoalCentsProperty.valueOrNull?.formatCentsAsCurrency() ?? '?'}` remaining.');
  }
}
