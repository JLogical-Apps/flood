import 'package:example/presentation/widget/envelope_rule/envelope_card_modifier.dart';
import 'package:example_core/features/envelope_rule/envelope_rule.dart';
import 'package:example_core/features/envelope_rule/firstfruit_envelope_rule.dart';
import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class FirstfruitEnvelopeCardModifier extends EnvelopeRuleCardModifier<FirstfruitEnvelopeRule> {
  @override
  Widget getIcon(EnvelopeRule rule, {Color? color, double? size}) {
    return StyledIcon(Icons.apple, color: color, size: size);
  }

  @override
  Widget getDescription(FirstfruitEnvelopeRule rule) {
    return StyledMarkdown(
        'Valet will collect the first `${rule.percentProperty.valueOrNull?.formatIntOrDouble() ?? '?'}`% of all income before it goes into your goals.');
  }
}
