/// A change in a budget after applying a transaction.
class BudgetChange {
  /// Maps each modified envelope id to the difference of cents it gained.
  /// Positive cents means it gained money, negative means it lost money.
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
