import 'package:example/features/envelope_rule/target_goal_envelope_rule.dart';
import 'package:example/presentation/widget/envelope_rule/envelope_card_modifier.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class TargetGoalEnvelopeCardModifier extends EnvelopeRuleCardModifier<TargetGoalEnvelopeRule> {
  @override
  String getName(TargetGoalEnvelopeRule rule) {
    return 'Target Goal';
  }

  @override
  Widget getIcon(TargetGoalEnvelopeRule rule) {
    return StyledIcon(FontAwesomeIcons.bullseye);
  }

  @override
  Widget getDescription(TargetGoalEnvelopeRule rule) {
    return StyledMarkdown(
      'Valet wil collect `${rule.percentProperty.value.formatIntOrDouble()}`% of any additional income after your goals are completed until you have reached `${rule.maximumCentsProperty.value!.formatCentsAsCurrency()}` in this envelope.',
    );
  }
}
