import 'package:example/features/envelope_rule/repeating_goal_envelope_rule.dart';
import 'package:example/presentation/widget/envelope_rule/envelope_card_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class RepeatingGoalEnvelopeCardWrapper extends EnvelopeRuleCardWrapper<RepeatingGoalEnvelopeRule> {
  @override
  String getName(RepeatingGoalEnvelopeRule rule) {
    return 'Repeating Goal';
  }

  @override
  Widget getIcon(RepeatingGoalEnvelopeRule rule) {
    return StyledIcon(Icons.calendar_month);
  }

  @override
  Widget getDescription(RepeatingGoalEnvelopeRule rule) {
    return StyledMarkdown(
      'Valet will prioritize getting `${rule.goalCentsProperty.value.formatCentsAsCurrency()}` in this envelope every month. For the month of `${_getCurrentMonthName()}`, you have `${rule.remainingGoalCentsProperty.value.formatCentsAsCurrency()}` remaining.',
    );
  }

  String _getCurrentMonthName() => DateFormat('MMMM').format(DateTime.now());

  @override
  Port<RepeatingGoalEnvelopeRule> getPort({required CorePondContext context, RepeatingGoalEnvelopeRule? initialRule}) {
    throw UnimplementedError();
  }

  @override
  Widget getPortBuilder(Port<RepeatingGoalEnvelopeRule> port) {
    throw UnimplementedError();
  }
}
