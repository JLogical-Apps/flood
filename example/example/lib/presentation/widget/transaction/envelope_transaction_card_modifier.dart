import 'package:example/presentation/pages/envelope/envelope_page.dart';
import 'package:example/presentation/style.dart';
import 'package:example/presentation/widget/date/date_chip.dart';
import 'package:example/presentation/widget/envelope/envelope_chip.dart';
import 'package:example/presentation/widget/transaction/transaction_card_modifier.dart';
import 'package:example/presentation/widget/transaction/transaction_view_context.dart';
import 'package:example_core/features/envelope/envelope_entity.dart';
import 'package:example_core/features/transaction/envelope_transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class EnvelopeTransactionCardModifier extends TransactionCardModifier<EnvelopeTransaction> {
  @override
  Widget buildCard({
    required EnvelopeTransaction transaction,
    required TransactionViewContext transactionViewContext,
    List<ActionItem> actions = const [],
  }) {
    final cents = transaction.amountCentsProperty.value;
    return HookBuilder(builder: (context) {
      final envelopeModel = useEntityOrNull<EnvelopeEntity>(transaction.envelopeProperty.value);

      return ModelBuilder(
          model: envelopeModel,
          builder: (EnvelopeEntity? envelopeEntity) {
            return StyledCard(
              leading: DateChip(date: transaction.transactionDateProperty.value.time),
              title: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  StyledText.h6
                      .withColor(getCentsColor(transaction.amountCentsProperty.value))
                      .strong(transaction.nameProperty.value),
                  if (transactionViewContext is BudgetTransactionViewContext && envelopeEntity != null) ...[
                    StyledText.h6(transaction.amountCentsProperty.value <= 0 ? ' from ' : ' to '),
                    EnvelopeChip(
                      envelope: envelopeEntity.value,
                      onPressed: () => context.push(EnvelopeRoute()..idProperty.set(envelopeEntity.id!)),
                    ),
                  ]
                ],
              ),
              trailing: StyledList.column(
                children: [
                  StyledText.body.withColor(getCentsColor(cents))(cents.formatCentsAsCurrencySigned()),
                  if (transactionViewContext.currentCents != null)
                    StyledText.body.subtle(transactionViewContext.currentCents!.formatCentsAsCurrency()),
                ],
              ),
              onPressed: () => context.showStyledDialog(buildDialog(transaction: transaction, actions: actions)),
            );
          });
    });
  }

  @override
  TransactionViewContext getPreviousTransactionViewContext(
    EnvelopeTransaction transaction,
    TransactionViewContext transactionViewContext,
  ) {
    if (transactionViewContext.currentCents == null) {
      return transactionViewContext;
    }

    return transactionViewContext
        .copyWithCents(transactionViewContext.currentCents! - transaction.amountCentsProperty.value);
  }

  StyledDialog buildDialog({required EnvelopeTransaction transaction, List<ActionItem> actions = const []}) {
    return StyledDialog(
      titleText: transaction.nameProperty.value,
      actions: actions,
      body: HookBuilder(
        builder: (context) {
          final envelope = useEntityOrNull<EnvelopeEntity>(transaction.envelopeProperty.value)
              .getOrNull()
              ?.mapIfNonNull((entity) => entity.value);

          return StyledTextSpan(
            [
              StyledText.body('Transfer '),
              StyledText.body.withColor(Colors.red)(transaction.amountCentsProperty.value.formatCentsAsCurrency()),
              StyledText.body(transaction.amountCentsProperty.value >= 0 ? ' to ' : ' from '),
              StyledText.body
                  .withColor(Color(envelope?.colorProperty.value ?? 0xffffffff))(envelope?.nameProperty.value ?? '?'),
              StyledText.body(' on '),
              StyledText.body
                  .withColor(Colors.green)(transaction.transactionDateProperty.value.time.format(showTime: false)),
            ],
          );
        },
      ),
    );
  }
}
