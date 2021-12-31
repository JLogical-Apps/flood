import 'package:example/pond/domain/budget/budget_entity.dart';
import 'package:example/pond/domain/budget_transaction/budget_transaction.dart';
import 'package:example/pond/domain/budget_transaction/budget_transaction_entity.dart';
import 'package:example/pond/domain/envelope/envelope.dart';
import 'package:example/pond/domain/envelope/envelope_entity.dart';
import 'package:example/pond/presentation/pond_users_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class PondBudgetPage extends HookWidget {
  final String budgetId;

  const PondBudgetPage({required this.budgetId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final budgetEntityController = useEntity<BudgetEntity>(budgetId);
    final envelopesQueryController = useQuery(
      Query.from<EnvelopeEntity>().where(Envelope.budgetField, isEqualTo: budgetId).paginate(),
    );
    final transactionsQueryController = useQuery(
      Query.from<BudgetTransactionEntity>().where(BudgetTransaction.budgetField, isEqualTo: budgetId).paginate(),
    );
    return StyleProvider(
      style: PondUsersPage.style,
      child: Builder(
        builder: (context) {
          return ModelBuilder.styledPage(
            model: budgetEntityController.model,
            builder: (BudgetEntity budgetEntity) {
              return ScrollColumn.withScrollbar(children: [
                ModelBuilder.styled(
                  model: envelopesQueryController.model,
                  builder: (QueryPaginationResultController<EnvelopeEntity> envelopesController) {
                    return StyledCategory.medium(
                      headerText: 'Envelopes',
                      actions: [],
                    );
                  },
                ),
                ModelBuilder.styled(
                  model: transactionsQueryController.model,
                  builder: (QueryPaginationResultController<BudgetTransactionEntity> budgetTransactionsController) {
                    return StyledCategory.medium(
                      headerText: 'Transactions',
                      actions: [],
                    );
                  },
                )
              ]);
            },
          );
        },
      ),
    );
  }
}
