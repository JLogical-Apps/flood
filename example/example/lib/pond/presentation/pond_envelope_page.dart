import 'package:example/pond/domain/budget_transaction/budget_transaction.dart';
import 'package:example/pond/domain/budget_transaction/budget_transaction_entity.dart';
import 'package:example/pond/domain/budget_transaction/envelope_transaction.dart';
import 'package:example/pond/domain/budget_transaction/envelope_transaction_entity.dart';
import 'package:example/pond/domain/envelope/envelope_entity.dart';
import 'package:example/pond/presentation/pond_login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

import 'transaction_card.dart';

class PondEnvelopePage extends HookWidget {
  final String envelopeId;

  const PondEnvelopePage({required this.envelopeId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final envelopeEntityController = useEntity<EnvelopeEntity>(envelopeId);
    final transactionsQueryController = useQuery(
      Query.from<BudgetTransactionEntity>()
          .where(BudgetTransaction.affectedEnvelopesField, contains: envelopeId)
          .paginate(),
    );

    return StyleProvider(
      style: PondLoginPage.style,
      child: Builder(
        builder: (context) {
          return ModelBuilder.styledPage(
            model: envelopeEntityController.model,
            builder: (EnvelopeEntity envelopeEntity) {
              final envelope = envelopeEntity.value;
              return StyledPage(
                onRefresh: () => Future.wait([
                  envelopeEntityController.reload(),
                  transactionsQueryController.reload(),
                ]),
                titleText: '${envelope.nameProperty.value}\n${envelope.amountProperty.value!.formatCentsAsCurrency()}',
                body: ScrollColumn.withScrollbar(
                  children: [
                    ModelBuilder.styled(
                      model: transactionsQueryController.model,
                      builder: (QueryPaginationResultController<BudgetTransactionEntity> budgetTransactionsController) {
                        return StyledCategory.medium(
                          headerText: 'Transactions',
                          actions: [
                            ActionItem(
                              name: 'Create Payment',
                              description: 'Create new payment',
                              color: Colors.green,
                              leading: Icon(Icons.swap_calls),
                              onPerform: () async {
                                final data = await StyledDialog.smartForm(context: context, children: [
                                  StyledSmartTextField(
                                    name: 'name',
                                    label: 'Name',
                                    validators: [
                                      Validation.required(),
                                    ],
                                  ),
                                  StyledSmartTextField(
                                    name: 'amount',
                                    label: 'Amount',
                                    validators: [
                                      Validation.required(),
                                      Validation.isCurrency(),
                                    ],
                                  ),
                                ]).show(context);

                                if (data == null) {
                                  return;
                                }

                                final amountCents =
                                    (data['amount'].toString().tryParseDoubleAfterClean()! * 100).round();
                                final envelopeTransaction = EnvelopeTransaction()
                                  ..nameProperty.value = data['name']
                                  ..amountProperty.value = amountCents
                                  ..budgetProperty.value = envelope.budgetProperty.value
                                  ..envelopeProperty.value = envelopeId;
                                final envelopeTransactionEntity = EnvelopeTransactionEntity()
                                  ..value = envelopeTransaction;
                                await envelopeTransactionEntity.create();
                              },
                            ),
                          ],
                          noChildrenWidget: StyledContentSubtitleText('No transactions'),
                          children: [
                            ...budgetTransactionsController.results.map((transactionEntity) => TransactionCard(
                                  transactionId: transactionEntity.id!,
                                  key: ValueKey(transactionEntity.id),
                                )),
                            if (budgetTransactionsController.canLoadMore)
                              StyledButton.low(
                                text: 'Load More',
                                onTapped: () async {
                                  await budgetTransactionsController.loadMore();
                                },
                              ),
                          ],
                        );
                      },
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
