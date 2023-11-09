import 'package:example/presentation/widget/transaction/transaction_card_modifier.dart';
import 'package:example/presentation/widget/transaction/transaction_view_context.dart';
import 'package:example_core/features/transaction/budget_transaction_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class TransactionEntityCardList extends HookWidget {
  final List<BudgetTransactionEntity> budgetTransactionEntities;
  final TransactionViewContext initialTransactionViewContext;
  final List<ActionItem> Function(BudgetTransactionEntity transactionEntity) actionsGetter;
  final String? ifEmptyText;

  const TransactionEntityCardList({
    super.key,
    required this.budgetTransactionEntities,
    required this.initialTransactionViewContext,
    required this.actionsGetter,
    this.ifEmptyText,
  });

  @override
  Widget build(BuildContext context) {
    var transactionViewContext = initialTransactionViewContext;
    final children = <Widget>[];

    for (final budgetTransactionEntity in budgetTransactionEntities) {
      final transactionCardModifier = TransactionCardModifier.getModifier(budgetTransactionEntity.value);

      children.add(transactionCardModifier.buildCard(
        transaction: budgetTransactionEntity.value,
        transactionViewContext: transactionViewContext,
        actions: actionsGetter(budgetTransactionEntity),
      ));

      transactionViewContext = transactionCardModifier.getPreviousTransactionViewContext(
        budgetTransactionEntity.value,
        transactionViewContext,
      );
    }

    return StyledList.column(
      children: children,
      ifEmptyText: ifEmptyText,
    );
  }
}
