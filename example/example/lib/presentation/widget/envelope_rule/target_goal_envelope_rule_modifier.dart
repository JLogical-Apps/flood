import 'package:example/presentation/widget/envelope_rule/envelope_card_modifier.dart';
import 'package:example_core/example_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class TargetGoalEnvelopeCardModifier extends EnvelopeRuleCardModifier<TargetGoalEnvelopeRule> {
  @override
  Widget getIcon(TargetGoalEnvelopeRule rule, {Color? color}) {
    return StyledIcon(FontAwesomeIcons.bullseye, color: color);
  }

  @override
  Widget getDescription(TargetGoalEnvelopeRule rule) {
    return StyledMarkdown(
      'Valet wil collect `${rule.percentProperty.valueOrNull?.formatIntOrDouble() ?? '?'}`% of any additional income after your goals are completed until you have reached `${rule.maximumCentsProperty.valueOrNull?.formatCentsAsCurrency() ?? '?'}` in this envelope.',
    );
  }
}
