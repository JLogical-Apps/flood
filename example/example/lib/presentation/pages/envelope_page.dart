import 'package:example/features/envelope/envelope.dart';
import 'package:example/features/envelope/envelope_entity.dart';
import 'package:example/features/transaction/amount_transaction.dart';
import 'package:example/features/transaction/amount_transaction_entity.dart';
import 'package:example/features/transaction/budget_transaction.dart';
import 'package:example/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class EnvelopePage extends AppPage {
  late final idProperty = field<String>(name: 'id').required();

  @override
  Widget build(BuildContext context) {
    final envelopeModel = useQuery(Query.getById<EnvelopeEntity>(idProperty.value));
    final envelopeTransactionsModel = useQuery(Query.from<AmountTransactionEntity>()
        .where(BudgetTransaction.affectedEnvelopesField)
        .contains(idProperty.value)
        .paginate());

    return ModelBuilder.page(
      model: envelopeModel,
      builder: (EnvelopeEntity envelopeEntity) {
        return StyledPage(
          titleText: envelopeEntity.value.nameProperty.value,
          actions: [
            ActionItem(
              titleText: 'Edit',
              descriptionText: 'Edit the Envelope',
              color: Colors.orange,
              iconData: Icons.edit,
              onPerform: (context) async {
                final result = await context.showStyledDialog(StyledPortDialog(
                  titleText: 'Create New Envelope',
                  port: envelopeEntity.value.asPort(context.corePondContext),
                  children: [
                    StyledTextFieldPortField(
                      fieldName: Envelope.nameField,
                      labelText: 'Name',
                    ),
                  ],
                ));
                if (result == null) {
                  return;
                }

                await context.dropCoreComponent.update(envelopeEntity..value = result);
              },
            ),
            ActionItem(
              titleText: 'Create Transaction',
              descriptionText: 'Create a transaction to the envelope.',
              iconData: Icons.swap_horiz,
              color: Colors.green,
              onPerform: (context) async {
                final envelope = envelopeEntity.value;

                final result = await context.showStyledDialog(StyledPortDialog(
                  port: (AmountTransaction()
                        ..envelopeProperty.set(envelopeEntity.id)
                        ..budgetProperty.set(envelope.budgetProperty.value))
                      .asPort(context.corePondContext),
                  children: [
                    StyledTextFieldPortField(
                      fieldName: AmountTransaction.nameField,
                      labelText: 'Name',
                    ),
                    StyledCurrencyFieldPortField(
                      fieldName: AmountTransaction.amountCentsField,
                      labelText: 'Amount (\$)',
                    ),
                  ],
                ));

                if (result == null) {
                  return;
                }

                final newEnvelope = Envelope()
                  ..copyFrom(context.dropCoreComponent, envelope)
                  ..amountCentsProperty.set(envelope.amountCentsProperty.value + result.amountCentsProperty.value);

                await context.dropCoreComponent.update(envelopeEntity..value = newEnvelope);
                await context.dropCoreComponent.update(AmountTransactionEntity()..value = result);
              },
            ),
          ],
          body: StyledList.column.centered.scrollable(
            children: [
              StyledText.h4(envelopeEntity.value.amountCentsProperty.value.formatCentsAsCurrency()),
              PaginatedQueryModelBuilder(
                paginatedQueryModel: envelopeTransactionsModel,
                builder: (List<AmountTransactionEntity> amountTransactionEntities, Future Function()? loadNext) {
                  return StyledList.column.withMinChildSize(150)(
                    children: amountTransactionEntities
                        .map((entity) => StyledCard(
                              titleText: entity.value.amountCentsProperty.value.formatCentsAsCurrency(),
                              bodyText: entity.value.nameProperty.value,
                            ))
                        .toList(),
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
