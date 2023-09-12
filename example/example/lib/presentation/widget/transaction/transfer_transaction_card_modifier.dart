import 'package:example/presentation/style.dart';
import 'package:example/presentation/widget/transaction/transaction_card_modifier.dart';
import 'package:example/presentation/widget/transaction/transaction_view_context.dart';
import 'package:example_core/features/envelope/envelope.dart';
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
      final fromEnvelope = useEntityOrNull<EnvelopeEntity>(transaction.fromEnvelopeProperty.value)
          .getOrNull()
          ?.mapIfNonNull((entity) => entity.value);
      final toEnvelope = useEntityOrNull<EnvelopeEntity>(transaction.toEnvelopeProperty.value)
          .getOrNull()
          ?.mapIfNonNull((entity) => entity.value);

      return StyledCard(
        title: _getTitle(
          transactionViewContext: transactionViewContext,
          transaction: transaction,
          fromEnvelope: fromEnvelope,
          toEnvelope: toEnvelope,
        ),
        bodyText: [transaction.transactionDateProperty.value.time.format(showTime: false)].join(' - '),
        onPressed: () => context.showStyledDialog(buildDialog(transaction: transaction, actions: actions)),
      );
    });
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

  Widget _getTitle({
    required TransactionViewContext transactionViewContext,
    required TransferTransaction transaction,
    required Envelope? fromEnvelope,
    required Envelope? toEnvelope,
  }) {
    if (transactionViewContext is BudgetTransactionViewContext) {
      return StyledText.h6.withColor(Colors.blue)(
          'Transfer ${transaction.amountCentsProperty.value.formatCentsAsCurrency()} from ${fromEnvelope?.nameProperty.value ?? '?'} to ${toEnvelope?.nameProperty.value ?? '?'}');
    }
    if (transactionViewContext is EnvelopeTransactionViewContext) {
      final isFrom = transaction.fromEnvelopeProperty.value == transactionViewContext.envelopeId;
      final cents = isFrom ? -transaction.amountCentsProperty.value : transaction.amountCentsProperty.value;
      final text = isFrom
          ? 'Transfer ${transaction.amountCentsProperty.value.formatCentsAsCurrency()} to ${toEnvelope?.nameProperty.value ?? '?'}'
          : 'Transfer ${transaction.amountCentsProperty.value.formatCentsAsCurrency()} from ${fromEnvelope?.nameProperty.value ?? '?'}';
      return StyledText.h6.withColor(getCentsColor(cents))(text);
    }

    throw Exception('Unhandled transfer card type.');
  }
}
