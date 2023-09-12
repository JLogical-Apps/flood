import 'dart:async';

import 'package:example/presentation/widget/envelope_rule/envelope_card_modifier.dart';
import 'package:example_core/features/envelope/envelope.dart';
import 'package:example_core/features/envelope/envelope_entity.dart';
import 'package:example_core/features/transaction/transfer_transaction.dart';
import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class TransferTransactionEditDialog {
  static Future<void> show(
    BuildContext context, {
    String? titleText,
    required EnvelopeEntity sourceEnvelopeEntity,
    required TransferTransaction transferTransaction,
    FutureOr Function(TransferTransaction result)? onAccept,
  }) async {
    final envelopeEntities = await EnvelopeEntity.getBudgetEnvelopesQuery(
            budgetId: transferTransaction.budgetProperty.value, isArchived: false)
        .all()
        .get(context.dropCoreComponent);
    envelopeEntities.removeWhere((entity) => entity == sourceEnvelopeEntity);

    late Port<Map<String, dynamic>> rawPort;
    final basePort = transferTransaction.asPort(context.corePondContext);
    rawPort = Port.of({
      'transaction': PortField.port(port: basePort),
      'targetEnvelope': PortField.option<EnvelopeEntity?, String>(
        options: [
          null,
          ...envelopeEntities,
        ],
        initialValue: null,
        submitMapper: (envelopeEntity) => envelopeEntity!.id!,
      ).isNotNull(),
      'transferType': PortField.option(
        options: TransferType.values,
        initialValue: TransferType.from,
      ),
    });

    await context.showStyledDialog(StyledPortDialog(
      port: rawPort.map((sourceData, port) {
        final transactionResult = sourceData['transaction'] as TransferTransaction;
        final transferType = sourceData['transferType'] as TransferType;
        final targetEnvelopeId = sourceData['targetEnvelope'] as String;
        transferType.modifyTransaction(transactionResult, sourceEnvelopeEntity.id!, targetEnvelopeId);
        return transactionResult;
      }),
      children: [
        StyledObjectPortBuilder(port: basePort),
        StyledDivider.subtle(),
        StyledRadioPortField<TransferType>(
          fieldName: 'transferType',
          stringMapper: (TransferType value) => value.name,
        ),
        StyledOptionPortField(
          fieldName: 'targetEnvelope',
          widgetMapper: (EnvelopeEntity? envelopeEntity) {
            final envelope = envelopeEntity?.value;
            final envelopeRuleModifier = EnvelopeRuleCardModifier.getModifier(envelope?.ruleProperty.value);
            return StyledList.row(
              children: [
                envelopeRuleModifier.getIcon(envelope?.ruleProperty.value),
                Expanded(
                  child: StyledText.body(envelopeEntity?.value.nameProperty.value ?? 'None'),
                ),
              ],
            );
          },
          labelText: 'Target',
        ),
        PortFieldBuilder<TransferType>(
          fieldName: 'transferType',
          builder: (context, field, value, error) {
            return PortBuilder(
              port: basePort,
              builder: (context, port) {
                return StyledMarkdown(value.noteGetter(
                  sourceEnvelopeEntity.value,
                  (rawPort['targetEnvelope'] as EnvelopeEntity?)?.value,
                  basePort['amount'],
                ));
              },
            );
          },
        ),
      ],
      onAccept: onAccept,
    ));
  }
}

enum TransferType {
  from(
    name: 'From',
    noteGetter: _getFromNote,
    transactionModifier: _modifyFrom,
  ),
  to(
    name: 'To',
    noteGetter: _getToNote,
    transactionModifier: _modifyTo,
  );

  final String name;
  final String Function(Envelope sourceEnvelope, Envelope? transferEnvelope, int? transferAmountCents) noteGetter;
  final Function(TransferTransaction transaction, String sourceEnvelopeId, String targetEnvelopeId)?
      transactionModifier;

  const TransferType({
    required this.name,
    required this.noteGetter,
    required this.transactionModifier,
  });

  void modifyTransaction(TransferTransaction transaction, String sourceEnvelopeId, String targetEnvelopeId) {
    transactionModifier?.call(transaction, sourceEnvelopeId, targetEnvelopeId);
  }

  static String _getFromNote(Envelope sourceEnvelope, Envelope? transferEnvelope, int? transferAmountCents) {
    return 'Transfer `${transferAmountCents?.formatCentsAsCurrency() ?? '?'}` to `${sourceEnvelope.nameProperty.value}` from `${transferEnvelope?.nameProperty.value ?? '?'}`';
  }

  static String _getToNote(Envelope sourceEnvelope, Envelope? transferEnvelope, int? transferAmountCents) {
    return 'Transfer `${transferAmountCents?.formatCentsAsCurrency() ?? '?'}` from `${sourceEnvelope.nameProperty.value}` to `${transferEnvelope?.nameProperty.value ?? '?'}`';
  }

  static _modifyFrom(TransferTransaction transaction, String sourceEnvelopeId, String targetEnvelopeId) {
    transaction
      ..fromEnvelopeProperty.set(targetEnvelopeId)
      ..toEnvelopeProperty.set(sourceEnvelopeId);
  }

  static _modifyTo(TransferTransaction transaction, String sourceEnvelopeId, String targetEnvelopeId) {
    transaction
      ..fromEnvelopeProperty.set(sourceEnvelopeId)
      ..toEnvelopeProperty.set(targetEnvelopeId);
  }
}
