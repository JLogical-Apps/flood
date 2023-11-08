import 'package:example/presentation/pages/envelope/envelope_page.dart';
import 'package:example/presentation/style.dart';
import 'package:example/presentation/widget/date/date_chip.dart';
import 'package:example/presentation/widget/transaction/transaction_card_modifier.dart';
import 'package:example/presentation/widget/transaction/transaction_view_context.dart';
import 'package:example_core/features/envelope/envelope_entity.dart';
import 'package:example_core/features/transaction/income_transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class IncomeTransactionCardModifier extends TransactionCardModifier<IncomeTransaction> {
  @override
  Widget buildCard({
    required IncomeTransaction transaction,
    required TransactionViewContext transactionViewContext,
    List<ActionItem> actions = const [],
  }) {
    return Builder(
      builder: (context) {
        return StyledCard(
          leading: DateChip(date: transaction.transactionDateProperty.value.time),
          title: StyledText.h6.withColor(transaction.totalCents >= 0 ? Colors.green : Colors.red)(_getTitleText(
            transactionViewContext: transactionViewContext,
            incomeTransaction: transaction,
          )),
          onPressed: () => context.showStyledDialog(buildDialog(transaction: transaction, actions: actions)),
        );
      },
    );
  }

  StyledDialog buildDialog({required IncomeTransaction transaction, List<ActionItem> actions = const []}) {
    return StyledDialog(
      titleText: 'Income',
      actions: actions,
      body: HookBuilder(
        builder: (context) {
          final envelopeEntityModels = useQueries(useMemoized(() => transaction.centsByEnvelopeIdProperty.value.keys
              .map((envelopeId) => Query.getById<EnvelopeEntity>(envelopeId))
              .toList()));

          return StyledList.column(
            children: [
              StyledTextSpan(
                [
                  StyledText.body('Add Income of '),
                  StyledText.body.withColor(Colors.green)(transaction.totalCents.formatCentsAsCurrency()),
                  StyledText.body(' on '),
                  StyledText.body
                      .withColor(Colors.green)(transaction.transactionDateProperty.value.time.format(showTime: false)),
                ],
              ),
              ...envelopeEntityModels.map((model) {
                return ModelBuilder(
                  model: model,
                  builder: (EnvelopeEntity? envelopeEntity) {
                    if (envelopeEntity == null) {
                      return StyledLoadingIndicator();
                    }

                    final cents = transaction.centsByEnvelopeIdProperty.value[envelopeEntity.id!];
                    if (cents == null) {
                      return StyledLoadingIndicator();
                    }

                    return StyledCard(
                      title: StyledText.h6.withColor(Color(envelopeEntity.value.colorProperty.value))(
                          envelopeEntity.value.nameProperty.value),
                      body: StyledText.body.withColor(getCentsColor(cents))(cents.formatCentsAsCurrency()),
                      onPressed: () => context.push(EnvelopeRoute()..idProperty.set(envelopeEntity.id!)),
                    );
                  },
                );
              }),
            ],
          );
        },
      ),
    );
  }

  String _getTitleText({
    required TransactionViewContext transactionViewContext,
    required IncomeTransaction incomeTransaction,
  }) {
    if (transactionViewContext is BudgetTransactionViewContext) {
      return 'Income: ${incomeTransaction.totalCents.formatCentsAsCurrency()}';
    } else if (transactionViewContext is EnvelopeTransactionViewContext) {
      return 'Income: ${incomeTransaction.centsByEnvelopeIdProperty.value[transactionViewContext.envelopeId]?.formatCentsAsCurrency() ?? '?'}';
    }

    throw Exception('Unhandled transaction view context');
  }
}
