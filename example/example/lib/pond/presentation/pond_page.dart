import 'package:example/pond/domain/budget.dart';
import 'package:example/pond/domain/budget_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class PondPage extends HookWidget {
  const PondPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    useOneTimeEffect(() {
      _initPond();
    });
    final budgetsQuery = useQuery(Query.from<BudgetEntity>().all());
    return StyleProvider(
        style: DeltaStyle(backgroundColor: Color(0xff071238)),
        child: Builder(
          builder: (context) => ModelBuilder.styledPage(
            model: budgetsQuery.model,
            builder: (List<BudgetEntity> budgets) => StyledPage(
              onRefresh: budgetsQuery.reload,
              titleText: 'Home',
              body: StyledCategory.medium(
                headerText: 'Budgets',
                children: [
                  ...budgets.map((budget) => StyledContent(
                        headerText: budget.value.nameProperty.value ?? 'N/A',
                        actions: [
                          ActionItem(
                            name: 'Edit',
                            onPerform: () {
                              budget.value.nameProperty.value = budget.value.nameProperty.value! + 'A';
                              AppContext.global.save<BudgetEntity>(budget);
                            },
                          )
                        ],
                      )),
                  StyledButton.high(
                    text: 'Create',
                    onTapped: () {
                      final budgetEntity = BudgetEntity(initialBudget: Budget()..nameProperty.value = 'A');
                      AppContext.global.create<BudgetEntity>(budgetEntity);
                    },
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  void _initPond() {
    AppContext.global = AppContext(
      registration: DatabaseAppRegistration(
        repositories: [
          LocalBudgetRepository(),
        ],
      ),
    );
  }
}

class LocalBudgetRepository extends EntityRepository<BudgetEntity>
    with WithLocalEntityRepository, WithIdGenerator, WithDomainRegistrationsProvider<Budget, BudgetEntity>
    implements RegistrationsProvider {
  @override
  BudgetEntity createEntity(Budget initialValue) {
    return BudgetEntity(initialBudget: initialValue);
  }

  @override
  Budget createValueObject() {
    return Budget();
  }
}
