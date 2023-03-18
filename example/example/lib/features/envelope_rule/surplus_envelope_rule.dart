import 'package:example/features/envelope/envelope.dart';
import 'package:example/features/envelope_rule/envelope_rule.dart';
import 'package:example/features/envelope_rule/target_goal_envelope_rule.dart';
import 'package:jlogical_utils_core/jlogical_utils_core.dart';

class SurplusEnvelopeRule extends EnvelopeRule {
  static const rulePriority = TargetGoalEnvelopeRule.rulePriority;

  static const percentField = 'percent';
  late final percentProperty = field<double>(name: percentField).required();

  @override
  List<ValueObjectBehavior> get behaviors => [percentProperty];

  @override
  int get priority => rulePriority;

  @override
  int requestIncome(Envelope envelope, int incomeCents, bool isExtraIncome) {
    throw UnimplementedError();
  }
}
