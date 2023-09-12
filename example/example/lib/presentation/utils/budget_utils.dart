import 'package:example/presentation/pages/budget/budget_page.dart';
import 'package:example_core/features/settings/settings.dart';
import 'package:example_core/features/settings/settings_entity.dart';
import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

extension BudgetBuildContextExtension on BuildContext {
  Future<void> pushBudgetPage(String budgetId) async {
    await dropCoreComponent.updateEntity(
      await SettingsEntity.getSettings(dropCoreComponent),
      (Settings settings) => settings.budgetProperty.set(budgetId),
    );

    warpTo(BudgetPage()..budgetIdProperty.set(budgetId));
  }
}
