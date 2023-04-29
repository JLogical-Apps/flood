import 'package:example/features/envelope/envelope.dart';
import 'package:example/features/envelope/envelope_entity.dart';
import 'package:example/features/transaction/budget_transaction.dart';
import 'package:example/features/transaction/budget_transaction_entity.dart';
import 'package:example/features/transaction/envelope_transaction.dart';
import 'package:example/features/transaction/envelope_transaction_entity.dart';
import 'package:example/features/transaction/transfer_transaction.dart';
import 'package:example/features/transaction/transfer_transaction_entity.dart';
import 'package:example/presentation/dialog/transaction/envelope_transaction_edit_dialog.dart';
import 'package:example/presentation/dialog/transaction/transfer_transaction_edit_dialog.dart';
import 'package:example/presentation/pages/home_page.dart';
import 'package:example/presentation/widget/envelope_rule/envelope_card_modifier.dart';
import 'package:example/presentation/widget/transaction/transaction_card.dart';
import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class EnvelopePage extends AppPage {
  late final idProperty = field<String>(name: 'id').required();

  @override
  Widget build(BuildContext context) {
    final envelopeModel = useQuery(Query.getById<EnvelopeEntity>(idProperty.value));
    final envelopeTransactionsModel = useQuery(Query.from<BudgetTransactionEntity>()
        .where(BudgetTransaction.affectedEnvelopesField)
        .contains(idProperty.value)
        .paginate());

    return ModelBuilder.page(
      model: envelopeModel,
      builder: (EnvelopeEntity envelopeEntity) {
        final envelope = envelopeEntity.value;
        final envelopeRule = envelope.ruleProperty.value;
        final envelopeRuleCardWrapper = EnvelopeRuleCardModifier.getModifier(envelope.ruleProperty.value);
        return StyledPage(
          titleText: envelope.nameProperty.value,
          actions: [
            ActionItem(
              titleText: 'Edit',
              descriptionText: 'Edit this envelope.',
              color: Colors.orange,
              iconData: Icons.edit,
              onPerform: (context) async {
                final result = await context.showStyledDialog(StyledPortDialog(
                  titleText: 'Edit Envelope',
                  port: envelope.asPort(context.corePondContext),
                ));
                if (result == null) {
                  return;
                }

                await context.dropCoreComponent.update(envelopeEntity..value = result);
              },
            ),
            ActionItem(
              titleText: 'Transfer',
              descriptionText: 'Transfer money to/from this envelope.',
              color: Colors.blue,
              iconData: Icons.swap_horiz,
              onPerform: (context) async {
                final result = await context.showStyledDialog(TransferTransactionEditDialog(
                  corePondContext: context.corePondContext,
                  titleText: 'Create Transfer',
                  transferTransaction: TransferTransaction()..budgetProperty.set(envelope.budgetProperty.value),
                ));
                if (result == null) {
                  return;
                }

                await context.dropCoreComponent.update(TransferTransactionEntity()..set(result));
              },
            ),
          ],
          body: StyledList.column.centered.scrollable(
            children: [
              StyledText.h4(envelope.amountCentsProperty.value.formatCentsAsCurrency()),
              StyledCard.subtle(
                titleText: envelopeRule?.getDisplayName(),
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
                  final envelopeTransaction = await context.showStyledDialog(EnvelopeTransactionEditDialog(
                    corePondContext: context.corePondContext,
                    titleText: 'Create Transaction',
                    envelopeTransaction: (EnvelopeTransaction()
                      ..envelopeProperty.set(envelopeEntity.id!)
                      ..budgetProperty.set(envelope.budgetProperty.value)),
                  ));

                  if (envelopeTransaction == null) {
                    return;
                  }

                  final newEnvelope = Envelope()
                    ..copyFrom(context.dropCoreComponent, envelope)
                    ..amountCentsProperty
                        .set(envelope.amountCentsProperty.value + envelopeTransaction.amountCentsProperty.value);

                  await context.dropCoreComponent.update(envelopeEntity..value = newEnvelope);
                  await context.dropCoreComponent.update(EnvelopeTransactionEntity()..value = envelopeTransaction);
                },
              ),
              PaginatedQueryModelBuilder(
                paginatedQueryModel: envelopeTransactionsModel,
                builder: (List<BudgetTransactionEntity> envelopeTransactionEntities, Future Function()? loadNext) {
                  return StyledList.column.withMinChildSize(150)(
                    children: envelopeTransactionEntities
                        .map((entity) => TransactionCard(budgetTransaction: entity.value))
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
