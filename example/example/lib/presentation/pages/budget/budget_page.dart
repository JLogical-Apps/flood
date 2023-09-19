import 'dart:async';

import 'package:example/presentation/dialog/envelope/envelope_edit_dialog.dart';
import 'package:example/presentation/pages/envelope/archived_envelopes_page.dart';
import 'package:example/presentation/pages/envelope/envelope_page.dart';
import 'package:example/presentation/pages/transaction/add_transactions_page.dart';
import 'package:example/presentation/pages/user/profile_page.dart';
import 'package:example/presentation/utils/redirect_utils.dart';
import 'package:example/presentation/widget/envelope/envelope_card.dart';
import 'package:example/presentation/widget/transaction/transaction_card.dart';
import 'package:example/presentation/widget/transaction/transaction_view_context.dart';
import 'package:example/presentation/widget/tray/tray_card.dart';
import 'package:example_core/features/budget/budget_entity.dart';
import 'package:example_core/features/envelope/envelope.dart';
import 'package:example_core/features/envelope/envelope_entity.dart';
import 'package:example_core/features/transaction/budget_transaction_entity.dart';
import 'package:example_core/features/tray/tray.dart';
import 'package:example_core/features/tray/tray_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class BudgetRoute with IsRoute<BudgetRoute> {
  late final budgetIdProperty = field<String>(name: 'budgetId').required();

  @override
  PathDefinition get pathDefinition => PathDefinition.string('budget').property(budgetIdProperty);

  @override
  BudgetRoute copy() {
    return BudgetRoute();
  }
}

class BudgetPage with IsAppPageWrapper<BudgetRoute> {
  @override
  AppPage<BudgetRoute> get appPage => AppPage<BudgetRoute>().onlyIfLoggedIn();

  @override
  Widget onBuild(BuildContext context, BudgetRoute route) {
    final budgetModel = useEntityOrNull<BudgetEntity>(route.budgetIdProperty.value);
    final envelopesModel = useQuery(
        EnvelopeEntity.getBudgetEnvelopesQuery(budgetId: route.budgetIdProperty.value, isArchived: false).all());
    final traysModel = useQuery(TrayEntity.getBudgetTraysQuery(budgetId: route.budgetIdProperty.value).all());

    final transactionsModel =
        useQuery(BudgetTransactionEntity.getBudgetTransactionsQuery(budgetId: route.budgetIdProperty.value).paginate());

    final totalCents = envelopesModel.getOrNull()?.mapIfNonNull(
        (envelopeEntities) => envelopeEntities.sumByInt((entity) => entity.value.amountCentsProperty.value));

    return ModelBuilder.page(
      model: budgetModel,
      builder: (BudgetEntity? budgetEntity) {
        if (budgetEntity == null) {
          return StyledLoadingPage();
        }

        final budget = budgetEntity.value;
        return StyledPage(
          onRefresh: () => Future.wait([
            budgetModel.load(),
            envelopesModel.load(),
            traysModel.load(),
            transactionsModel.load(),
          ]),
          titleText: '${budget.nameProperty.value}: ${totalCents?.formatCentsAsCurrency() ?? '...'}',
          actionWidgets: [
            StyledButton(
              iconData: Icons.face,
              onPressed: () async {
                context.push(ProfileRoute());
              },
            ),
          ],
          body: StyledTabs(
            tabs: [
              StyledTab(
                titleText: 'Envelopes',
                icon: Icons.mail,
                child: StyledList.column.scrollable.withScrollbar(
                  children: [
                    StyledButton.strong(
                      labelText: 'Add Transactions',
                      iconData: Icons.attach_money,
                      onPressed: () async {
                        await context.push(AddTransactionsRoute()..budgetIdProperty.set(route.budgetIdProperty.value));
                      },
                    ),
                    StyledCard(
                      titleText: 'Envelopes',
                      leadingIcon: Icons.mail,
                      actions: [
                        ActionItem(
                          titleText: 'Create Envelope',
                          descriptionText: 'Create a new envelope.',
                          iconData: Icons.add,
                          color: Colors.green,
                          onPerform: (_) async {
                            await EnvelopeEditDialog.show(
                              context,
                              titleText: 'Create Envelope',
                              envelope: Envelope()..budgetProperty.set(budgetEntity.id!),
                              onAccept: (Envelope result) async {
                                await context.dropCoreComponent.update(EnvelopeEntity()..value = result);
                              },
                            );
                          },
                        ),
                        ActionItem(
                          titleText: 'Create Tray',
                          descriptionText: 'Create a new tray.',
                          iconData: Icons.add,
                          color: Colors.green,
                          onPerform: (_) async {
                            await context.showStyledDialog(StyledPortDialog(
                              port: (Tray()..budgetProperty.set(route.budgetIdProperty.value))
                                  .asPort(context.corePondContext),
                              titleText: 'Create Tray',
                              onAccept: (Tray result) async {
                                await context.dropCoreComponent.updateEntity(TrayEntity()..value = result);
                              },
                            ));
                          },
                        ),
                        ActionItem(
                          titleText: 'Archived Envelopes',
                          descriptionText: 'View your archived envelopes.',
                          iconData: Icons.archive,
                          color: Colors.blue,
                          onPerform: (context) {
                            context.push(ArchivedEnvelopesRoute()..budgetIdProperty.set(route.budgetIdProperty.value));
                          },
                        ),
                      ],
                      children: [
                        HookBuilder(
                          builder: (BuildContext context) {
                            final envelopeEntities = useModel(envelopesModel).getOrNull();
                            final trayEntities = useModel(traysModel).getOrNull();
                            if (envelopeEntities == null || trayEntities == null) {
                              return StyledLoadingIndicator();
                            }

                            final nonTrayedEnvelopes =
                                envelopeEntities.where((entity) => entity.value.trayProperty.value == null).toList();

                            return StyledList.column.withMinChildSize(150)(
                              children: [
                                ...trayEntities.map((trayEntity) => TrayCard(
                                      trayEntity: trayEntity,
                                      onEnvelopePressed: (envelopeEntity) =>
                                          context.push(EnvelopeRoute()..idProperty.set(envelopeEntity.id!)),
                                    )),
                                ...nonTrayedEnvelopes
                                    .map((envelopeEntity) => EnvelopeCard(
                                          envelope: envelopeEntity.value,
                                          onPressed: () =>
                                              context.push(EnvelopeRoute()..idProperty.set(envelopeEntity.id!)),
                                        ))
                                    .toList(),
                              ],
                              ifEmptyText:
                                  'There are no envelopes in this budget! Create one by pressing the triple-dot menu above!',
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              StyledTab(
                titleText: 'Transactions',
                icon: Icons.swap_horiz,
                child: StyledList.column.scrollable.withScrollbar(
                  children: [
                    StyledCard(
                      titleText: 'Transactions',
                      leadingIcon: Icons.swap_horiz,
                      children: [
                        PaginatedQueryModelBuilder(
                          paginatedQueryModel: transactionsModel,
                          builder: (List<BudgetTransactionEntity> transactionEntities, loadMore) {
                            return StyledList.column(
                              ifEmptyText: 'There are no transactions in this budget!',
                              children: [
                                ...transactionEntities
                                    .map((entity) => TransactionCard(
                                          budgetTransaction: entity.value,
                                          transactionViewContext: TransactionViewContext.budget(),
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
                                if (loadMore != null)
                                  StyledButton.strong(
                                    labelText: 'Load More',
                                    onPressed: loadMore,
                                  ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
