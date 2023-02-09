import 'package:example/features/envelope_rule/envelope_rule.dart';
import 'package:jlogical_utils_core/jlogical_utils_core.dart';

class FirstfruitEnvelopeRule extends EnvelopeRule {
  late final percentProperty = field<double>(name: 'percent').required();

  @override
  List<ValueObjectBehavior> get behaviors => [percentProperty];
}
