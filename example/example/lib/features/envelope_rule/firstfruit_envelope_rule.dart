import 'package:example/features/envelope/envelope.dart';
import 'package:example/features/envelope_rule/envelope_rule.dart';
import 'package:jlogical_utils_core/jlogical_utils_core.dart';

class FirstfruitEnvelopeRule extends EnvelopeRule {
  static const rulePriority = 0;

  late final percentProperty = field<double>(name: 'percent').required();

  @override
  List<ValueObjectBehavior> get behaviors => [percentProperty];

  @override
  int get priority => rulePriority;

  @override
  int requestIncome(Envelope envelope, int incomeCents, bool isExtraIncome) {
    throw UnimplementedError();
  }
}
