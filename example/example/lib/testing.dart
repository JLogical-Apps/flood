import 'package:example_core/features/budget/budget.dart';
import 'package:example_core/features/budget/budget_entity.dart';
import 'package:example_core/features/envelope/envelope.dart';
import 'package:example_core/features/envelope/envelope_entity.dart';
import 'package:example_core/features/envelope_rule/daily_time_rule.dart';
import 'package:example_core/features/envelope_rule/firstfruit_envelope_rule.dart';
import 'package:example_core/features/envelope_rule/monthly_time_rule.dart';
import 'package:example_core/features/envelope_rule/repeating_goal_envelope_rule.dart';
import 'package:example_core/features/envelope_rule/surplus_envelope_rule.dart';
import 'package:example_core/features/envelope_rule/target_goal_envelope_rule.dart';
import 'package:example_core/features/transaction/budget_transaction_entity.dart';
import 'package:example_core/features/transaction/envelope_transaction.dart';
import 'package:example_core/features/transaction/income_transaction.dart';
import 'package:example_core/features/transaction/transfer_transaction.dart';
import 'package:example_core/features/tray/tray.dart';
import 'package:example_core/features/tray/tray_entity.dart';
import 'package:example_core/features/user/user.dart';
import 'package:example_core/features/user/user_entity.dart';
import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

Future<void> setupTesting(CorePondContext corePondContext) async {
  final authComponent = corePondContext.locate<AuthCoreComponent>();
  final dropComponent = corePondContext.locate<DropCoreComponent>();

  final account = await authComponent.signup('test@test.com', 'password');

  final userEntity = await dropComponent.updateEntity(
    UserEntity()..id = account.accountId,
    (User user) => user
      ..nameProperty.set('John Doe')
      ..emailProperty.set('test@test.com'),
  );

  final budgetEntity = await dropComponent.updateEntity(
    BudgetEntity()..id = 'budget',
    (Budget budget) => budget
      ..nameProperty.set('Budget')
      ..ownerProperty.set(userEntity.id!),
  );

  final trayEntity = await corePondContext.dropCoreComponent.updateEntity(
      TrayEntity(),
      (Tray tray) => tray
        ..nameProperty.set('Repeating')
        ..budgetProperty.set(budgetEntity.id!)
        ..colorProperty.set(Colors.blue.value));

  final envelopes = [
    Envelope()
      ..budgetProperty.set(budgetEntity.id!)
      ..nameProperty.set('Tithe')
      ..colorProperty.set(Colors.blue.value)
      ..ruleProperty.set(FirstfruitEnvelopeRule()..percentProperty.set(10)),
    Envelope()
      ..budgetProperty.set(budgetEntity.id!)
      ..nameProperty.set('Woodworking')
      ..colorProperty.set(Colors.orange.value)
      ..ruleProperty.set(SurplusEnvelopeRule()..percentProperty.set(10))
      ..archivedProperty.set(true),
    Envelope()
      ..budgetProperty.set(budgetEntity.id!)
      ..nameProperty.set('Car')
      ..trayProperty.set(trayEntity.id!)
      ..lockedProperty.set(true)
      ..colorProperty.set(Colors.orange.value)
      ..ruleProperty.set(RepeatingGoalEnvelopeRule()
        ..goalCentsProperty.set(100 * 100)
        ..timeRuleProperty.set(MonthlyTimeRule())
        ..remainingGoalCentsProperty.set(100 * 100)
        ..lastAppliedDateProperty.set(Timestamp.of(DateTime.now().subtract(Duration(days: 6))))),
    Envelope()
      ..budgetProperty.set(budgetEntity.id!)
      ..nameProperty.set('Eating Out')
      ..trayProperty.set(trayEntity.id!)
      ..colorProperty.set(Colors.green.value)
      ..ruleProperty.set(RepeatingGoalEnvelopeRule()
        ..goalCentsProperty.set(80 * 100)
        ..timeRuleProperty.set(DailyTimeRule()..daysProperty.set(7))
        ..remainingGoalCentsProperty.set(40 * 100)
        ..lastAppliedDateProperty.set(Timestamp.of(DateTime.now().subtract(Duration(days: 4))))),
    Envelope()
      ..budgetProperty.set(budgetEntity.id!)
      ..nameProperty.set('Mortgage')
      ..colorProperty.set(Colors.red.value)
      ..ruleProperty.set(RepeatingGoalEnvelopeRule()
        ..goalCentsProperty.set(3000 * 100)
        ..timeRuleProperty.set(MonthlyTimeRule())
        ..remainingGoalCentsProperty.set(3000 * 100)
        ..lastAppliedDateProperty.set(Timestamp.of(DateTime.now().subtract(Duration(days: 6))))),
    Envelope()
      ..budgetProperty.set(budgetEntity.id!)
      ..nameProperty.set('Jake Personal')
      ..colorProperty.set(Colors.pink.value)
      ..ruleProperty.set(RepeatingGoalEnvelopeRule()
        ..goalCentsProperty.set(50 * 100)
        ..timeRuleProperty.set(MonthlyTimeRule())
        ..remainingGoalCentsProperty.set(50 * 100)
        ..lastAppliedDateProperty.set(Timestamp.of(DateTime.now().subtract(Duration(days: 6))))),
    Envelope()
      ..budgetProperty.set(budgetEntity.id!)
      ..nameProperty.set('Subscriptions')
      ..colorProperty.set(Colors.orange.value)
      ..ruleProperty.set(RepeatingGoalEnvelopeRule()
        ..goalCentsProperty.set(30 * 100)
        ..timeRuleProperty.set(MonthlyTimeRule())
        ..remainingGoalCentsProperty.set(30 * 100)
        ..lastAppliedDateProperty.set(Timestamp.of(DateTime.now().subtract(Duration(days: 6))))),
    Envelope()
      ..budgetProperty.set(budgetEntity.id!)
      ..nameProperty.set('Health Insurance')
      ..colorProperty.set(Colors.blue.value)
      ..ruleProperty.set(RepeatingGoalEnvelopeRule()
        ..goalCentsProperty.set(8 * 100)
        ..timeRuleProperty.set(MonthlyTimeRule())
        ..remainingGoalCentsProperty.set(8 * 100)
        ..lastAppliedDateProperty.set(Timestamp.of(DateTime.now().subtract(Duration(days: 6))))),
    Envelope()
      ..budgetProperty.set(budgetEntity.id!)
      ..nameProperty.set('Car Maintennance')
      ..colorProperty.set(Colors.orange.value)
      ..ruleProperty.set(RepeatingGoalEnvelopeRule()
        ..goalCentsProperty.set(12 * 100)
        ..timeRuleProperty.set(MonthlyTimeRule())
        ..remainingGoalCentsProperty.set(12 * 100)
        ..lastAppliedDateProperty.set(Timestamp.of(DateTime.now().subtract(Duration(days: 6))))),
    Envelope()
      ..budgetProperty.set(budgetEntity.id!)
      ..nameProperty.set('Emergency Savings')
      ..colorProperty.set(Colors.lightGreen.value)
      ..ruleProperty.set(TargetGoalEnvelopeRule()
        ..percentProperty.set(20)
        ..maximumCentsProperty.set(1000 * 100)),
    Envelope()
      ..budgetProperty.set(budgetEntity.id!)
      ..nameProperty.set('Savings')
      ..ruleProperty.set(SurplusEnvelopeRule()..percentProperty.set(100)),
    Envelope()
      ..budgetProperty.set(budgetEntity.id!)
      ..nameProperty.set('Custom'),
    Envelope()
      ..budgetProperty.set(budgetEntity.id!)
      ..nameProperty.set('Vacation')
      ..ruleProperty.set(SurplusEnvelopeRule()..percentProperty.set(10)),
  ];

  await Future.wait(envelopes
      .map((envelope) => EnvelopeEntity()
        ..id = envelope.nameProperty.value
        ..set(envelope))
      .map((entity) => dropComponent.update(entity)));

  final transactions = [
    IncomeTransaction()
      ..centsByEnvelopeIdProperty.set({
        'Tithe': 20 * 100,
        'Car': 40 * 100,
        'Emergency Savings': 80 * 100,
        'Savings': 20 * 100,
        'Eating Out': 20 * 100,
        'Mortgage': 200 * 100,
        'Health Insurance': 4 * 100,
        'Car Maintennance': 10 * 100,
        'Subscriptions': 4 * 100,
        'Jake Personal': 5 * 100,
      })
      ..budgetProperty.set(budgetEntity.id!)
      ..transactionDateProperty.set(Timestamp.of(DateTime.now())),
    EnvelopeTransaction()
      ..nameProperty.set('Grocery Shopping')
      ..amountCentsProperty.set(-20 * 100)
      ..envelopeProperty.set('Eating Out')
      ..budgetProperty.set(budgetEntity.id!)
      ..transactionDateProperty.set(Timestamp.of(DateTime.now().subtract(Duration(days: 5)))),
    EnvelopeTransaction()
      ..nameProperty.set('Monthly Mortgage Payment')
      ..amountCentsProperty.set(-3000 * 100)
      ..envelopeProperty.set('Mortgage')
      ..budgetProperty.set(budgetEntity.id!)
      ..transactionDateProperty.set(Timestamp.of(DateTime.now().subtract(Duration(days: 10)))),
    EnvelopeTransaction()
      ..nameProperty.set('Car Fuel')
      ..amountCentsProperty.set(-60 * 100)
      ..envelopeProperty.set('Car')
      ..budgetProperty.set(budgetEntity.id!)
      ..transactionDateProperty.set(Timestamp.of(DateTime.now().subtract(Duration(days: 7)))),
    EnvelopeTransaction()
      ..nameProperty.set('Health Insurance Premium')
      ..amountCentsProperty.set(-80 * 100)
      ..envelopeProperty.set('Health Insurance')
      ..budgetProperty.set(budgetEntity.id!)
      ..transactionDateProperty.set(Timestamp.of(DateTime.now().subtract(Duration(days: 15)))),
    EnvelopeTransaction()
      ..nameProperty.set('Netflix Subscription')
      ..amountCentsProperty.set(-15 * 100)
      ..envelopeProperty.set('Subscriptions')
      ..budgetProperty.set(budgetEntity.id!)
      ..transactionDateProperty.set(Timestamp.of(DateTime.now().subtract(Duration(days: 20)))),
    TransferTransaction()
      ..amountCentsProperty.set(50 * 100)
      ..fromEnvelopeProperty.set('Savings')
      ..toEnvelopeProperty.set('Vacation')
      ..budgetProperty.set(budgetEntity.id!)
      ..transactionDateProperty.set(Timestamp.of(DateTime.now().subtract(Duration(days: 6)))),
    TransferTransaction()
      ..amountCentsProperty.set(100 * 100)
      ..fromEnvelopeProperty.set('Savings')
      ..toEnvelopeProperty.set('Emergency Savings')
      ..budgetProperty.set(budgetEntity.id!)
      ..transactionDateProperty.set(Timestamp.of(DateTime.now().subtract(Duration(days: 8)))),
    EnvelopeTransaction()
      ..nameProperty.set('Woodworking Supplies')
      ..amountCentsProperty.set(-80 * 100)
      ..envelopeProperty.set('Woodworking')
      ..budgetProperty.set(budgetEntity.id!)
      ..transactionDateProperty.set(Timestamp.of(DateTime.now().subtract(Duration(days: 12)))),
    EnvelopeTransaction()
      ..nameProperty.set('Date Night')
      ..amountCentsProperty.set(-25 * 100)
      ..envelopeProperty.set('Eating Out')
      ..budgetProperty.set(budgetEntity.id!)
      ..transactionDateProperty.set(Timestamp.of(DateTime.now().subtract(Duration(days: 18)))),
    EnvelopeTransaction()
      ..nameProperty.set('Birthday Gift')
      ..amountCentsProperty.set(-50 * 100)
      ..envelopeProperty.set('Jake Personal')
      ..budgetProperty.set(budgetEntity.id!)
      ..transactionDateProperty.set(Timestamp.of(DateTime.now().subtract(Duration(days: 21)))),
    EnvelopeTransaction()
      ..nameProperty.set('Savings Allocation')
      ..amountCentsProperty.set(200 * 100)
      ..envelopeProperty.set('Savings')
      ..budgetProperty.set(budgetEntity.id!)
      ..transactionDateProperty.set(Timestamp.of(DateTime.now().subtract(Duration(days: 1)))),
    EnvelopeTransaction()
      ..nameProperty.set('Emergency Fund Top-up')
      ..amountCentsProperty.set(150 * 100)
      ..envelopeProperty.set('Emergency Savings')
      ..budgetProperty.set(budgetEntity.id!)
      ..transactionDateProperty.set(Timestamp.of(DateTime.now().subtract(Duration(days: 3)))),
    EnvelopeTransaction()
      ..nameProperty.set('Vacation Savings')
      ..amountCentsProperty.set(180 * 100)
      ..envelopeProperty.set('Vacation')
      ..budgetProperty.set(budgetEntity.id!)
      ..transactionDateProperty.set(Timestamp.of(DateTime.now().subtract(Duration(days: 7)))),
  ];

  final budgetChange = Budget.addTransactions(
    dropComponent,
    envelopeById: envelopes.mapToMap((envelope) => MapEntry(envelope.nameProperty.value, envelope)),
    transactions: transactions,
  );

  await Future.wait(budgetChange.modifiedEnvelopeById.mapToIterable((envelopeId, envelope) async {
    final envelopeEntity = await Query.getById<EnvelopeEntity>(envelopeId).get(dropComponent);
    await dropComponent.updateEntity(envelopeEntity..set(envelope));
  }));

  await Future.wait(transactions
      .map((transaction) =>
          BudgetTransactionEntity.constructEntityFromTransactionTypeRuntime(transaction.runtimeType)..set(transaction))
      .map((entity) => dropComponent.update(entity)));
}
