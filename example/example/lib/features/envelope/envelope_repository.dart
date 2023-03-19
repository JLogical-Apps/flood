import 'package:example/features/envelope/envelope.dart';
import 'package:example/features/envelope/envelope_entity.dart';
import 'package:example/features/envelope_rule/daily_time_rule.dart';
import 'package:example/features/envelope_rule/envelope_rule.dart';
import 'package:example/features/envelope_rule/firstfruit_envelope_rule.dart';
import 'package:example/features/envelope_rule/monthly_time_rule.dart';
import 'package:example/features/envelope_rule/repeating_goal_envelope_rule.dart';
import 'package:example/features/envelope_rule/surplus_envelope_rule.dart';
import 'package:example/features/envelope_rule/target_goal_envelope_rule.dart';
import 'package:example/features/envelope_rule/time_rule.dart';
import 'package:jlogical_utils_core/jlogical_utils_core.dart';

class EnvelopeRepository with IsRepositoryWrapper {
  @override
  late Repository repository = Repository.memory()
      .forType<EnvelopeEntity, Envelope>(
        EnvelopeEntity.new,
        Envelope.new,
        entityTypeName: 'EnvelopeEntity',
        valueObjectTypeName: 'Envelope',
      )
      .withEmbeddedAbstractType<EnvelopeRule>(valueObjectTypeName: 'EnvelopeRule')
      .withEmbeddedType<FirstfruitEnvelopeRule>(
        FirstfruitEnvelopeRule.new,
        valueObjectTypeName: 'FirstfruitEnvelopeRule',
        valueObjectParents: [EnvelopeRule],
      )
      .withEmbeddedType<RepeatingGoalEnvelopeRule>(
        RepeatingGoalEnvelopeRule.new,
        valueObjectTypeName: 'RepeatingGoalEnvelopeRule',
        valueObjectParents: [EnvelopeRule],
      )
      .withEmbeddedType<TargetGoalEnvelopeRule>(
        TargetGoalEnvelopeRule.new,
        valueObjectTypeName: 'TargetGoalEnvelopeRule',
        valueObjectParents: [EnvelopeRule],
      )
      .withEmbeddedType<SurplusEnvelopeRule>(
        SurplusEnvelopeRule.new,
        valueObjectTypeName: 'SurplusEnvelopeRule',
        valueObjectParents: [EnvelopeRule],
      )
      .withEmbeddedAbstractType<TimeRule>(valueObjectTypeName: 'TimeRule')
      .withEmbeddedType<DailyTimeRule>(
        DailyTimeRule.new,
        valueObjectTypeName: 'DailyTimeRule',
        valueObjectParents: [TimeRule],
      )
      .withEmbeddedType<MonthlyTimeRule>(
        MonthlyTimeRule.new,
        valueObjectTypeName: 'MonthlyTimeRule',
        valueObjectParents: [TimeRule],
      );
}
