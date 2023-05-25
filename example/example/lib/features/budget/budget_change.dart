import 'package:example/features/envelope/envelope.dart';

/// A change in a budget after applying a transaction.
class BudgetChange {
  final Map<String, Envelope> modifiedEnvelopeById;

  const BudgetChange({
    required this.modifiedEnvelopeById,
  });
}
