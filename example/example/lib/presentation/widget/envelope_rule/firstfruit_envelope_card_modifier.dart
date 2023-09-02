import 'package:example/presentation/widget/envelope_rule/envelope_card_modifier.dart';
import 'package:example_core/example_core.dart';
import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class FirstfruitEnvelopeCardModifier extends EnvelopeRuleCardModifier<FirstfruitEnvelopeRule> {
  @override
  Widget getIcon(EnvelopeRule rule, {Color? color}) {
    return StyledIcon(Icons.apple, color: color);
  }

  @override
  Widget getDescription(FirstfruitEnvelopeRule rule) {
    return StyledMarkdown(
        'Valet will collect the first `${rule.percentProperty.valueOrNull?.formatIntOrDouble() ?? '?'}`% of all income before it goes into your goals.');
  }
}
