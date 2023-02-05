import 'package:example/features/budget/budget_entity.dart';
import 'package:example/features/envelope/envelope.dart';
import 'package:example/features/envelope/envelope_entity.dart';
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

    return ModelBuilder(
      model: budgetModel,
      builder: (BudgetEntity budgetEntity) {
        final budget = budgetEntity.value;
        return StyledPage(
          titleText: budget.nameProperty.value,
          body: StyledList.column.scrollable(
            children: [
              ModelBuilder(
                model: envelopesModel,
                builder: (QueryResultPage<EnvelopeEntity> page) {
                  return StyledList.column.withMinChildSize(150)(
                    children: page.items
                        .map((envelopeEntity) => StyledCard(
                              titleText: envelopeEntity.value.nameProperty.value,
                            ))
                        .toList(),
                  );
                },
              ),
              StyledButton.strong(
                labelText: 'Create +',
                onPressed: () async {
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
                          ]));
                  if (result == null) {
                    return;
                  }

                  final envelope = Envelope()
                    ..nameProperty.set(result['name'])
                    ..budgetProperty.set(budgetIdProperty.value);
                  final envelopeEntity = EnvelopeEntity()..value = envelope;
                  await context.dropCoreComponent.update(envelopeEntity);
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
}
