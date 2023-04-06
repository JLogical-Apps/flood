import 'package:example/features/envelope_rule/envelope_rule.dart';
import 'package:example/presentation/widget/envelope_rule/firstfruit_envelope_card_modifier.dart';
import 'package:example/presentation/widget/envelope_rule/none_envelope_card_modifier.dart';
import 'package:example/presentation/widget/envelope_rule/repeating_goal_envelope_card_modifier.dart';
import 'package:example/presentation/widget/envelope_rule/surplus_envelope_rule_modifier.dart';
import 'package:example/presentation/widget/envelope_rule/target_goal_envelope_rule_modifier.dart';
import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

abstract class EnvelopeRuleCardModifier<R extends EnvelopeRule?> with IsTypedModifier<R, EnvelopeRule?> {
  String getName(R rule);

  Widget getIcon(R rule);

  Widget getDescription(R rule);

  static final envelopeRuleCardModifierResolver = ModifierResolver<EnvelopeRuleCardModifier, EnvelopeRule?>(modifiers: [
    FirstfruitEnvelopeCardModifier(),
    RepeatingGoalEnvelopeCardModifier(),
    TargetGoalEnvelopeCardModifier(),
    SurplusEnvelopeCardModifier(),
    NoneEnvelopeCardModifier(),
  ]);

  static EnvelopeRuleCardModifier getModifier(EnvelopeRule? envelopeRule) {
    return envelopeRuleCardModifierResolver.resolveOrNull(envelopeRule) ?? NoneEnvelopeCardModifier();
  }
}
