import 'package:example/features/envelope/envelope.dart';
import 'package:example/features/envelope/envelope_entity.dart';
import 'package:example/features/transaction/envelope_transaction.dart';
import 'package:example/presentation/style.dart';
import 'package:example/presentation/widget/transaction/transaction_card_modifier.dart';
import 'package:example/presentation/widget/transaction/transaction_view_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class EnvelopeTransactionCardModifier extends TransactionCardModifier<EnvelopeTransaction> {
  @override
  Widget buildCard(EnvelopeTransaction transaction, String? id, TransactionViewContext transactionViewContext) {
    final cents = transaction.amountCentsProperty.value;
    return HookBuilder(builder: (context) {
      final envelope = useEntityOrNull<EnvelopeEntity>(transaction.envelopeProperty.value)
          .getOrNull()
          ?.mapIfNonNull((entity) => entity.value);

      return StyledCard(
        title: StyledText.h6.withColor(getCentsColor(cents))(_getTitleText(
          transactionViewContext: transactionViewContext,
          envelopeTransaction: transaction,
          envelope: envelope,
        )),
        bodyText:
            '${transaction.nameProperty.value} - ${transaction.transactionDateProperty.value.format(showTime: false)}',
        onPressed: id == null ? null : () => context.showStyledDialog(buildDialog(transaction)),
      );
    });
  }

  @override
  StyledDialog buildDialog(EnvelopeTransaction transaction) {
    return StyledDialog(
      titleText: transaction.nameProperty.value,
      actions: [
        ActionItem(
          titleText: 'Delete',
          descriptionText: 'Delete this transaction.',
          iconData: Icons.delete,
          color: Colors.red,
          onPerform: (_) async {},
        ),
      ],
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
              StyledText.body.withColor(Colors.green)(envelope?.nameProperty.value ?? '?'),
              StyledText.body(' on '),
              StyledText.body
                  .withColor(Colors.green)(transaction.transactionDateProperty.value.format(showTime: false)),
            ],
          );
        },
      ),
    );
  }

  String _getTitleText({
    required TransactionViewContext transactionViewContext,
    required EnvelopeTransaction envelopeTransaction,
    required Envelope? envelope,
  }) {
    if (transactionViewContext is BudgetTransactionViewContext) {
      final preposition = envelopeTransaction.amountCentsProperty.value >= 0 ? 'to' : 'from';
      return '${envelopeTransaction.amountCentsProperty.value.formatCentsAsCurrency()} $preposition ${envelope?.nameProperty.value ?? '?'}';
    } else if (transactionViewContext is EnvelopeTransactionViewContext) {
      return envelopeTransaction.amountCentsProperty.value.formatCentsAsCurrency();
    }

    throw Exception('Unhandled transaction view context!');
  }
}
