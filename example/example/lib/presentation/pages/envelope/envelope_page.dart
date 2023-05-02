import 'package:example/features/envelope/envelope.dart';
import 'package:example/features/envelope/envelope_entity.dart';
import 'package:example/features/transaction/budget_transaction_entity.dart';
import 'package:example/features/transaction/envelope_transaction.dart';
import 'package:example/features/transaction/envelope_transaction_entity.dart';
import 'package:example/features/transaction/transfer_transaction.dart';
import 'package:example/features/transaction/transfer_transaction_entity.dart';
import 'package:example/presentation/dialog/transaction/envelope_transaction_edit_dialog.dart';
import 'package:example/presentation/dialog/transaction/transfer_transaction_edit_dialog.dart';
import 'package:example/presentation/pages/home_page.dart';
import 'package:example/presentation/style.dart';
import 'package:example/presentation/widget/envelope_rule/envelope_card_modifier.dart';
import 'package:example/presentation/widget/transaction/transaction_card.dart';
import 'package:example/presentation/widget/transaction/transaction_view_context.dart';
import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class EnvelopePage extends AppPage {
  late final idProperty = field<String>(name: 'id').required();

  @override
  Widget build(BuildContext context) {
    final envelopeModel = useQuery(Query.getById<EnvelopeEntity>(idProperty.value));
    final envelopeTransactionsModel =
        useQuery(BudgetTransactionEntity.getEnvelopeTransactionsQuery(envelopeId: idProperty.value).paginate());

    return ModelBuilder.page(
      model: envelopeModel,
      builder: (EnvelopeEntity envelopeEntity) {
        final envelope = envelopeEntity.value;
        final envelopeRule = envelope.ruleProperty.value;
        final envelopeRuleCardWrapper = EnvelopeRuleCardModifier.getModifier(envelope.ruleProperty.value);
        return StyledPage(
          title: StyledText.h2.withColor(Color(envelope.colorProperty.value))(envelope.nameProperty.value),
          actions: [
            ActionItem(
              titleText: 'Edit',
              descriptionText: 'Edit this envelope.',
              color: Colors.orange,
              iconData: Icons.edit,
              onPerform: (context) async {
                await context.showStyledDialog(StyledPortDialog(
                  titleText: 'Edit Envelope',
                  port: envelope.asPort(context.corePondContext),
                  onAccept: (Envelope result) async {
                    await context.dropCoreComponent.update(envelopeEntity..value = result);
                  },
                ));
              },
            ),
            ActionItem(
              titleText: 'Transfer',
              descriptionText: 'Transfer money to/from this envelope.',
              color: Colors.blue,
              iconData: Icons.swap_horiz,
              onPerform: (context) async {
                await context.showStyledDialog(await TransferTransactionEditDialog.create(
                  context,
                  titleText: 'Create Transfer',
                  sourceEnvelopeEntity: envelopeEntity,
                  transferTransaction: TransferTransaction()..budgetProperty.set(envelope.budgetProperty.value),
                  onAccept: (TransferTransaction result) async {
                    final fromEnvelopeEntity = await Query.getById<EnvelopeEntity>(result.fromEnvelopeProperty.value)
                        .get(context.dropCoreComponent);
                    final toEnvelopeEntity = await Query.getById<EnvelopeEntity>(result.toEnvelopeProperty.value)
                        .get(context.dropCoreComponent);

                    await context.dropCoreComponent.updateEntity(
                      fromEnvelopeEntity,
                      (Envelope envelope) => envelope.amountCentsProperty
                          .set(envelope.amountCentsProperty.value - result.amountCentsProperty.value),
                    );
                    await context.dropCoreComponent.updateEntity(
                      toEnvelopeEntity,
                      (Envelope envelope) => envelope.amountCentsProperty
                          .set(envelope.amountCentsProperty.value + result.amountCentsProperty.value),
                    );

                    await context.dropCoreComponent.update(TransferTransactionEntity()..set(result));
                  },
                ));
              },
            ),
          ],
          body: StyledList.column.centered.scrollable(
            children: [
              StyledText.h4.withColor(getCentsColor(envelope.amountCentsProperty.value))(
                  envelope.amountCentsProperty.value.formatCentsAsCurrency()),
              StyledCard.subtle(
                titleText: envelopeRule?.getDisplayName() ?? 'None',
                leading: envelopeRuleCardWrapper.getIcon(envelopeRule),
                body: envelopeRuleCardWrapper.getDescription(envelopeRule),
              ),
              if (envelope.descriptionProperty.value?.isNotBlank == true)
                StyledText.body.italics(envelope.descriptionProperty.value!),
              StyledDivider(),
              StyledButton.strong(
                labelText: 'Create Transaction',
                iconData: Icons.add,
                onPressed: () async {
                  await context.showStyledDialog(EnvelopeTransactionEditDialog(
                    corePondContext: context.corePondContext,
                    titleText: 'Create Transaction',
                    envelopeTransaction: (EnvelopeTransaction()
                      ..envelopeProperty.set(envelopeEntity.id!)
                      ..budgetProperty.set(envelope.budgetProperty.value)),
                    onAccept: (EnvelopeTransaction envelopeTransaction) async {
                      final newEnvelope = Envelope()
                        ..copyFrom(context.dropCoreComponent, envelope)
                        ..amountCentsProperty
                            .set(envelope.amountCentsProperty.value + envelopeTransaction.amountCentsProperty.value);

                      await context.dropCoreComponent.update(envelopeEntity..value = newEnvelope);
                      await context.dropCoreComponent.update(EnvelopeTransactionEntity()..value = envelopeTransaction);
                    },
                  ));
                },
              ),
              PaginatedQueryModelBuilder(
                paginatedQueryModel: envelopeTransactionsModel,
                builder: (List<BudgetTransactionEntity> envelopeTransactionEntities, Future Function()? loadNext) {
                  return StyledList.column.withMinChildSize(150)(
                    children: envelopeTransactionEntities
                        .map((entity) => TransactionCard(
                              budgetTransaction: entity.value,
                              transactionViewContext: TransactionViewContext.envelope(envelopeId: envelopeEntity.id!),
                              actions: [
                                ActionItem(
                                  titleText: 'Delete',
                                  descriptionText: 'Delete this transaction.',
                                  iconData: Icons.delete,
                                  color: Colors.red,
                                  onPerform: (context) async {
                                    await context.showStyledDialog(StyledDialog.yesNo(
                                      titleText: 'Confirm Delete',
                                      bodyText:
                                          'Are you sure you want to delete this transaction? You cannot undo this.',
                                      onAccept: () async {
                                        await context.dropCoreComponent.delete(entity);
                                        Navigator.of(context).pop();
                                      },
                                    ));
                                  },
                                ),
                              ],
                            ))
                        .toList(),
                    ifEmptyText: 'There are no transactions in this envelope!',
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  PathDefinition get pathDefinition => PathDefinition.string('envelope').property(idProperty);

  @override
  AppPage copy() {
    return EnvelopePage();
  }

  @override
  AppPage? getParent() {
    return HomePage();
  }
}
