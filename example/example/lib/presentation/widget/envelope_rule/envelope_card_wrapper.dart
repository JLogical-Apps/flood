import 'package:example/features/envelope_rule/envelope_rule.dart';
import 'package:example/presentation/widget/envelope_rule/firstfruit_envelope_card_wrapper.dart';
import 'package:example/presentation/widget/envelope_rule/none_envelope_card_wrapper.dart';
import 'package:example/presentation/widget/envelope_rule/repeating_goal_envelope_card_wrapper.dart';
import 'package:example/presentation/widget/envelope_rule/surplus_envelope_rule_wrapper.dart';
import 'package:example/presentation/widget/envelope_rule/target_goal_envelope_rule_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

abstract class EnvelopeRuleCardWrapper<R extends EnvelopeRule?> with IsTypedWrapper<R, EnvelopeRule?> {
  String getName(R rule);

  Widget getIcon(R rule);

  Widget getDescription(R rule);

  Port<R> getPort({required CorePondContext context, R? initialRule});

  Widget getPortBuilder(Port<R> port);

  static final envelopeRuleCardWrapperResolver = WrapperResolver<EnvelopeRuleCardWrapper, EnvelopeRule?>(wrappers: [
    FirstfruitEnvelopeCardWrapper(),
    RepeatingGoalEnvelopeCardWrapper(),
    TargetGoalEnvelopeCardWrapper(),
    SurplusEnvelopeCardWrapper(),
    NoneEnvelopeCardWrapper(),
  ]);

  static EnvelopeRuleCardWrapper getWrapper(EnvelopeRule? envelopeRule) {
    return envelopeRuleCardWrapperResolver.resolveOrNull(envelopeRule) ?? NoneEnvelopeCardWrapper();
  }
}
