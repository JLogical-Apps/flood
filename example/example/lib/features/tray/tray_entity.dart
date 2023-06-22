import 'package:example/features/tray/tray.dart';
import 'package:jlogical_utils_core/jlogical_utils_core.dart';

class TrayEntity extends Entity<Tray> {
  static Query<TrayEntity> getBudgetTraysQuery({required String budgetId}) {
    return Query.from<TrayEntity>().where(Tray.budgetField).isEqualTo(budgetId);
  }
}
