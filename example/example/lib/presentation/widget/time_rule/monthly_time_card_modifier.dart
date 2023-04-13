import 'package:example/features/envelope_rule/monthly_time_rule.dart';
import 'package:example/presentation/widget/time_rule/time_rule_card_modifier.dart';
import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class MonthlyTimeCardModifier extends TimeRuleCardModifier<MonthlyTimeRule?> {
  @override
  Widget getIcon(MonthlyTimeRule? rule) {
    return StyledIcon(Icons.calendar_month);
  }

  @override
  Widget getDescription(MonthlyTimeRule? rule) {
    return StyledMarkdown('TODO');
  }
}
