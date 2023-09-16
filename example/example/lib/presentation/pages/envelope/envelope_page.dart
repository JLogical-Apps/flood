import 'dart:async';

import 'package:example/presentation/dialog/envelope/envelope_edit_dialog.dart';
import 'package:example/presentation/dialog/transaction/envelope_transaction_edit_dialog.dart';
import 'package:example/presentation/dialog/transaction/transfer_transaction_edit_dialog.dart';
import 'package:example/presentation/style.dart';
import 'package:example/presentation/widget/envelope_rule/envelope_card_modifier.dart';
import 'package:example/presentation/widget/transaction/transaction_card.dart';
import 'package:example/presentation/widget/transaction/transaction_view_context.dart';
import 'package:example_core/features/envelope/envelope.dart';
import 'package:example_core/features/envelope/envelope_entity.dart';
import 'package:example_core/features/transaction/budget_transaction_entity.dart';
import 'package:example_core/features/transaction/envelope_transaction.dart';
import 'package:example_core/features/transaction/envelope_transaction_entity.dart';
import 'package:example_core/features/transaction/transfer_transaction.dart';
import 'package:example_core/features/transaction/transfer_transaction_entity.dart';
import 'package:example_core/features/tray/tray_entity.dart';
import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class EnvelopePage extends AppPage<EnvelopeRoute> {
  @override
  Widget onBuild(BuildContext context, EnvelopeRoute route) {
    final envelopeModel = useEntityOrNull<EnvelopeEntity>(route.idProperty.value);
    final envelopeEntity = envelopeModel.getOrNull();

    final envelopeTransactionsModel =
        useQuery(BudgetTransactionEntity.getEnvelopeTransactionsQuery(envelopeId: route.idProperty.value).paginate());

    final trayModel = useQueryOrNull(
        envelopeEntity?.value.trayProperty.value?.mapIfNonNull((trayId) => Query.getByIdOrNull<TrayEntity>(trayId)));

    return ModelBuilder.page(
      model: envelopeModel,
      builder: (EnvelopeEntity? envelopeEntity) {
        if (envelopeEntity == null) {
          return StyledLoadingPage();
        }

        final envelope = envelopeEntity.value;
        final envelopeRule = envelope.ruleProperty.value;
        final envelopeRuleCardWrapper = EnvelopeRuleCardModifier.getModifier(envelope.ruleProperty.value);
        return StyledPage(
          title: StyledText.h2.withColor(Color(envelope.colorProperty.value))(envelope.nameProperty.value),
          onRefresh: () async {
            await Future.wait([
              envelopeModel.load(),
              envelopeTransactionsModel.load(),
            ]);
          },
          actions: [
            if (!envelope.archivedProperty.value)
              ActionItem(
                titleText: 'Edit',
                descriptionText: 'Edit this envelope.',
                color: Colors.orange,
                iconData: Icons.edit,
                onPerform: (context) async {
                  await EnvelopeEditDialog.show(
                    context,
                    titleText: 'Edit Envelope',
                    envelope: envelope,
                    onAccept: (Envelope result) async {
                      await context.dropCoreComponent.update(envelopeEntity..value = result);
                    },
                  );
                },
              ),
            if (!envelope.archivedProperty.value)
              ActionItem(
                titleText: 'Transfer',
                descriptionText: 'Transfer money to/from this envelope.',
                color: Colors.blue,
                iconData: Icons.swap_horiz,
                onPerform: (context) async {
                  await TransferTransactionEditDialog.show(
                    context,
                    titleText: 'Create Transfer',
                    sourceEnvelopeEntity: envelopeEntity,
                    transferTransaction: TransferTransaction()..budgetProperty.set(envelope.budgetProperty.value),
                    onAccept: (TransferTransaction result) async {
                      final budgetEntity = await envelope.budgetProperty.load(context.dropCoreComponent) ??
                          (throw Exception('Cannot find budget [${envelope.budgetProperty.value}]'));

                      await budgetEntity.updateAddTransaction(
                        context.dropCoreComponent,
                        transactionEntity: TransferTransactionEntity()..set(result),
                      );
                    },
                  );
                },
              ),
            if (!envelope.archivedProperty.value)
              ActionItem(
                titleText: 'Archive',
                descriptionText: 'Archive this envelope.',
                iconData: Icons.archive,
                color: Colors.blue,
                onPerform: (context) async {
                  final confirm = await context.showStyledDialog(StyledDialog.yesNo(
                    titleText: 'Confirm Archive',
                    bodyText:
                        'Are you sure you want to archive this envelope? You can access archived envelopes by clicking the menu button in the home page.',
                  ));

                  if (confirm != true) {
                    return;
                  }

                  var newEnvelope = envelope;

                  if (envelope.amountCentsProperty.value != 0) {
                    final envelopeEntities = await EnvelopeEntity.getBudgetEnvelopesQuery(
                      budgetId: envelope.budgetProperty.value,
                      isArchived: false,
                    ).all().get(context.dropCoreComponent)
                      ..remove(envelopeEntity);

                    final port = Port.of({
                      'envelope': PortField.option<EnvelopeEntity?, EnvelopeEntity>(
                        options: [
                          null,
                          ...envelopeEntities,
                        ],
                        initialValue: null,
                        submitMapper: (envelopeEntity) => envelopeEntity!,
                      ).isNotNull(),
                    }).map((sourceData, port) => sourceData['envelope'] as EnvelopeEntity);

                    final result = await context.showStyledDialog(StyledPortDialog(
                      port: port,
                      titleText: 'Transfer Before Archive',
                      overrides: {
                        'envelope': StyledList.column(
                          children: [
                            StyledText.body(
                                'Before archiving this envelope, select an envelope to transfer all the money to.'),
                            StyledOptionPortField(
                              fieldName: 'envelope',
                              widgetMapper: (EnvelopeEntity? envelopeEntity) {
                                final envelope = envelopeEntity?.value;
                                final envelopeRuleModifier =
                                    EnvelopeRuleCardModifier.getModifier(envelope?.ruleProperty.value);
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
                          ],
                        ),
                      },
                      onAccept: (EnvelopeEntity result) async {
                        newEnvelope = Envelope()
                          ..copyFrom(context.dropCoreComponent, envelope)
                          ..amountCentsProperty.set(0);

                        await context.dropCoreComponent.update(envelopeEntity..set(newEnvelope));
                        await context.dropCoreComponent.updateEntity(
                          result,
                          (Envelope resultEnvelope) => resultEnvelope.amountCentsProperty
                              .set(resultEnvelope.amountCentsProperty.value + envelope.amountCentsProperty.value),
                        );

                        await context.dropCoreComponent.update(TransferTransactionEntity()
                          ..set(TransferTransaction()
                            ..fromEnvelopeProperty.set(envelopeEntity.id!)
                            ..toEnvelopeProperty.set(result.id!)
                            ..amountCentsProperty.set(envelope.amountCentsProperty.value)
                            ..budgetProperty.set(envelope.budgetProperty.value)));
                      },
                    ));

                    if (result == null) {
                      return;
                    }
                  }

                  newEnvelope = Envelope()
                    ..copyFrom(context.dropCoreComponent, newEnvelope)
                    ..archivedProperty.set(true);

                  await context.dropCoreComponent.update(envelopeEntity..set(newEnvelope));
                },
              ),
            if (envelope.archivedProperty.value)
              ActionItem(
                titleText: 'Restore',
                descriptionText: 'Restores this envelope from the archive.',
                iconData: Icons.unarchive,
                color: Colors.blue,
                onPerform: (context) async {
                  final confirm = await context.showStyledDialog(StyledDialog.yesNo(
                    titleText: 'Confirm Restore',
                    bodyText: 'Are you sure you want to restore this envelope?',
                  ));

                  if (confirm != true) {
                    return;
                  }

                  await context.dropCoreComponent.updateEntity(
                    envelopeEntity,
                    (Envelope envelope) => envelope.archivedProperty.set(false),
                  );
                },
              ),
            if (envelope.archivedProperty.value)
              ActionItem(
                titleText: 'Delete',
                descriptionText: 'Deletes the envelope permanently.',
                iconData: Icons.delete,
                color: Colors.red,
                onPerform: (context) async {
                  final confirm = await context.showStyledDialog(StyledDialog.yesNo(
                    titleText: 'Confirm Delete',
                    bodyText:
                        'Are you sure you want to delete this envelope? Any transactions associated with this envelope will not display correctly. This cannot be undone.',
                  ));

                  if (confirm != true) {
                    return;
                  }

                  context.pop();
                  await context.dropCoreComponent.delete(envelopeEntity);
                },
              ),
          ],
          body: StyledList.column.centered.withScrollbar(
            children: [
              StyledText.h4.withColor(getCentsColor(envelope.amountCentsProperty.value))(
                  envelope.amountCentsProperty.value.formatCentsAsCurrency()),
              StyledList.row.centered.scrollable(
                children: [
                  if (envelope.archivedProperty.value)
                    StyledChip(
                      labelText: 'Archived',
                      iconData: Icons.archive,
                      backgroundColor: Colors.blue,
                    ),
                  ModelBuilder(
                    model: trayModel,
                    builder: (TrayEntity? trayEntity) {
                      if (trayEntity == null) {
                        return Container();
                      }
                      final trayColor = Color(trayEntity.value.colorProperty.value);
                      return StyledChip.subtle(
                        icon: StyledIcon(
                          Icons.inbox,
                          color: trayColor,
                        ),
                        label: StyledText.body.withColor(trayColor)(trayEntity.value.nameProperty.value),
                      );
                    },
                  ),
                ],
              ),
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
                  await EnvelopeTransactionEditDialog.show(
                    context,
                    titleText: 'Create Transaction',
                    envelopeTransaction: (EnvelopeTransaction()
                      ..envelopeProperty.set(envelopeEntity.id!)
                      ..budgetProperty.set(envelope.budgetProperty.value)),
                    onAccept: (EnvelopeTransaction envelopeTransaction) async {
                      final budgetEntity = await envelope.budgetProperty.load(context.dropCoreComponent) ??
                          (throw Exception('Cannot find budget [${envelope.budgetProperty.value}]'));

                      await budgetEntity.updateAddTransaction(
                        context.dropCoreComponent,
                        transactionEntity: EnvelopeTransactionEntity()..value = envelopeTransaction,
                      );
                    },
                  );
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
}

class EnvelopeRoute with IsRoute<EnvelopeRoute> {
  late final idProperty = field<String>(name: 'id').required();

  @override
  PathDefinition get pathDefinition => PathDefinition.string('envelope').property(idProperty);

  @override
  EnvelopeRoute copy() {
    return EnvelopeRoute();
  }
}
