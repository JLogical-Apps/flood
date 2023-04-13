import 'package:example/features/envelope_rule/time_rule.dart';
import 'package:example/presentation/widget/time_rule/daily_time_card_modifier.dart';
import 'package:example/presentation/widget/time_rule/monthly_time_card_modifier.dart';
import 'package:example/presentation/widget/time_rule/none_time_card_modifier.dart';
import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

abstract class TimeRuleCardModifier<R extends TimeRule?> with IsTypedModifier<R, TimeRule?> {
  Widget getIcon(R rule);

  Widget getDescription(R rule);

  static final timeRuleCardModifierResolver = ModifierResolver<TimeRuleCardModifier, TimeRule?>(modifiers: [
    DailyTimeCardModifier(),
    MonthlyTimeCardModifier(),
  ]);

  static TimeRuleCardModifier getModifier(TimeRule? timeRule) {
    return timeRuleCardModifierResolver.resolveOrNull(timeRule) ?? NoneTimeCardModifier();
  }
}
