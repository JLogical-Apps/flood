import 'package:example/features/envelope/envelope.dart';
import 'package:jlogical_utils_core/jlogical_utils_core.dart';

abstract class EnvelopeRule extends ValueObject {
  /// The priority of the envelope rule. Smaller numbers are prioritized earlier than larger numbers.
  int get priority;

  /// Returns the requested amount of income for the rule given the [incomeCents].
  /// The requested amount does not guarantee that much will be applied to the envelope. It could be less or more.
  int requestIncome(Envelope envelope, int incomeCents, bool isExtraIncome);

  /// Applies new cents to the [envelope] and returns the envelope change.
  /// If [incomeCents] is negative, then an income transaction has been deleted from the envelope.
  /// Can return null if no change applied.
  Envelope? onAddIncome(Envelope envelope, int incomeCents) => null;

  /// Called when the envelope rule is first initialized or inflated.
  Envelope? onInitialize() => null;
}
