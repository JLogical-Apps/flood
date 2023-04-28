import 'package:example/features/transaction/budget_transaction.dart';
import 'package:example/presentation/widget/transaction/transaction_card_modifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TransactionCard extends HookWidget {
  final BudgetTransaction budgetTransaction;

  const TransactionCard({super.key, required this.budgetTransaction});

  @override
  Widget build(BuildContext context) {
    final transactionCardModifier = TransactionCardModifier.getModifier(budgetTransaction);
    return transactionCardModifier.buildCard(budgetTransaction);
  }
}
