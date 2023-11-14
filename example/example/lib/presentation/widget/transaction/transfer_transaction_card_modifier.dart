import 'package:example/presentation/pages/envelope/envelope_page.dart';
import 'package:example/presentation/style.dart';
import 'package:example/presentation/widget/date/date_chip.dart';
import 'package:example/presentation/widget/envelope/envelope_chip.dart';
import 'package:example/presentation/widget/transaction/transaction_card_modifier.dart';
import 'package:example/presentation/widget/transaction/transaction_view_context.dart';
import 'package:example_core/features/envelope/envelope_entity.dart';
import 'package:example_core/features/transaction/transfer_transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class TransferTransactionCardModifier extends TransactionCardModifier<TransferTransaction> {
  @override
  Widget buildCard({
    required TransferTransaction transaction,
    required TransactionViewContext transactionViewContext,
    List<ActionItem> actions = const [],
  }) {
    return HookBuilder(builder: (context) {
      final fromEnvelopeModel = useEntityOrNull<EnvelopeEntity>(transaction.fromEnvelopeProperty.value);
      final toEnvelopeModel = useEntityOrNull<EnvelopeEntity>(transaction.toEnvelopeProperty.value);

      return ModelBuilder(
          model: Model.union([fromEnvelopeModel, toEnvelopeModel]),
          builder: (List values) {
            final [EnvelopeEntity? fromEnvelopeEntity, EnvelopeEntity? toEnvelopeEntity] = values;

            final affectedCents = getAffectedCentsInContext(transactionViewContext, transaction: transaction);

            return StyledCard(
              leading: DateChip(date: transaction.transactionDateProperty.value.time),
              title: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: buildTitle(
                  context,
                  transaction: transaction,
                  transactionViewContext: transactionViewContext,
                  fromEnvelopeEntity: fromEnvelopeEntity,
                  toEnvelopeEntity: toEnvelopeEntity,
                ),
              ),
              trailing: StyledList.column(
                children: [
                  if (affectedCents != null)
                    StyledText.body
                        .withColor(getCentsColor(affectedCents))(affectedCents.formatCentsAsCurrencySigned()),
                  if (transactionViewContext.currentCents != null)
                    StyledText.body.subtle(transactionViewContext.currentCents!.formatCentsAsCurrency()),
                ],
              ),
              onPressed: () => context.showStyledDialog(buildDialog(transaction: transaction, actions: actions)),
            );
          });
    });
  }

  int? getAffectedCentsInContext(TransactionViewContext context, {required TransferTransaction transaction}) {
    if (context is! EnvelopeTransactionViewContext) {
      return null;
    }

    return transaction.gainedCentsByEnvelopeId[context.envelopeId];
  }

  @override
  TransactionViewContext getPreviousTransactionViewContext(
    TransferTransaction transaction,
    TransactionViewContext transactionViewContext,
  ) {
    if (transactionViewContext.currentCents == null) {
      return transactionViewContext;
    }

    if (transactionViewContext is EnvelopeTransactionViewContext) {
      final envelopeGainedCents = transaction.gainedCentsByEnvelopeId[transactionViewContext.envelopeId] ?? 0;
      return transactionViewContext.copyWithCents(transactionViewContext.currentCents! - envelopeGainedCents);
    } else if (transactionViewContext is BudgetTransactionViewContext) {
      return transactionViewContext;
    }

    throw UnimplementedError('Unrecognized TransactionViewContext!');
  }

  List<Widget> buildTitle(
    BuildContext context, {
    required TransferTransaction transaction,
    required TransactionViewContext transactionViewContext,
    required EnvelopeEntity? fromEnvelopeEntity,
    required EnvelopeEntity? toEnvelopeEntity,
  }) {
    if (transactionViewContext is BudgetTransactionViewContext) {
      return [
        StyledText.h6
            .withColor(Colors.blue)('Transfer ${transaction.amountCentsProperty.value.formatCentsAsCurrency()} from '),
        if (fromEnvelopeEntity == null) StyledText.h6('...'),
        if (fromEnvelopeEntity != null)
          EnvelopeChip(
            envelope: fromEnvelopeEntity.value,
            onPressed: () => context.push(EnvelopeRoute()..idProperty.set(fromEnvelopeEntity.id!)),
          ),
        StyledText.h6.withColor(Colors.blue)(' to '),
        if (toEnvelopeEntity == null) StyledText.h6('...'),
        if (toEnvelopeEntity != null)
          EnvelopeChip(
            envelope: toEnvelopeEntity.value,
            onPressed: () => context.push(EnvelopeRoute()..idProperty.set(toEnvelopeEntity.id!)),
          ),
      ];
    }
    if (transactionViewContext is EnvelopeTransactionViewContext) {
      final isFrom = transaction.fromEnvelopeProperty.value == transactionViewContext.envelopeId;
      final cents = isFrom ? -transaction.amountCentsProperty.value : transaction.amountCentsProperty.value;
      final otherEnvelopeEntity = isFrom ? toEnvelopeEntity : fromEnvelopeEntity;
      return [
        StyledText.h6.withColor(getCentsColor(cents))('Transfer ${isFrom ? 'to' : 'from'} '),
        if (otherEnvelopeEntity != null)
          EnvelopeChip(
            envelope: otherEnvelopeEntity.value,
            onPressed: () => context.push(EnvelopeRoute()..idProperty.set(otherEnvelopeEntity.id!)),
          ),
      ];
    }

    throw UnimplementedError();
  }

  StyledDialog buildDialog({
    required TransferTransaction transaction,
    List<ActionItem> actions = const [],
  }) {
    return StyledDialog(
      titleText: 'Transfer',
      actions: actions,
      body: HookBuilder(
        builder: (context) {
          final fromEnvelope = useEntityOrNull<EnvelopeEntity>(transaction.fromEnvelopeProperty.value)
              .getOrNull()
              ?.mapIfNonNull((entity) => entity.value);
          final toEnvelope = useEntityOrNull<EnvelopeEntity>(transaction.toEnvelopeProperty.value)
              .getOrNull()
              ?.mapIfNonNull((entity) => entity.value);

          return StyledTextSpan(
            [
              StyledText.body('Transfer '),
              StyledText.body.withColor(Colors.green)(transaction.amountCentsProperty.value.formatCentsAsCurrency()),
              StyledText.body(' from '),
              StyledText.body.withColor(Color(fromEnvelope?.colorProperty.value ?? 0xffffffff))(
                  fromEnvelope?.nameProperty.value ?? '?'),
              StyledText.body(' to '),
              StyledText.body.withColor(Color(toEnvelope?.colorProperty.value ?? 0xffffffff))(
                  toEnvelope?.nameProperty.value ?? '?'),
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
