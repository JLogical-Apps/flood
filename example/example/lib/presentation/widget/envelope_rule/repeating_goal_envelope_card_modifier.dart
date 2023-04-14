import 'package:example/features/envelope_rule/repeating_goal_envelope_rule.dart';
import 'package:example/presentation/widget/envelope_rule/envelope_card_modifier.dart';
import 'package:example/presentation/widget/time_rule/time_rule_card_modifier.dart';
import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class RepeatingGoalEnvelopeCardModifier extends EnvelopeRuleCardModifier<RepeatingGoalEnvelopeRule> {
  @override
  Widget getIcon(RepeatingGoalEnvelopeRule rule) {
    return StyledIcon(Icons.calendar_month);
  }

  @override
  Widget getDescription(RepeatingGoalEnvelopeRule rule) {
    final timeRule = rule.timeRuleProperty.valueOrNull;
    final timeRuleWrapper = TimeRuleCardModifier.getModifierOrNull(timeRule);
    final currentPeriod = timeRuleWrapper?.getCurrentPeriodMarkdown(timeRule);
    final period = timeRuleWrapper?.getPeriodMarkdown(timeRule);

    return StyledMarkdown(
        'Valet will prioritize getting `${rule.goalCentsProperty.valueOrNull?.formatCentsAsCurrency() ?? '?'}` every $period. For $currentPeriod, you have `${rule.remainingGoalCentsProperty.valueOrNull?.formatCentsAsCurrency() ?? '?'}` remaining.');
  }
}
