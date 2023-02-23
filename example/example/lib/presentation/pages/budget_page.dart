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
    final budgetModel = useQuery(Query.getById<BudgetEntity>(budgetIdProperty.value));
    final envelopesModel = useQuery(Query.from<EnvelopeEntity>()
        .where(Envelope.budgetField)
        .isEqualTo(budgetIdProperty.value)
        .paginate<EnvelopeEntity>());

    return ModelBuilder.page(
      model: budgetModel,
      builder: (BudgetEntity budgetEntity) {
        final budget = budgetEntity.value;
        return StyledPage(
          titleText: budget.nameProperty.value,
          actions: [
            ActionItem(
              titleText: 'Create',
              descriptionText: 'Create a new budget.',
              iconData: Icons.add,
              color: Colors.green,
              onPerform: (context) async {
                final result = await context.style().showDialog(
                      context,
                      StyledPortDialog(
                        titleText: 'Create Envelope',
                        port: Port.of({
                          'name': PortValue.string().isNotBlank(),
                        }),
                        children: [
                          StyledTextFieldPortField(
                            fieldName: 'name',
                            labelText: 'Name',
                          ),
                        ],
                      ),
                    );
                if (result == null) {
                  return;
                }

                await context.dropCoreComponent.updateEntity(
                  EnvelopeEntity(),
                  (Envelope envelope) => envelope
                    ..nameProperty.set(result['name'])
                    ..budgetProperty.set(budgetIdProperty.value),
                );
              },
            ),
          ],
          body: StyledList.column.scrollable(
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
                      ),
                      if (loadNext != null)
                        StyledButton(
                          labelText: 'Load More',
                          onPressed: () async {
                            await loadNext();
                          },
                        ),
                    ],
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
