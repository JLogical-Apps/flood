import 'package:example/features/envelope_rule/envelope_rule.dart';
import 'package:example/features/envelope_rule/firstfruit_envelope_rule.dart';
import 'package:example/presentation/widget/envelope_rule/envelope_card_modifier.dart';
import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class FirstfruitEnvelopeCardModifier extends EnvelopeRuleCardModifier<FirstfruitEnvelopeRule> {
  @override
  String getName(FirstfruitEnvelopeRule rule) {
    return 'Firstfruit';
  }

  @override
  Widget getIcon(EnvelopeRule rule) {
    return StyledIcon(Icons.apple);
  }

  @override
  Widget getDescription(FirstfruitEnvelopeRule rule) {
    return StyledMarkdown(
        'Valet will collect the first `${rule.percentProperty.value.formatIntOrDouble()}`% of all income before it goes into your goals.');
  }
}
