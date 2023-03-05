import 'package:example/features/budget/budget.dart';
import 'package:example/features/budget/budget_entity.dart';
import 'package:example/features/envelope/envelope.dart';
import 'package:example/features/envelope/envelope_entity.dart';
import 'package:example/features/user/user.dart';
import 'package:example/features/user/user_entity.dart';
import 'package:example/pond.dart';
import 'package:example/presentation/pages/home_page.dart';
import 'package:example/presentation/style.dart';
import 'package:example/presentation/valet_pages_pond_component.dart';
import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App(
    appPondContext:
        await getAppPondContext(await getCorePondContext(environmentConfig: EnvironmentConfig.static.flutterAssets())),
  ));
}

class App extends StatelessWidget {
  final AppPondContext appPondContext;

  const App({super.key, required this.appPondContext});

  @override
  Widget build(BuildContext context) {
    return PondApp(
      splashPage: StyledPage(
        body: Center(
          child: StyledLoadingIndicator(),
        ),
      ),
      notFoundPage: StyledPage(
        body: Center(
          child: StyledText.h1('Not Found!'),
        ),
      ),
      appPondContext: appPondContext,
      initialPageGetter: () {
        return HomePage();
      },
    );
  }
}

Future<AppPondContext> getAppPondContext(CorePondContext corePondContext) async {
  final appPondContext = AppPondContext(corePondContext: corePondContext);
  await appPondContext.register(NavigationAppPondComponent());
  await appPondContext.register(DebugAppComponent());
  await appPondContext.register(LogAppComponent());
  await appPondContext.register(FocusGrabberAppComponent());
  await appPondContext.register(AuthAppComponent());
  await appPondContext.register(DropAppComponent());
  await appPondContext.register(StyleAppComponent(style: style));
  await appPondContext.register(UrlBarAppComponent());
  await appPondContext.register(ValetPagesAppPondComponent());
  await appPondContext.register(TestingSetupAppComponent(onSetup: () async {
    if (testingLoggedIn) {
      final authComponent = corePondContext.locate<AuthCoreComponent>();
      final dropComponent = corePondContext.locate<DropCoreComponent>();

      final userId = await authComponent.signup('test@test.com', 'password');

      final userEntity = await dropComponent.updateEntity(
        UserEntity()..id = userId,
        (User user) => user.nameProperty.set('John Doe'),
      );

      final budgetEntity = await dropComponent.updateEntity(
        BudgetEntity(),
        (Budget budget) => budget
          ..nameProperty.set('Budget')
          ..ownerProperty.set(userEntity.id!),
      );

      await Future.wait(List.generate(
          5,
          (i) => dropComponent.updateEntity(
              EnvelopeEntity(),
              (Envelope envelope) => envelope
                ..nameProperty.set('Envelope ${i + 1}')
                ..budgetProperty.set(budgetEntity.id!))));
    }
  }));
  return appPondContext;
}
