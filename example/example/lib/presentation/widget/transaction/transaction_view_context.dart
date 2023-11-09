abstract class TransactionViewContext {
  final int? currentCents;

  TransactionViewContext({required this.currentCents});

  factory TransactionViewContext.budget({required int? currentCents}) =>
      BudgetTransactionViewContext(currentCents: currentCents);

  factory TransactionViewContext.envelope({required String envelopeId, required int? currentCents}) =
      EnvelopeTransactionViewContext;

  TransactionViewContext copyWithCents(int newCents);
}

class BudgetTransactionViewContext extends TransactionViewContext {
  BudgetTransactionViewContext({required super.currentCents});

  @override
  TransactionViewContext copyWithCents(int newCents) {
    return BudgetTransactionViewContext(currentCents: newCents);
  }
}

class EnvelopeTransactionViewContext extends TransactionViewContext {
  final String envelopeId;

  EnvelopeTransactionViewContext({required this.envelopeId, required super.currentCents});

  @override
  TransactionViewContext copyWithCents(int newCents) {
    return EnvelopeTransactionViewContext(envelopeId: envelopeId, currentCents: newCents);
  }
}
