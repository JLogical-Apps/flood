import 'package:example/features/envelope_rule/percent_rule.dart';

class FirstfruitEnvelopeRule extends PercentRule {
  static const rulePriority = 0;

  @override
  int get priority => rulePriority;
}
