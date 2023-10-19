import 'package:example/presentation/pages/auth/login_page.dart';
import 'package:example/presentation/pages/budget/budget_page.dart';
import 'package:example/presentation/pages/user/profile_page.dart';
import 'package:example_core/features/budget/budget_entity.dart';
import 'package:example_core/features/settings/settings_entity.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class HomeRoute with IsRoute<HomeRoute> {
  @override
  PathDefinition get pathDefinition => PathDefinition.home;

  @override
  HomeRoute copy() {
    return HomeRoute();
  }
}

class HomePage with IsAppPageWrapper<HomeRoute> {
  @override
  AppPage<HomeRoute> get appPage => AppPage<HomeRoute>().withRedirect((context, route) async {
        final loggedInUser = context.find<AuthCoreComponent>().loggedInUserId;
        if (loggedInUser == null) {
          final loginPage = LoginRoute()..redirectPathProperty.set(route.uri.toString());
          return loginPage.routeData;
        }

        final settingsEntity = await SettingsEntity.getSettings(context.dropCoreComponent);
        final budgetId = settingsEntity.value.budgetProperty.value;
        if (budgetId == null) {
          return ProfileRoute().routeData;
        }

        final budgetEntity = await Query.getByIdOrNull<BudgetEntity>(budgetId).get(context.dropCoreComponent);
        if (budgetEntity == null) {
          return ProfileRoute().routeData;
        }

        return (BudgetRoute()..budgetIdProperty.set(budgetId)).routeData;
      });
}
