import 'package:example/pond/domain/budget/budget.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

import '../envelope/envelope.dart';
import '../envelope/envelope_entity.dart';

class BudgetEntity extends Entity<Budget> {
  static Query<EnvelopeEntity> getEnvelopesQueryFromBudget(String budgetId) {
    return Query.from<EnvelopeEntity>().where(Envelope.budgetField, isEqualTo: budgetId);
  }
}
