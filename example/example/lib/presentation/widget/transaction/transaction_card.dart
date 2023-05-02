import 'package:example/features/transaction/budget_transaction.dart';
import 'package:example/presentation/widget/transaction/transaction_card_modifier.dart';
import 'package:example/presentation/widget/transaction/transaction_view_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class TransactionCard extends HookWidget {
  final BudgetTransaction budgetTransaction;
  final TransactionViewContext transactionViewContext;
  final List<ActionItem> actions;

  const TransactionCard({
    super.key,
    required this.budgetTransaction,
    required this.transactionViewContext,
    this.actions = const [],
  });

  @override
  Widget build(BuildContext context) {
    final transactionCardModifier = TransactionCardModifier.getModifier(budgetTransaction);
    return transactionCardModifier.buildCard(
      transaction: budgetTransaction,
      transactionViewContext: transactionViewContext,
      actions: actions,
    );
  }
}
