import 'package:example/features/envelope_rule/time_rule.dart';
import 'package:example/presentation/widget/time_rule/time_rule_card_modifier.dart';
import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class NoneTimeCardModifier extends TimeRuleCardModifier<TimeRule?> {
  @override
  Widget getIcon(TimeRule? rule) {
    return StyledIcon(Icons.block);
  }

  @override
  Widget getDescription(TimeRule? rule) {
    return StyledMarkdown('TODO');
  }
}
