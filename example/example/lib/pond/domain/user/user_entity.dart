import 'package:example/pond/domain/user/user.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

import '../budget/budget.dart';
import '../budget/budget_entity.dart';

class UserEntity extends Entity<User> {
  static Query<BudgetEntity> getBudgetsQueryFromUser(String userId) {
    return Query.from<BudgetEntity>().where(Budget.ownerField, isEqualTo: userId);
  }
}
