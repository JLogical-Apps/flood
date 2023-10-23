import 'package:example_core/features/envelope/envelope.dart';
import 'package:example_core/features/envelope_rule/envelope_rule.dart';
import 'package:jlogical_utils_core/jlogical_utils_core.dart';

abstract class PercentRule extends EnvelopeRule {
  static const percentField = 'percent';
  late final percentProperty = field<double>(name: percentField).withDisplayName('Percent (%)').required().isPositive();

  /// The maximum number of cents before requesting stops.
  /// If [null], then doesn't stop requesting cents.
  static const maximumCentsField = 'maximumCents';
  late final maximumCentsProperty = field<int>(name: maximumCentsField)
      .withDisplayName('Target (\$)')
      .currency()
      .hidden(() => isMaximumCentsHidden)
      .requiredOnEdit(!isMaximumCentsHidden)
      .isNonNegative();

  bool get isMaximumCentsHidden => true;

  @override
  int requestIncome(
    DropCoreContext context, {
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
  late final List<ValueObjectBehavior> behaviors = super.behaviors +
      [
        percentProperty,
        maximumCentsProperty,
        creationTime(),
      ];
}
