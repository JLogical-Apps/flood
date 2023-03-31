import 'package:example/features/envelope_rule/percent_rule.dart';
import 'package:jlogical_utils_core/jlogical_utils_core.dart';

class FirstfruitEnvelopeRule extends PercentRule {
  static const rulePriority = 0;

  @override
  int get priority => rulePriority;

  @override
  List<ValueObjectBehavior> get behaviors => super.behaviors + [ValueObjectBehavior.displayName('Firstfruit')];
}
