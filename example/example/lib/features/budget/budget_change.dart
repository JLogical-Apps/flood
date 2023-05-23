/// A change in a budget after applying a transaction.
class BudgetChange {
  /// Maps each modified envelope id to the new value of cents it has.
  final Map<String, int> modifiedCentsByEnvelopeId;

  /// Whether the budget change represents an income in the budget.
  final bool isIncome;

  const BudgetChange({
    required this.modifiedCentsByEnvelopeId,
    required this.isIncome,
  });

  int getModifiedCents(String envelopeId) {
    return modifiedCentsByEnvelopeId[envelopeId] ?? 0;
  }
}
