import 'package:example/features/envelope_rule/envelope_rule.dart';
import 'package:jlogical_utils_core/jlogical_utils_core.dart';

class RepeatingGoalEnvelopeRule extends EnvelopeRule {
  late final goalCentsProperty = field<int>(name: 'goal').required();

  @override
  List<ValueObjectBehavior> get behaviors => [goalCentsProperty];
}
