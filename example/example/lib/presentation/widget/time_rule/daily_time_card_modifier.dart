import 'package:example/features/envelope_rule/daily_time_rule.dart';
import 'package:example/presentation/widget/time_rule/time_rule_card_modifier.dart';
import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class DailyTimeCardModifier extends TimeRuleCardModifier<DailyTimeRule?> {
  @override
  Widget getIcon(DailyTimeRule? rule) {
    return StyledIcon(Icons.calendar_view_week);
  }

  @override
  Widget getDescription(DailyTimeRule? rule) {
    return StyledMarkdown('TODO');
  }
}
