import 'package:example/features/transaction/budget_transaction.dart';
import 'package:example/presentation/widget/transaction/envelope_transaction_card_modifier.dart';
import 'package:example/presentation/widget/transaction/income_transaction_card_modifier.dart';
import 'package:example/presentation/widget/transaction/transaction_view_context.dart';
import 'package:example/presentation/widget/transaction/transfer_transaction_card_modifier.dart';
import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

abstract class TransactionCardModifier<B extends BudgetTransaction> with IsTypedModifier<B, BudgetTransaction> {
  Widget buildCard(B transaction, String? id, TransactionViewContext transactionViewContext);

  StyledDialog buildDialog(B transaction);

  static final transactionCardModifierResolver =
      ModifierResolver<TransactionCardModifier, BudgetTransaction>(modifiers: [
    EnvelopeTransactionCardModifier(),
    IncomeTransactionCardModifier(),
    TransferTransactionCardModifier(),
  ]);

  static TransactionCardModifier getModifier(BudgetTransaction transaction) {
    return transactionCardModifierResolver.resolve(transaction);
  }
}
