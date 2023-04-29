import 'package:example/features/budget/budget.dart';
import 'package:example/features/budget/budget_entity.dart';
import 'package:example/features/envelope/envelope.dart';
import 'package:example/features/envelope/envelope_entity.dart';
import 'package:example/features/envelope_rule/firstfruit_envelope_rule.dart';
import 'package:example/features/envelope_rule/monthly_time_rule.dart';
import 'package:example/features/envelope_rule/repeating_goal_envelope_rule.dart';
import 'package:example/features/envelope_rule/surplus_envelope_rule.dart';
import 'package:example/features/envelope_rule/target_goal_envelope_rule.dart';
import 'package:example/features/user/user.dart';
import 'package:example/features/user/user_entity.dart';
import 'package:example/pond.dart';
import 'package:example/presentation/pages/home_page.dart';
import 'package:example/presentation/port/envelope_port_override.dart';
import 'package:example/presentation/port/envelope_transaction_port_override.dart';
import 'package:example/presentation/port/repeating_goal_port_override.dart';
import 'package:example/presentation/port/transfer_transaction_port_override.dart';
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
  await appPondContext.register(PortStyleComponent(overrides: [
    EnvelopePortOverride(context: appPondContext),
    EnvelopeTransactionPortOverride(context: appPondContext),
    TransferTransactionPortOverride(context: appPondContext),
    RepeatingGoalPortOverride(context: appPondContext),
  ]));
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

      final envelopes = [
        Envelope()
          ..budgetProperty.set(budgetEntity.id!)
          ..nameProperty.set('Tithe')
          ..ruleProperty.set(FirstfruitEnvelopeRule()..percentProperty.set(10)),
        Envelope()
          ..budgetProperty.set(budgetEntity.id!)
          ..nameProperty.set('Car')
          ..ruleProperty.set(RepeatingGoalEnvelopeRule()
            ..goalCentsProperty.set(100 * 100)
            ..timeRuleProperty.set(MonthlyTimeRule()..dayOfMonthProperty.set(1))),
        Envelope()
          ..budgetProperty.set(budgetEntity.id!)
          ..nameProperty.set('Emergency Savings')
          ..ruleProperty.set(TargetGoalEnvelopeRule()
            ..percentProperty.set(20)
            ..maximumCentsProperty.set(1000 * 100)),
        Envelope()
          ..budgetProperty.set(budgetEntity.id!)
          ..nameProperty.set('Savings')
          ..ruleProperty.set(SurplusEnvelopeRule()..percentProperty.set(100)),
      ];

      await Future.wait(
          envelopes.map((envelope) => EnvelopeEntity()..set(envelope)).map((entity) => dropComponent.update(entity)));
    }
  }));
  return appPondContext;
}
