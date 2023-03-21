import 'package:example/features/envelope/envelope.dart';
import 'package:example/features/envelope/envelope_entity.dart';
import 'package:example/features/envelope_rule/envelope_rule.dart';
import 'package:example/features/envelope_rule/firstfruit_envelope_rule.dart';
import 'package:example/features/envelope_rule/repeating_goal_envelope_rule.dart';
import 'package:example/features/envelope_rule/surplus_envelope_rule.dart';
import 'package:example/features/envelope_rule/target_goal_envelope_rule.dart';
import 'package:example/features/transaction/budget_transaction.dart';
import 'package:example/features/transaction/envelope_transaction.dart';
import 'package:example/features/transaction/envelope_transaction_entity.dart';
import 'package:example/presentation/pages/home_page.dart';
import 'package:example/presentation/widget/envelope_rule/envelope_card_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class EnvelopePage extends AppPage {
  late final idProperty = field<String>(name: 'id').required();

  @override
  Widget build(BuildContext context) {
    final envelopeModel = useQuery(Query.getById<EnvelopeEntity>(idProperty.value));
    final envelopeTransactionsModel = useQuery(Query.from<EnvelopeTransactionEntity>()
        .where(BudgetTransaction.affectedEnvelopesField)
        .contains(idProperty.value)
        .paginate());

    return ModelBuilder.page(
      model: envelopeModel,
      builder: (EnvelopeEntity envelopeEntity) {
        final envelope = envelopeEntity.value;
        final envelopeRule = envelope.ruleProperty.value;
        final envelopeRuleCardWrapper = EnvelopeRuleCardWrapper.getWrapper(envelope.ruleProperty.value);
        return StyledPage(
          titleText: envelope.nameProperty.value,
          actions: [
            ActionItem(
              titleText: 'Edit',
              descriptionText: 'Edit the Envelope',
              color: Colors.orange,
              iconData: Icons.edit,
              onPerform: (context) async {
                final result = await context.showStyledDialog(StyledPortDialog(
                  titleText: 'Create New Envelope',
                  port: envelope.asPort(context.corePondContext),
                  children: [
                    StyledTextFieldPortField(
                      fieldName: Envelope.nameField,
                      labelText: 'Name',
                    ),
                    StyledTextFieldPortField(
                      fieldName: Envelope.descriptionField,
                      labelText: 'Description',
                      maxLines: 3,
                    ),
                    StyledDivider.subtle(),
                    StyledOptionPortField<EnvelopeRule?>(
                      fieldName: Envelope.ruleField,
                      labelText: 'Rule',
                      options: [
                        null,
                        envelopeRule?.as<FirstfruitEnvelopeRule>() ?? FirstfruitEnvelopeRule(),
                        envelopeRule?.as<RepeatingGoalEnvelopeRule>() ?? RepeatingGoalEnvelopeRule(),
                        envelopeRule?.as<TargetGoalEnvelopeRule>() ?? TargetGoalEnvelopeRule(),
                        envelopeRule?.as<SurplusEnvelopeRule>() ?? SurplusEnvelopeRule(),
                      ],
                      widgetMapper: (rule) {
                        final envelopeRuleWrapper = EnvelopeRuleCardWrapper.getWrapper(rule);
                        return StyledList.row(
                          children: [
                            envelopeRuleWrapper.getIcon(rule),
                            StyledText.button(envelopeRuleWrapper.getName(rule)),
                          ],
                        );
                      },
                    ),
                  ],
                ));
                if (result == null) {
                  return;
                }

                await context.dropCoreComponent.update(envelopeEntity..value = result);
              },
            ),
          ],
          body: StyledList.column.centered.scrollable(
            children: [
              StyledText.h4(envelope.amountCentsProperty.value.formatCentsAsCurrency()),
              StyledCard.subtle(
                titleText: envelopeRuleCardWrapper.getName(envelopeRule),
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
                  final transactionPort = (EnvelopeTransaction()
                        ..envelopeProperty.set(envelopeEntity.id!)
                        ..budgetProperty.set(envelope.budgetProperty.value))
                      .asPort(context.corePondContext);
                  final port = Port.of({
                    'transaction': PortValue.port(port: transactionPort),
                    'transactionType': PortValue.option(
                      options: EnvelopeTransactionType.values,
                      initialValue: EnvelopeTransactionType.payment,
                    ),
                  });
                  final result = await context.showStyledDialog(StyledPortDialog(
                    port: port,
                    children: [
                      PortBuilder(
                        port: transactionPort,
                        builder: (context, port) {
                          return StyledList.column(
                            children: [
                              StyledTextFieldPortField(
                                fieldName: EnvelopeTransaction.nameField,
                                labelText: 'Name',
                              ),
                              StyledCurrencyFieldPortField(
                                fieldName: EnvelopeTransaction.amountCentsField,
                                labelText: 'Amount (\$)',
                              ),
                            ],
                          );
                        },
                      ),
                      StyledRadioPortField<EnvelopeTransactionType>(
                        fieldName: 'transactionType',
                        options: EnvelopeTransactionType.values,
                        stringMapper: (EnvelopeTransactionType value) => value.name,
                      ),
                    ],
                  ));

                  if (result == null) {
                    return;
                  }

                  final transactionResult = result['transaction'] as EnvelopeTransaction;
                  final transactionType = result['transactionType'] as EnvelopeTransactionType;
                  transactionType.modifyTransaction(transactionResult);

                  final newEnvelope = Envelope()
                    ..copyFrom(context.dropCoreComponent, envelope)
                    ..amountCentsProperty
                        .set(envelope.amountCentsProperty.value + transactionResult.amountCentsProperty.value);

                  await context.dropCoreComponent.update(envelopeEntity..value = newEnvelope);
                  await context.dropCoreComponent.update(EnvelopeTransactionEntity()..value = transactionResult);
                },
              ),
              PaginatedQueryModelBuilder(
                paginatedQueryModel: envelopeTransactionsModel,
                builder: (List<EnvelopeTransactionEntity> envelopeTransactionEntities, Future Function()? loadNext) {
                  return StyledList.column.withMinChildSize(150)(
                    children: envelopeTransactionEntities
                        .map((entity) => StyledCard(
                              titleText: entity.value.amountCentsProperty.value.formatCentsAsCurrency(),
                              bodyText: entity.value.nameProperty.value,
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

enum EnvelopeTransactionType {
  payment(
    name: 'Payment',
    note: 'Payment from this envelope.',
    transactionModifier: _refundPayment,
  ),
  refund(
    name: 'Refund',
    note: 'Refund to this envelope.',
    transactionModifier: null,
  );

  final String name;
  final String note;
  final void Function(EnvelopeTransaction transaction)? transactionModifier;

  const EnvelopeTransactionType({
    required this.name,
    required this.note,
    required this.transactionModifier,
  });

  void modifyTransaction(EnvelopeTransaction transaction) {
    transactionModifier?.call(transaction);
  }
}

void _refundPayment(EnvelopeTransaction transaction) {
  transaction.amountCentsProperty.set(-transaction.amountCentsProperty.value);
}
