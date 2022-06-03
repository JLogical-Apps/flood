import 'package:example/pond/domain/budget/budget_entity.dart';
import 'package:example/pond/domain/budget_transaction/budget_transaction.dart';
import 'package:example/pond/domain/budget_transaction/budget_transaction_entity.dart';
import 'package:example/pond/domain/budget_transaction/transfer_transaction.dart';
import 'package:example/pond/domain/budget_transaction/transfer_transaction_entity.dart';
import 'package:example/pond/domain/envelope/envelope.dart';
import 'package:example/pond/domain/envelope/envelope_entity.dart';
import 'package:example/pond/presentation/pond_login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

import '../domain/budget/budget.dart';
import 'pond_envelope_page.dart';
import 'transaction_card.dart';

class PondBudgetPage extends HookWidget {
  final String budgetId;

  const PondBudgetPage({required this.budgetId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final budgetEntityController = useEntity<BudgetEntity>(budgetId);
    final envelopesQueryController = useQuery(
      Query.from<EnvelopeEntity>().where(Envelope.budgetField, isEqualTo: budgetId).all(),
    );
    final transactionsQueryController = useQuery(
      Query.from<BudgetTransactionEntity>()
          .where(BudgetTransaction.budgetField, isEqualTo: budgetId)
          .paginate(limit: 2),
    );

    final isLoading = useState<bool>(false);

    final budgetAmountX = useComputed(() => envelopesQueryController.model.valueX.mapWithValue(
        (maybeEnvelopeEntities) => maybeEnvelopeEntities.mapIfPresent<int>((envelopeEntities) =>
            envelopeEntities.sumBy((envelopeEntity) => envelopeEntity.value.amountProperty.value!).round())));
    final maybeBudgetAmount = useValueStream(budgetAmountX);

    final imageAssets = useAssets(budgetEntityController.model.getOrNull()?.value.imagesProperty.value ?? []);

    return StyleProvider(
      style: PondLoginPage.style,
      child: Builder(
        builder: (context) {
          return ModelBuilder.styledPage(
            model: budgetEntityController.model,
            builder: (BudgetEntity budgetEntity) {
              final budget = budgetEntity.value;
              return StyledPage(
                isLoading: isLoading.value,
                actions: [
                  ActionItem(
                    name: 'Take Picture',
                    onPerform: () async {
                      final asset = await ImageAssetPicker.pickImageFromCamera();
                      if (asset == null) {
                        return;
                      }

                      final newBudget = Budget()..copyFrom(budget);
                      await newBudget.imagesProperty.uploadNewAsset(asset);

                      budgetEntity.value = newBudget;
                      await budgetEntity.save();
                    },
                  ),
                  ActionItem(
                    name: 'Upload Image',
                    onPerform: () async {
                      final asset = await ImageAssetPicker.pickImageFromGallery();
                      if (asset == null) {
                        return;
                      }

                      isLoading.value = true;

                      final newBudget = Budget()..copyFrom(budget);
                      await newBudget.imagesProperty.uploadNewAsset(asset);

                      budgetEntity.value = newBudget;
                      await budgetEntity.save();

                      isLoading.value = false;
                    },
                  ),
                ],
                onRefresh: () => Future.wait([
                  budgetEntityController.reload(),
                  envelopesQueryController.reload(),
                  transactionsQueryController.reload(),
                ]),
                titleText:
                    'Budget: ${budget.nameProperty.value}\n${maybeBudgetAmount.mapIfPresent((amount) => amount.formatCentsAsCurrency()).get(orElse: () => 'N/A')}',
                body: ScrollColumn.withScrollbar(
                  children: [
                    for (final imageAsset in imageAssets)
                      GestureDetector(
                        onTap: imageAsset.getOrNull() == null
                            ? null
                            : () async {
                                final delete = await StyledDialog.yesNo(
                                  context: context,
                                  titleText: 'Confirm Delete',
                                  children: [StyledBodyText('Are you sure you want to delete this?')],
                                ).show(context);
                                if (delete != true) {
                                  return;
                                }

                                isLoading.value = true;

                                final newBudget = Budget()..copyFrom(budget);
                                await newBudget.imagesProperty.deleteAsset(imageAsset.getOrNull()!.id!);

                                budgetEntity.value = newBudget;
                                await budgetEntity.save();

                                isLoading.value = false;
                              },
                        child: StyledLoadingImage(
                          image: imageAsset.mapIfNonNull((asset) => MemoryImage(asset.getOrNull()!.value)),
                          width: 200,
                          height: 200,
                        ),
                      ),
                    ModelBuilder.styled(
                      model: envelopesQueryController.model,
                      builder: (List<EnvelopeEntity> envelopeEntities) {
                        return StyledCategory.medium(
                          headerText: 'Envelopes',
                          actions: [
                            ActionItem(
                              name: 'Create',
                              description: 'Create new Envelope',
                              color: Colors.green,
                              icon: Icons.mail,
                              onPerform: () async {
                                final data = await StyledDialog.port(
                                  context: context,
                                  port: Port(
                                    fields: [
                                      StringPortField(name: 'name').required(),
                                    ],
                                  ),
                                  children: [
                                    StyledTextPortField(
                                      name: 'name',
                                      labelText: 'Name',
                                    ),
                                  ],
                                ).show(context);

                                if (data == null) {
                                  return;
                                }

                                final envelope = Envelope()
                                  ..nameProperty.value = data['name']
                                  ..amountProperty.value = 0
                                  ..budgetProperty.value = budgetId;
                                final envelopeEntity = EnvelopeEntity()..value = envelope;

                                await envelopeEntity.create();
                              },
                            ),
                          ],
                          noChildrenWidget: StyledContentSubtitleText('No envelopes'),
                          children: [
                            ...envelopeEntities.map((envelopeEntity) => EnvelopeCard(
                                  envelopeId: envelopeEntity.id!,
                                  key: ValueKey(envelopeEntity.id),
                                )),
                          ],
                        );
                      },
                    ),
                    ModelBuilder.styled(
                      model: transactionsQueryController.model,
                      builder: (QueryPaginationResultController<BudgetTransactionEntity> budgetTransactionsController) {
                        return HookBuilder(builder: (context) {
                          final transactions = useValueStream(budgetTransactionsController.resultsX);
                          return StyledCategory.medium(
                            headerText: 'Transactions',
                            actions: [
                              if (envelopesQueryController.value is FutureValueLoaded)
                                ActionItem(
                                  name: 'Create Transfer',
                                  description: 'Create new transfer',
                                  color: Colors.green,
                                  icon: Icons.swap_calls,
                                  onPerform: () async {
                                    final data = await StyledDialog.port(
                                      context: context,
                                      port: Port(
                                        fields: [
                                          OptionsPortField<EnvelopeEntity>(
                                            name: 'from',
                                            options: envelopesQueryController.value.get(),
                                          ),
                                          OptionsPortField<EnvelopeEntity>(
                                            name: 'to',
                                            options: envelopesQueryController.value.get(),
                                          ),
                                          CurrencyPortField(name: 'amount').required(),
                                        ],
                                      ),
                                      children: [
                                        StyledOptionsPortField<EnvelopeEntity>(
                                          name: 'from',
                                          labelText: 'From',
                                          builder: (envelopeEntity) => StyledBodyText(
                                            envelopeEntity?.value.nameProperty.value ?? 'None',
                                            textOverrides: StyledTextOverrides(padding: EdgeInsets.zero),
                                          ),
                                        ),
                                        StyledOptionsPortField<EnvelopeEntity>(
                                          name: 'to',
                                          labelText: 'To',
                                          builder: (envelopeEntity) => StyledBodyText(
                                            envelopeEntity?.value.nameProperty.value ?? 'None',
                                            textOverrides: StyledTextOverrides(padding: EdgeInsets.zero),
                                          ),
                                        ),
                                        StyledCurrencyPortField(
                                          name: 'amount',
                                          labelText: 'Amount',
                                        ),
                                      ],
                                    ).show(context);

                                    if (data == null) {
                                      return;
                                    }

                                    final transferTransaction = TransferTransaction()
                                      ..amountProperty.value = data['amount']
                                      ..fromProperty.reference = data['from']
                                      ..toProperty.reference = data['to']
                                      ..budgetProperty.value = budgetId;
                                    final transferTransactionEntity = TransferTransactionEntity()
                                      ..value = transferTransaction;
                                    await transferTransactionEntity.create();
                                  },
                                ),
                            ],
                            noChildrenWidget: StyledContentSubtitleText('No transactions'),
                            children: [
                              ...transactions.map((transactionEntity) => TransactionCard(
                                    transactionId: transactionEntity.id!,
                                    key: ValueKey(transactionEntity.id!),
                                  )),
                              if (budgetTransactionsController.canLoadMore)
                                StyledButton.low(
                                  text: 'Load More',
                                  onTapped: () async {
                                    await budgetTransactionsController.loadMore();
                                  },
                                ),
                            ],
                          );
                        });
                      },
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class EnvelopeCard extends HookWidget {
  final String envelopeId;

  const EnvelopeCard({Key? key, required this.envelopeId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final envelopeEntityController = useEntity<EnvelopeEntity>(envelopeId);

    return ModelBuilder.styled(
      model: envelopeEntityController.model,
      builder: (EnvelopeEntity envelopeEntity) {
        final envelope = envelopeEntity.value;
        return StyledContent(
          header: StyledContentHeaderText(
            envelope.nameProperty.value!,
            textOverrides:
                StyledTextOverrides(fontColor: envelope.colorProperty.value.mapIfNonNull((value) => Color(value))),
          ),
          bodyText: envelope.amountProperty.value!.formatCentsAsCurrency(),
          onTapped: () {
            context
                .style()
                .navigateTo(context: context, page: (context) => PondEnvelopePage(envelopeId: envelopeEntity.id!));
          },
          actions: [
            ActionItem(
              name: 'Delete',
              description: 'Delete this envelope.',
              color: Colors.red,
              icon: Icons.delete,
              onPerform: () async {
                final dialog = StyledDialog.yesNo(
                  context: context,
                  titleText: 'Confirm Delete',
                  children: [
                    StyledBodyText('Are you sure you want to delete this envelope?'),
                  ],
                );
                if (await dialog.show(context) == true) {
                  await envelopeEntity.delete();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
