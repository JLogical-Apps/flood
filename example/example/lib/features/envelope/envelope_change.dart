import 'package:example/features/envelope_rule/envelope_rule.dart';

/// Defines a change that a EnvelopeRule had on an Envelope.
class EnvelopeChange {
  /// The new envelope rule to be applied after the income change.
  /// Null if no new envelope rule needs to be applied.
  final EnvelopeRule? ruleChange;

  const EnvelopeChange({this.ruleChange});
}
