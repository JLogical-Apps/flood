import 'package:example/features/transaction/budget_transaction_entity.dart';
import 'package:example/presentation/pages/home_page.dart';
import 'package:example/presentation/widget/transaction/transaction_card_modifier.dart';
import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class TransactionPage extends AppPage {
  late final idProperty = field<String>(name: 'id').required();

  @override
  Widget build(BuildContext context) {
    final transactionEntityModel = useEntityOrNull<BudgetTransactionEntity>(idProperty.value);

    return ModelBuilder.page(
        model: transactionEntityModel,
        builder: (BudgetTransactionEntity? budgetTransactionEntity) {
          if (budgetTransactionEntity == null) {
            return StyledLoadingPage();
          }

          final budgetTransaction = budgetTransactionEntity.value;
          final transactionCardModifier = TransactionCardModifier.getModifier(budgetTransaction);

          return transactionCardModifier.buildDialog(budgetTransaction);
        });
  }

  @override
  PathDefinition get pathDefinition => PathDefinition.string('transaction').property(idProperty);

  @override
  AppPage copy() {
    return TransactionPage();
  }

  @override
  AppPage? getParent() {
    return HomePage();
  }
}
