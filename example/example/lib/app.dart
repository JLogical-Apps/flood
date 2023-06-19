import 'dart:async';

import 'package:example/features/budget/budget.dart';
import 'package:example/features/budget/budget_entity.dart';
import 'package:example/features/envelope/envelope.dart';
import 'package:example/features/envelope/envelope_entity.dart';
import 'package:example/features/envelope_rule/daily_time_rule.dart';
import 'package:example/features/envelope_rule/firstfruit_envelope_rule.dart';
import 'package:example/features/envelope_rule/monthly_time_rule.dart';
import 'package:example/features/envelope_rule/repeating_goal_envelope_rule.dart';
import 'package:example/features/envelope_rule/surplus_envelope_rule.dart';
import 'package:example/features/envelope_rule/target_goal_envelope_rule.dart';
import 'package:example/features/transaction/budget_transaction_entity.dart';
import 'package:example/features/transaction/envelope_transaction.dart';
import 'package:example/features/transaction/income_transaction.dart';
import 'package:example/features/transaction/transfer_transaction.dart';
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

const testingLoggedIn = true;
const testingTransactions = true;

Future<void> main(List<String> args) async {
  AppPondContext? appPondContext;
  await PondApp.run(
    appPondContextGetter: () async {
      appPondContext = await getAppPondContext(await getCorePondContext(
        environmentConfig: EnvironmentConfig.static.flutterAssets(),
        repositoryImplementations: [
          FlutterFileRepositoryImplementation(),
          FirebaseCloudRepositoryImplementation(),
        ],
      ));
      return appPondContext!;
    },
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
    initialPageGetter: () {
      return HomePage();
    },
    onError: (error, stackTrace) {
      if (appPondContext == null) {
        print(error);
        print(stackTrace);
      } else {
        appPondContext!.find<LogCoreComponent>().logError(error, stackTrace);
      }
    },
  );
}

Future<AppPondContext> getAppPondContext(CorePondContext corePondContext) async {
  final appPondContext = AppPondContext(corePondContext: corePondContext);
  await appPondContext.register(NavigationAppPondComponent());
  await appPondContext.register(DebugAppComponent());
  await appPondContext.register(LogAppComponent());
  await appPondContext.register(FocusGrabberAppComponent());
  await appPondContext.register(AuthAppComponent());
  await appPondContext.register(DropAppComponent());
  await appPondContext.register(ResetAppComponent());
  await appPondContext.register(PortStyleComponent(overrides: [
    EnvelopePortOverride(context: appPondContext),
    EnvelopeTransactionPortOverride(context: appPondContext),
    TransferTransactionPortOverride(context: appPondContext),
    RepeatingGoalPortOverride(context: appPondContext),
  ]));
  await appPondContext.register(StyleAppComponent(style: style));
  await appPondContext.register(UrlBarAppComponent());
  await appPondContext.register(EnvironmentBannerAppComponent());
  await appPondContext.register(ValetPagesAppPondComponent());
  await appPondContext.register(TestingSetupAppComponent(onSetup: () => _setupTesting(corePondContext)));

  return appPondContext;
}

Future<void> _setupTesting(CorePondContext corePondContext) async {
  if (!testingLoggedIn) {
    return;
  }

  final authComponent = corePondContext.locate<AuthCoreComponent>();
  final dropComponent = corePondContext.locate<CoreDropComponent>();

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
        ..timeRuleProperty.set(MonthlyTimeRule())
        ..remainingGoalCentsProperty.set(100 * 100)
        ..lastAppliedDateProperty.set(Timestamp.of(DateTime.now().subtract(Duration(days: 6))))),
    Envelope()
      ..budgetProperty.set(budgetEntity.id!)
      ..nameProperty.set('Eating Out')
      ..ruleProperty.set(RepeatingGoalEnvelopeRule()
        ..goalCentsProperty.set(40 * 100)
        ..timeRuleProperty.set(DailyTimeRule()..daysProperty.set(7))
        ..remainingGoalCentsProperty.set(40 * 100)
        ..lastAppliedDateProperty.set(Timestamp.of(DateTime.now().subtract(Duration(days: 4))))),
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

  await Future.wait(envelopes
      .map((envelope) => EnvelopeEntity()
        ..id = envelope.nameProperty.value
        ..set(envelope))
      .map((entity) => dropComponent.update(entity)));

  if (testingTransactions) {
    final transactions = [
      EnvelopeTransaction()
        ..nameProperty.set('Payment')
        ..amountCentsProperty.set(-90 * 100)
        ..envelopeProperty.set('Car')
        ..budgetProperty.set(budgetEntity.id!)
        ..transactionDateProperty.set(Timestamp.of(DateTime.now().subtract(Duration(days: 3)))),
      EnvelopeTransaction()
        ..nameProperty.set('Vacation')
        ..amountCentsProperty.set(-180 * 100)
        ..envelopeProperty.set('Savings')
        ..budgetProperty.set(budgetEntity.id!)
        ..transactionDateProperty.set(Timestamp.of(DateTime.now().subtract(Duration(days: 3)))),
      EnvelopeTransaction()
        ..nameProperty.set('Plumber')
        ..amountCentsProperty.set(-120 * 100)
        ..envelopeProperty.set('Emergency Savings')
        ..budgetProperty.set(budgetEntity.id!)
        ..transactionDateProperty.set(Timestamp.of(DateTime.now().subtract(Duration(days: 3)))),
      TransferTransaction()
        ..amountCentsProperty.set(20 * 100)
        ..fromEnvelopeProperty.set('Savings')
        ..toEnvelopeProperty.set('Tithe')
        ..budgetProperty.set(budgetEntity.id!)
        ..transactionDateProperty.set(Timestamp.of(DateTime.now().subtract(Duration(days: 2)))),
      IncomeTransaction()
        ..centsByEnvelopeIdProperty.set({
          'Tithe': 30 * 100,
          'Car': 70 * 100,
          'Emergency Savings': 200 * 100,
          'Savings': 300 * 100,
        })
        ..budgetProperty.set(budgetEntity.id!)
        ..transactionDateProperty.set(Timestamp.of(DateTime.now().subtract(Duration(days: 1)))),
    ];

    final budgetChange = budgetEntity.value.addTransactions(
      dropComponent,
      envelopeById: envelopes.mapToMap((envelope) => MapEntry(envelope.nameProperty.value, envelope)),
      transactions: transactions,
    );

    await Future.wait(budgetChange.modifiedEnvelopeById.mapToIterable((envelopeId, envelope) async {
      final envelopeEntity = await Query.getById<EnvelopeEntity>(envelopeId).get(dropComponent);
      await dropComponent.updateEntity(envelopeEntity..set(envelope));
    }));

    await Future.wait(transactions
        .map((transaction) => BudgetTransactionEntity.constructEntityFromTransactionTypeRuntime(transaction.runtimeType)
          ..set(transaction))
        .map((entity) => dropComponent.update(entity)));
  }
}
