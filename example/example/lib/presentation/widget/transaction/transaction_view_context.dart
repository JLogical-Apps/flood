abstract class TransactionViewContext {
  factory TransactionViewContext.budget() = BudgetTransactionViewContext;

  factory TransactionViewContext.envelope({required String envelopeId}) = EnvelopeTransactionViewContext;
}

class BudgetTransactionViewContext implements TransactionViewContext {}

class EnvelopeTransactionViewContext implements TransactionViewContext {
  final String envelopeId;

  EnvelopeTransactionViewContext({required this.envelopeId});
}
