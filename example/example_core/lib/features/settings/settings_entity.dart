import 'package:example_core/features/budget/budget_entity.dart';
import 'package:example_core/features/settings/settings.dart';
import 'package:jlogical_utils_core/jlogical_utils_core.dart';

class SettingsEntity extends Entity<Settings> {
  static Future<SettingsEntity> getSettings(DropCoreContext context) async {
    final existingSettings = await Query.from<SettingsEntity>().firstOrNull().get(context);
    if (existingSettings != null) {
      return existingSettings;
    }

    final budgetEntity = await _findDefaultBudgetEntity(context);

    return await context.updateEntity(
      SettingsEntity(),
      (Settings settings) => settings.budgetProperty.set(budgetEntity?.id),
    );
  }

  static Future<BudgetEntity?> _findDefaultBudgetEntity(DropCoreContext context) async {
    final authService = context.context.locate<AuthCoreComponent>();
    final loggedInUserId = authService.loggedInUserId;
    if (loggedInUserId == null) {
      return null;
    }

    return await BudgetEntity.getBudgetsQuery(userId: loggedInUserId).firstOrNull().get(context);
  }
}
