import 'package:example/features/budget/budget.dart';
import 'package:example/features/budget/budget_entity.dart';
import 'package:example/features/envelope/envelope.dart';
import 'package:example/features/envelope/envelope_entity.dart';
import 'package:example/presentation/pages/envelope_page.dart';
import 'package:example/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class BudgetPage extends AppPage {
  late final budgetIdProperty = field<String>(name: 'budgetId').required();

  @override
  Widget build(BuildContext context) {
    final budgetModel = useQuery(Query.getByIdOrNull<BudgetEntity>(budgetIdProperty.value));
    final envelopesModel = useQuery(Query.from<EnvelopeEntity>()
        .where(Envelope.budgetField)
        .isEqualTo(budgetIdProperty.value)
        .paginate<EnvelopeEntity>());

    return ModelBuilder.page(
      model: budgetModel,
      builder: (BudgetEntity? budgetEntity) {
        if (budgetEntity == null) {
          return StyledLoadingPage();
        }

        final budget = budgetEntity.value;
        return StyledPage(
          titleText: budget.nameProperty.value,
          actions: [
            ActionItem(
              titleText: 'Edit',
              descriptionText: 'Edit the budget.',
              iconData: Icons.edit,
              color: Colors.orange,
              onPerform: (context) async {
                final result = await context.style().showDialog(
                    context,
                    StyledPortDialog(
                      titleText: 'Edit Budget',
                      port: budget.asPort(context.corePondContext),
                      children: [
                        StyledTextFieldPortField(
                          fieldName: Budget.nameField,
                          labelText: 'Name',
                        ),
                      ],
                    ));
                if (result == null) {
                  return;
                }

                await context.dropCoreComponent.update(budgetEntity..value = result);
              },
            ),
            ActionItem(
              titleText: 'Delete',
              descriptionText: 'Delete the budget.',
              iconData: Icons.delete,
              color: Colors.red,
              onPerform: (context) async {
                final result = await context.style().showDialog(
                      context,
                      StyledDialog.yesNo(
                        titleText: 'Confirm Delete Budget',
                        bodyText: 'Are you sure you want to delete the budget? You cannot undo this.',
                      ),
                    );
                if (result == null) {
                  return;
                }

                await context.dropCoreComponent.delete(budgetEntity);
                context.pop();
              },
            ),
          ],
          body: StyledList.column.scrollable(
            children: [
              StyledCard(
                titleText: 'Envelopes',
                leadingIcon: Icons.mail,
                actions: [
                  ActionItem(
                    titleText: 'Create',
                    descriptionText: 'Create a new envelope.',
                    iconData: Icons.add,
                    color: Colors.green,
                    onPerform: (context) async {
                      final result = await context.style().showDialog(
                          context,
                          StyledPortDialog(
                            titleText: 'Create New Envelope',
                            port: (Envelope()..budgetProperty.set(budgetEntity.id)).asPort(context.corePondContext),
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

                      await context.dropCoreComponent.update(EnvelopeEntity()..value = result);
                    },
                  ),
                ],
                children: [
                  PaginatedQueryModelBuilder(
                    paginatedQueryModel: envelopesModel,
                    builder: (List<EnvelopeEntity> envelopeEntities, Future Function()? loadNext) {
                      return StyledList.column(
                        children: [
                          StyledList.column.withMinChildSize(150)(
                            children: [
                              ...envelopeEntities
                                  .map((envelopeEntity) => StyledCard(
                                        titleText: envelopeEntity.value.nameProperty.value,
                                        onPressed: () async {
                                          context.push(EnvelopePage()..idProperty.set(envelopeEntity.id!));
                                        },
                                      ))
                                  .toList(),
                            ],
                            ifEmptyText:
                                'There are no envelopes in this budget! Create one by pressing the triple-dot menu above!',
                          ),
                          if (loadNext != null)
                            StyledButton(
                              labelText: 'Load More',
                              onPressed: loadNext,
                            ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  AppPage copy() {
    return BudgetPage();
  }

  @override
  PathDefinition get pathDefinition => PathDefinition.string('budget').property(budgetIdProperty);

  @override
  AppPage? getParent() {
    return HomePage();
  }
}
