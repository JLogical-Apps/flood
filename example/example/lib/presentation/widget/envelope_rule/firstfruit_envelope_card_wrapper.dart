import 'package:example/features/envelope_rule/envelope_rule.dart';
import 'package:example/features/envelope_rule/firstfruit_envelope_rule.dart';
import 'package:example/features/envelope_rule/percent_rule.dart';
import 'package:example/presentation/widget/envelope_rule/envelope_card_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class FirstfruitEnvelopeCardWrapper extends EnvelopeRuleCardWrapper<FirstfruitEnvelopeRule> {
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

  @override
  Port<FirstfruitEnvelopeRule> getPort({required CorePondContext context, FirstfruitEnvelopeRule? initialRule}) {
    return (initialRule ?? FirstfruitEnvelopeRule()).asPort(context);
  }

  @override
  Widget getPortBuilder(Port<FirstfruitEnvelopeRule> port) {
    return PortBuilder(
      port: port,
      builder: (context, port) {
        return StyledTextFieldPortField(fieldName: PercentRule.percentField);
      },
    );
  }
}
