import 'package:example/features/envelope/envelope.dart';
import 'package:example/features/envelope_rule/envelope_rule.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

abstract class PercentRule extends EnvelopeRule {
  static const percentField = 'percent';
  late final percentProperty = field<double>(name: percentField).withDisplayName('Percent').required();

  /// The maximum number of cents before requesting stops.
  /// If [null], then doesn't stop requesting cents.
  static const maximumCentsField = 'maximumCents';
  late final maximumCentsProperty = field<int>(name: maximumCentsField).withDisplayName('Target (\$)');

  @override
  int requestIncome({
    required DropCoreContext context,
    required int incomeCents,
    required Envelope envelope,
    required bool isExtraIncome,
  }) {
    final percentRequest = (incomeCents * (percentProperty.value / 100)).round();

    // If this is extra income, do not worry about capping at the maximum cents.
    if (maximumCentsProperty.value == null || isExtraIncome) {
      return percentRequest;
    }

    final centsUntilMax = maximumCentsProperty.value! - envelope.amountCentsProperty.value;
    if (centsUntilMax < 0) {
      return 0;
    }

    return percentRequest.clamp(0, centsUntilMax);
  }

  @override
  List<ValueObjectBehavior> get behaviors => super.behaviors + [percentProperty, maximumCentsProperty];
}
