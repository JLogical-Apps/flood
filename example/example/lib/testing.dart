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
        ..budgetProperty.set(budgetEntity.id!));

  final envelopes = [
    Envelope()
      ..budgetProperty.set(budgetEntity.id!)
      ..nameProperty.set('Tithe')
      ..ruleProperty.set(FirstfruitEnvelopeRule()..percentProperty.set(10)),
    Envelope()
      ..budgetProperty.set(budgetEntity.id!)
      ..nameProperty.set('Car')
      ..trayProperty.set(trayEntity.id!)
      ..ruleProperty.set(RepeatingGoalEnvelopeRule()
        ..goalCentsProperty.set(100 * 100)
        ..timeRuleProperty.set(MonthlyTimeRule())
        ..remainingGoalCentsProperty.set(100 * 100)
        ..lastAppliedDateProperty.set(Timestamp.of(DateTime.now().subtract(Duration(days: 6))))),
    Envelope()
      ..budgetProperty.set(budgetEntity.id!)
      ..nameProperty.set('Eating Out')
      ..trayProperty.set(trayEntity.id!)
      ..ruleProperty.set(RepeatingGoalEnvelopeRule()
        ..goalCentsProperty.set(40 * 100)
        ..timeRuleProperty.set(DailyTimeRule()..daysProperty.set(7))
        ..remainingGoalCentsProperty.set(40 * 100)
        ..lastAppliedDateProperty.set(Timestamp.of(DateTime.now().subtract(Duration(days: 4))))),
    Envelope()
      ..budgetProperty.set(budgetEntity.id!)
      ..nameProperty.set('Mortgage')
      ..ruleProperty.set(RepeatingGoalEnvelopeRule()
        ..goalCentsProperty.set(3000 * 100)
        ..timeRuleProperty.set(MonthlyTimeRule())
        ..remainingGoalCentsProperty.set(3000 * 100)
        ..lastAppliedDateProperty.set(Timestamp.of(DateTime.now().subtract(Duration(days: 6))))),
    Envelope()
      ..budgetProperty.set(budgetEntity.id!)
      ..nameProperty.set('Jake Personal')
      ..ruleProperty.set(RepeatingGoalEnvelopeRule()
        ..goalCentsProperty.set(50 * 100)
        ..timeRuleProperty.set(MonthlyTimeRule())
        ..remainingGoalCentsProperty.set(50 * 100)
        ..lastAppliedDateProperty.set(Timestamp.of(DateTime.now().subtract(Duration(days: 6))))),
    Envelope()
      ..budgetProperty.set(budgetEntity.id!)
      ..nameProperty.set('Subscriptions')
      ..ruleProperty.set(RepeatingGoalEnvelopeRule()
        ..goalCentsProperty.set(30 * 100)
        ..timeRuleProperty.set(MonthlyTimeRule())
        ..remainingGoalCentsProperty.set(30 * 100)
        ..lastAppliedDateProperty.set(Timestamp.of(DateTime.now().subtract(Duration(days: 6))))),
    Envelope()
      ..budgetProperty.set(budgetEntity.id!)
      ..nameProperty.set('Health Insurance')
      ..ruleProperty.set(RepeatingGoalEnvelopeRule()
        ..goalCentsProperty.set(8 * 100)
        ..timeRuleProperty.set(MonthlyTimeRule())
        ..remainingGoalCentsProperty.set(8 * 100)
        ..lastAppliedDateProperty.set(Timestamp.of(DateTime.now().subtract(Duration(days: 6))))),
    Envelope()
      ..budgetProperty.set(budgetEntity.id!)
      ..nameProperty.set('Car Maintennance')
      ..ruleProperty.set(RepeatingGoalEnvelopeRule()
        ..goalCentsProperty.set(12 * 100)
        ..timeRuleProperty.set(MonthlyTimeRule())
        ..remainingGoalCentsProperty.set(12 * 100)
        ..lastAppliedDateProperty.set(Timestamp.of(DateTime.now().subtract(Duration(days: 6))))),
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
    for (var i = 0; i < 100; i++)
      EnvelopeTransaction()
        ..nameProperty.set('Transaction $i')
        ..amountCentsProperty.set(-i * 100)
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
