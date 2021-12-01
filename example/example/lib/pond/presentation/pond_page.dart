import 'package:example/pond/domain/budget.dart';
import 'package:example/pond/domain/budget_aggregate.dart';
import 'package:example/pond/domain/budget_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class PondPage extends HookWidget {
  const PondPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final budgetId = useState<String?>(null);
    useOneTimeEffect(() {
      _initPond();

      () async {
        final budgetEntity = BudgetEntity(initialBudget: Budget()..nameProperty.value = 'Budget A');
        await AppContext.global.database.getRepository<BudgetEntity>().create(budgetEntity);
        budgetId.value = budgetEntity.id;
      }();
    });
    final maybeAggregate = useAggregate<BudgetAggregate>('abc');
    final aggregate = maybeAggregate?.getOrNull();
    return Scaffold(
      body: Center(
        child: aggregate == null
            ? Text('No Budget found')
            : Text('Budget name: ${aggregate.entity.value.nameProperty.value}'),
      ),
    );
  }

  void _initPond() {
    AppContext.global = AppContext(
      valueObjectRegistrations: [
        ValueObjectRegistration<Budget, Budget?>(() => Budget()),
      ],
      entityRegistrations: [
        EntityRegistration<BudgetEntity, Budget>((value) => BudgetEntity(initialBudget: value)),
      ],
      aggregateRegistrations: [
        AggregateRegistration<BudgetAggregate, BudgetEntity>((entity) => BudgetAggregate(initialBudgetEntity: entity)),
      ],
      database: Database(
        repositories: [
          LocalBudgetRepository(),
        ],
      ),
    );
  }
}

class LocalBudgetRepository = EntityRepository<BudgetEntity> with WithLocalEntityRepository, WithIdGenerator;
