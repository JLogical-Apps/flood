import 'package:example_core/features/budget/budget.dart';
import 'package:example_core/features/budget/budget_change.dart';
import 'package:example_core/features/budget/budget_entity.dart';
import 'package:example_core/features/envelope/envelope.dart';
import 'package:example_core/features/envelope/envelope_entity.dart';
import 'package:example_core/features/envelope_rule/daily_time_rule.dart';
import 'package:example_core/features/envelope_rule/firstfruit_envelope_rule.dart';
import 'package:example_core/features/envelope_rule/monthly_time_rule.dart';
import 'package:example_core/features/envelope_rule/repeating_goal_envelope_rule.dart';
import 'package:example_core/features/envelope_rule/surplus_envelope_rule.dart';
import 'package:example_core/features/envelope_rule/target_goal_envelope_rule.dart';
import 'package:example_core/features/transaction/envelope_transaction.dart';
import 'package:example_core/features/transaction/envelope_transaction_entity.dart';
import 'package:example_core/features/transaction/income_transaction.dart';
import 'package:example_core/features/transaction/income_transaction_entity.dart';
import 'package:example_core/features/transaction/transfer_transaction.dart';
import 'package:example_core/features/transaction/transfer_transaction_entity.dart';
import 'package:example_core/pond.dart';
import 'package:jlogical_utils_core/jlogical_utils_core.dart';
import 'package:test/test.dart';

void main() {
  late CorePondContext pondContext;
  setUp(() async {
    pondContext = await getTestingCorePondContext();
  });

  test('no change to budget with no envelopes.', () {
    expectBudgetChange(
      context: pondContext,
      envelopes: [],
      incomeCents: 10,
      expectedCentsByEnvelopeName: {},
    );
  });

  test('one rule gets all income.', () {
    const totalIncome = 100 * 100;
    const budgetId = '';

    expectBudgetChange(
      context: pondContext,
      envelopes: [
        Envelope()
          ..nameProperty.set('Firstfruit')
          ..ruleProperty.set(FirstfruitEnvelopeRule()..percentProperty.set(50))
          ..budgetProperty.set(budgetId),
      ],
      incomeCents: totalIncome,
      expectedCentsByEnvelopeName: {'Firstfruit': totalIncome},
    );

    expectBudgetChange(
      context: pondContext,
      envelopes: [
        Envelope()
          ..nameProperty.set('Repeating')
          ..ruleProperty.set(RepeatingGoalEnvelopeRule()
            ..goalCentsProperty.set(100)
            ..timeRuleProperty.set(DailyTimeRule()..daysProperty.set(5)))
          ..budgetProperty.set(budgetId),
      ],
      incomeCents: totalIncome,
      expectedCentsByEnvelopeName: {'Repeating': totalIncome},
    );

    expectBudgetChange(
      context: pondContext,
      envelopes: [
        Envelope()
          ..nameProperty.set('Target')
          ..ruleProperty.set(TargetGoalEnvelopeRule()
            ..percentProperty.set(50)
            ..maximumCentsProperty.set(10 * 100))
          ..budgetProperty.set(budgetId),
      ],
      incomeCents: totalIncome,
      expectedCentsByEnvelopeName: {'Target': totalIncome},
    );

    expectBudgetChange(
      context: pondContext,
      envelopes: [
        Envelope()
          ..nameProperty.set('Surplus')
          ..ruleProperty.set(SurplusEnvelopeRule()..percentProperty.set(50))
          ..budgetProperty.set(budgetId),
      ],
      incomeCents: totalIncome,
      expectedCentsByEnvelopeName: {'Surplus': totalIncome},
    );
  });

  test('only one rule type gets evenly distributed', () {
    const totalIncome = 100 * 100;
    const budgetId = '';

    expectBudgetChange(
      context: pondContext,
      envelopes: [
        Envelope()
          ..nameProperty.set('Firstfruit A')
          ..ruleProperty.set(FirstfruitEnvelopeRule()..percentProperty.set(10))
          ..budgetProperty.set(budgetId),
        Envelope()
          ..nameProperty.set('Firstfruit B')
          ..ruleProperty.set(FirstfruitEnvelopeRule()..percentProperty.set(10))
          ..budgetProperty.set(budgetId),
      ],
      incomeCents: totalIncome,
      expectedCentsByEnvelopeName: {
        'Firstfruit A': totalIncome ~/ 2,
        'Firstfruit B': totalIncome ~/ 2,
      },
    );

    expectBudgetChange(
      context: pondContext,
      envelopes: [
        Envelope()
          ..nameProperty.set('Firstfruit A')
          ..ruleProperty.set(FirstfruitEnvelopeRule()..percentProperty.set(10))
          ..budgetProperty.set(budgetId),
        Envelope()
          ..nameProperty.set('Firstfruit B')
          ..ruleProperty.set(FirstfruitEnvelopeRule()..percentProperty.set(30))
          ..budgetProperty.set(budgetId),
      ],
      incomeCents: totalIncome,
      expectedCentsByEnvelopeName: {
        'Firstfruit A': totalIncome ~/ 4,
        'Firstfruit B': totalIncome ~/ 4 * 3,
      },
    );

    expectBudgetChange(
      context: pondContext,
      envelopes: [
        Envelope()
          ..nameProperty.set('Repeating A')
          ..ruleProperty.set(RepeatingGoalEnvelopeRule()
            ..timeRuleProperty.set(MonthlyTimeRule())
            ..goalCentsProperty.set(totalIncome))
          ..budgetProperty.set(budgetId),
        Envelope()
          ..nameProperty.set('Repeating B')
          ..ruleProperty.set(RepeatingGoalEnvelopeRule()
            ..timeRuleProperty.set(MonthlyTimeRule())
            ..goalCentsProperty.set(totalIncome))
          ..budgetProperty.set(budgetId),
      ],
      incomeCents: totalIncome,
      expectedCentsByEnvelopeName: {
        'Repeating A': totalIncome ~/ 2,
        'Repeating B': totalIncome ~/ 2,
      },
    );

    expectBudgetChange(
      context: pondContext,
      envelopes: [
        Envelope()
          ..nameProperty.set('Target A')
          ..ruleProperty.set(TargetGoalEnvelopeRule()
            ..percentProperty.set(10)
            ..maximumCentsProperty.set(totalIncome))
          ..budgetProperty.set(budgetId),
        Envelope()
          ..nameProperty.set('Target B')
          ..ruleProperty.set(TargetGoalEnvelopeRule()
            ..percentProperty.set(10)
            ..maximumCentsProperty.set(totalIncome))
          ..budgetProperty.set(budgetId),
      ],
      incomeCents: totalIncome,
      expectedCentsByEnvelopeName: {
        'Target A': totalIncome ~/ 2,
        'Target B': totalIncome ~/ 2,
      },
    );

    expectBudgetChange(
      context: pondContext,
      envelopes: [
        Envelope()
          ..nameProperty.set('Surplus A')
          ..ruleProperty.set(SurplusEnvelopeRule()..percentProperty.set(10))
          ..budgetProperty.set(budgetId),
        Envelope()
          ..nameProperty.set('Surplus B')
          ..ruleProperty.set(SurplusEnvelopeRule()..percentProperty.set(10))
          ..budgetProperty.set(budgetId),
      ],
      incomeCents: totalIncome,
      expectedCentsByEnvelopeName: {
        'Surplus A': totalIncome ~/ 2,
        'Surplus B': totalIncome ~/ 2,
      },
    );
  });

  test('simple budget example', () {
    const totalIncome = 100 * 100;
    const budgetId = '';

    expectBudgetChange(
      context: pondContext,
      envelopes: [
        Envelope()
          ..nameProperty.set('Firstfruit')
          ..ruleProperty.set(FirstfruitEnvelopeRule()..percentProperty.set(10))
          ..budgetProperty.set(budgetId),
        Envelope()
          ..nameProperty.set('Repeating')
          ..ruleProperty.set(RepeatingGoalEnvelopeRule()
            ..goalCentsProperty.set(10 * 100)
            ..timeRuleProperty.set(DailyTimeRule()..daysProperty.set(3)))
          ..budgetProperty.set(budgetId),
        Envelope()
          ..nameProperty.set('Target')
          ..ruleProperty.set(TargetGoalEnvelopeRule()
            ..percentProperty.set(50)
            ..maximumCentsProperty.set(100 * 100))
          ..budgetProperty.set(budgetId),
        Envelope()
          ..nameProperty.set('Surplus')
          ..ruleProperty.set(SurplusEnvelopeRule()..percentProperty.set(10))
          ..budgetProperty.set(budgetId),
      ],
      incomeCents: totalIncome,
      expectedCentsByEnvelopeName: {
        'Firstfruit': totalIncome ~/ 10,
        'Repeating': 10 * 100,
        'Target': (100 * 100 - totalIncome ~/ 10 - 10 * 100) ~/ 2,
        'Surplus': (100 * 100 - totalIncome ~/ 10 - 10 * 100) ~/ 2,
      },
    );
  });

  test('multiple transactions budget change example.', () {
    const budgetId = '';
    final envelopes = [
      Envelope()
        ..nameProperty.set('Firstfruit')
        ..ruleProperty.set(FirstfruitEnvelopeRule()..percentProperty.set(10))
        ..budgetProperty.set(budgetId),
      Envelope()
        ..nameProperty.set('Repeating')
        ..ruleProperty.set(RepeatingGoalEnvelopeRule()
          ..goalCentsProperty.set(10 * 100)
          ..timeRuleProperty.set(DailyTimeRule()..daysProperty.set(3)))
        ..budgetProperty.set(budgetId),
      Envelope()
        ..nameProperty.set('Target')
        ..ruleProperty.set(TargetGoalEnvelopeRule()
          ..percentProperty.set(50)
          ..maximumCentsProperty.set(100 * 100))
        ..budgetProperty.set(budgetId),
      Envelope()
        ..nameProperty.set('Surplus')
        ..ruleProperty.set(SurplusEnvelopeRule()..percentProperty.set(10))
        ..budgetProperty.set(budgetId),
    ];

    final budgetChange = Budget.addTransactions(
      pondContext.dropCoreComponent,
      envelopeById: envelopes.mapToMap((envelope) => MapEntry(envelope.nameProperty.value, envelope)),
      transactions: [
        IncomeTransaction()
          ..centsByEnvelopeIdProperty.set({
            'Firstfruit': 20 * 100,
            'Repeating': 20 * 100,
            'Target': 20 * 100,
            'Surplus': 20 * 100,
          })
          ..budgetProperty.set(budgetId),
        EnvelopeTransaction()
          ..nameProperty.set('Payment')
          ..amountCentsProperty.set(-10 * 100)
          ..envelopeProperty.set('Firstfruit')
          ..budgetProperty.set(budgetId),
        EnvelopeTransaction()
          ..nameProperty.set('Refund')
          ..amountCentsProperty.set(10 * 100)
          ..envelopeProperty.set('Repeating')
          ..budgetProperty.set(budgetId),
        TransferTransaction()
          ..amountCentsProperty.set(10 * 100)
          ..fromEnvelopeProperty.set('Target')
          ..toEnvelopeProperty.set('Surplus')
          ..budgetProperty.set(budgetId)
      ],
    );

    expect(
        budgetChange,
        isA<BudgetChange>()
            .having(
              (budgetChange) => budgetChange.modifiedEnvelopeById['Firstfruit']!.amountCentsProperty.value,
              'Firstfruit',
              10 * 100,
            )
            .having(
              (budgetChange) => budgetChange.modifiedEnvelopeById['Repeating']!.amountCentsProperty.value,
              'Repeating',
              30 * 100,
            )
            .having(
              (budgetChange) => budgetChange.modifiedEnvelopeById['Target']!.amountCentsProperty.value,
              'Target',
              10 * 100,
            )
            .having(
              (budgetChange) => budgetChange.modifiedEnvelopeById['Surplus']!.amountCentsProperty.value,
              'Surplus',
              30 * 100,
            ));
  });

  test('creating and deleting envelope transactions', () async {
    final budgetEntity = await pondContext.dropCoreComponent.updateEntity(
        BudgetEntity(),
        (Budget budget) => budget
          ..nameProperty.set('Budget')
          ..ownerProperty.set('asdf'));

    final envelopeEntity = await pondContext.dropCoreComponent.updateEntity(
        EnvelopeEntity(),
        (Envelope envelope) => envelope
          ..nameProperty.set('Envelope')
          ..budgetProperty.set(budgetEntity.id!));

    await budgetEntity.updateAddTransaction(
      pondContext.dropCoreComponent,
      transactionEntity: EnvelopeTransactionEntity()
        ..set(EnvelopeTransaction()
          ..nameProperty.set('Refund')
          ..envelopeProperty.set(envelopeEntity.id!)
          ..budgetProperty.set(budgetEntity.id!)
          ..amountCentsProperty.set(10 * 100)),
    );

    final envelopeTransactionEntity = await budgetEntity.updateAddTransaction(
      pondContext.dropCoreComponent,
      transactionEntity: EnvelopeTransactionEntity()
        ..set(EnvelopeTransaction()
          ..nameProperty.set('Payment')
          ..envelopeProperty.set(envelopeEntity.id!)
          ..budgetProperty.set(budgetEntity.id!)
          ..amountCentsProperty.set(-5 * 100)),
    );

    var updatedEnvelope = await Query.getById<EnvelopeEntity>(envelopeEntity.id!).get(pondContext.dropCoreComponent);
    expect(updatedEnvelope.value.amountCentsProperty.value, 5 * 100);

    await pondContext.dropCoreComponent.delete(envelopeTransactionEntity);

    updatedEnvelope = await Query.getById<EnvelopeEntity>(envelopeEntity.id!).get(pondContext.dropCoreComponent);
    expect(updatedEnvelope.value.amountCentsProperty.value, 10 * 100);
  });

  test('creating and deleting transfer transactions', () async {
    final budgetEntity = await pondContext.dropCoreComponent.updateEntity(
        BudgetEntity(),
        (Budget budget) => budget
          ..nameProperty.set('Budget')
          ..ownerProperty.set('asdf'));

    final fromEnvelopeEntity = await pondContext.dropCoreComponent.updateEntity(
        EnvelopeEntity(),
        (Envelope envelope) => envelope
          ..nameProperty.set('Envelope')
          ..budgetProperty.set(budgetEntity.id!));

    final toEnvelopeEntity = await pondContext.dropCoreComponent.updateEntity(
        EnvelopeEntity(),
        (Envelope envelope) => envelope
          ..nameProperty.set('Envelope')
          ..budgetProperty.set(budgetEntity.id!));

    final transferTransactionEntity = await budgetEntity.updateAddTransaction(
      pondContext.dropCoreComponent,
      transactionEntity: TransferTransactionEntity()
        ..set(TransferTransaction()
          ..fromEnvelopeProperty.set(fromEnvelopeEntity.id!)
          ..toEnvelopeProperty.set(toEnvelopeEntity.id!)
          ..budgetProperty.set(budgetEntity.id!)
          ..amountCentsProperty.set(10 * 100)),
    );

    var updatedFromEnvelope =
        await Query.getById<EnvelopeEntity>(fromEnvelopeEntity.id!).get(pondContext.dropCoreComponent);
    var updatedToEnvelope =
        await Query.getById<EnvelopeEntity>(toEnvelopeEntity.id!).get(pondContext.dropCoreComponent);

    expect(updatedFromEnvelope.value.amountCentsProperty.value, -10 * 100);
    expect(updatedToEnvelope.value.amountCentsProperty.value, 10 * 100);

    await pondContext.dropCoreComponent.delete(transferTransactionEntity);

    updatedFromEnvelope =
        await Query.getById<EnvelopeEntity>(fromEnvelopeEntity.id!).get(pondContext.dropCoreComponent);
    updatedToEnvelope = await Query.getById<EnvelopeEntity>(toEnvelopeEntity.id!).get(pondContext.dropCoreComponent);
    expect(updatedFromEnvelope.value.amountCentsProperty.value, 0);
    expect(updatedToEnvelope.value.amountCentsProperty.value, 0);
  });

  test('creating and deleting income transactions', () async {
    final budgetEntity = await pondContext.dropCoreComponent.updateEntity(
        BudgetEntity(),
        (Budget budget) => budget
          ..nameProperty.set('Budget')
          ..ownerProperty.set('asdf'));

    final envelopeEntity = await pondContext.dropCoreComponent.updateEntity(
        EnvelopeEntity(),
        (Envelope envelope) => envelope
          ..nameProperty.set('Envelope')
          ..budgetProperty.set(budgetEntity.id!));

    final incomeTransactionEntity = await budgetEntity.updateAddTransaction(
      pondContext.dropCoreComponent,
      transactionEntity: IncomeTransactionEntity()
        ..set(IncomeTransaction()
          ..centsByEnvelopeIdProperty.set({
            envelopeEntity.id!: 10 * 100,
          })
          ..budgetProperty.set(budgetEntity.id!)),
    );

    var updatedEnvelope = await Query.getById<EnvelopeEntity>(envelopeEntity.id!).get(pondContext.dropCoreComponent);
    expect(updatedEnvelope.value.amountCentsProperty.value, 10 * 100);

    await pondContext.dropCoreComponent.delete(incomeTransactionEntity);

    updatedEnvelope = await Query.getById<EnvelopeEntity>(envelopeEntity.id!).get(pondContext.dropCoreComponent);
    expect(updatedEnvelope.value.amountCentsProperty.value, 0 * 100);
  });

  test('adding/deleting income updates repeating goals.', () async {
    final budgetEntity = await pondContext.dropCoreComponent.updateEntity(
        BudgetEntity(),
        (Budget budget) => budget
          ..nameProperty.set('Budget')
          ..ownerProperty.set('asdf'));

    final monthlyGoalEnvelope = await pondContext.dropCoreComponent.updateEntity(
        EnvelopeEntity(),
        (Envelope envelope) => envelope
          ..nameProperty.set('Envelope')
          ..budgetProperty.set(budgetEntity.id!)
          ..ruleProperty.set(RepeatingGoalEnvelopeRule()
            ..goalCentsProperty.set(10 * 100)
            ..lastAppliedDateProperty.set(Timestamp.of(DateTime.now().subtract(Duration(seconds: 1))))
            ..remainingGoalCentsProperty.set(10 * 100)
            ..timeRuleProperty.set(MonthlyTimeRule())));

    final periodicGoalEnvelope = await pondContext.dropCoreComponent.updateEntity(
        EnvelopeEntity(),
        (Envelope envelope) => envelope
          ..nameProperty.set('Envelope')
          ..budgetProperty.set(budgetEntity.id!)
          ..ruleProperty.set(RepeatingGoalEnvelopeRule()
            ..goalCentsProperty.set(10 * 100)
            ..lastAppliedDateProperty.set(Timestamp.of(DateTime.now().subtract(Duration(seconds: 1))))
            ..remainingGoalCentsProperty.set(10 * 100)
            ..timeRuleProperty.set(DailyTimeRule()..daysProperty.set(7))));

    final incomeTransactionEntity = await budgetEntity.updateAddTransaction(
      pondContext.dropCoreComponent,
      transactionEntity: IncomeTransactionEntity()
        ..set(IncomeTransaction()
          ..centsByEnvelopeIdProperty.set({
            monthlyGoalEnvelope.id!: 8 * 100,
            periodicGoalEnvelope.id!: 8 * 100,
          })
          ..budgetProperty.set(budgetEntity.id!)),
    );

    var updatedMonthlyEnvelope =
        await Query.getById<EnvelopeEntity>(monthlyGoalEnvelope.id!).get(pondContext.dropCoreComponent);
    expect(updatedMonthlyEnvelope.value.amountCentsProperty.value, 8 * 100);
    expect(
      updatedMonthlyEnvelope.value.ruleProperty.value,
      isA<RepeatingGoalEnvelopeRule>().having(
          (RepeatingGoalEnvelopeRule rule) => rule.remainingGoalCentsProperty.value, 'remainingGoalCents', 2 * 100),
    );

    var updatedPeriodicEnvelope =
        await Query.getById<EnvelopeEntity>(periodicGoalEnvelope.id!).get(pondContext.dropCoreComponent);
    expect(updatedPeriodicEnvelope.value.amountCentsProperty.value, 8 * 100);
    expect(
      updatedPeriodicEnvelope.value.ruleProperty.value,
      isA<RepeatingGoalEnvelopeRule>().having(
          (RepeatingGoalEnvelopeRule rule) => rule.remainingGoalCentsProperty.value, 'remainingGoalCents', 2 * 100),
    );

    await pondContext.dropCoreComponent.delete(incomeTransactionEntity);

    updatedMonthlyEnvelope =
        await Query.getById<EnvelopeEntity>(monthlyGoalEnvelope.id!).get(pondContext.dropCoreComponent);
    expect(updatedMonthlyEnvelope.value.amountCentsProperty.value, 0 * 100);
    expect(
      updatedMonthlyEnvelope.value.ruleProperty.value,
      isA<RepeatingGoalEnvelopeRule>().having(
          (RepeatingGoalEnvelopeRule rule) => rule.remainingGoalCentsProperty.value, 'remainingGoalCents', 10 * 100),
    );

    updatedPeriodicEnvelope =
        await Query.getById<EnvelopeEntity>(periodicGoalEnvelope.id!).get(pondContext.dropCoreComponent);
    expect(updatedPeriodicEnvelope.value.amountCentsProperty.value, 0 * 100);
    expect(
      updatedPeriodicEnvelope.value.ruleProperty.value,
      isA<RepeatingGoalEnvelopeRule>().having(
          (RepeatingGoalEnvelopeRule rule) => rule.remainingGoalCentsProperty.value, 'remainingGoalCents', 10 * 100),
    );
  });

  test('initializing repeating goal.', () async {
    final budgetEntity = await pondContext.dropCoreComponent.updateEntity(
        BudgetEntity(),
        (Budget budget) => budget
          ..nameProperty.set('Budget')
          ..ownerProperty.set('asdf'));

    final monthlyGoalEnvelope = await pondContext.dropCoreComponent.updateEntity(
        EnvelopeEntity(),
        (Envelope envelope) => envelope
          ..nameProperty.set('Envelope')
          ..budgetProperty.set(budgetEntity.id!)
          ..ruleProperty.set(RepeatingGoalEnvelopeRule()
            ..goalCentsProperty.set(10 * 100)
            ..lastAppliedDateProperty.set(Timestamp.of(DateTime.now().subtract(Duration(days: 32))))
            ..remainingGoalCentsProperty.set(10 * 100)
            ..timeRuleProperty.set(MonthlyTimeRule())));

    final periodicGoalEnvelope = await pondContext.dropCoreComponent.updateEntity(
        EnvelopeEntity(),
        (Envelope envelope) => envelope
          ..nameProperty.set('Envelope')
          ..budgetProperty.set(budgetEntity.id!)
          ..ruleProperty.set(RepeatingGoalEnvelopeRule()
            ..goalCentsProperty.set(10 * 100)
            ..lastAppliedDateProperty.set(Timestamp.of(DateTime.now().subtract(Duration(days: 8))))
            ..remainingGoalCentsProperty.set(10 * 100)
            ..timeRuleProperty.set(DailyTimeRule()..daysProperty.set(7))));

    expect(
      (monthlyGoalEnvelope.value.ruleProperty.value as RepeatingGoalEnvelopeRule).remainingGoalCentsProperty.value,
      greaterThan(10 * 100),
    );
    expect(
      (periodicGoalEnvelope.value.ruleProperty.value as RepeatingGoalEnvelopeRule).remainingGoalCentsProperty.value,
      greaterThan(10 * 100),
    );
  });
}

void expectBudgetChange({
  required CorePondContext context,
  required List<Envelope> envelopes,
  required int incomeCents,
  required Map<String, int> expectedCentsByEnvelopeName,
}) {
  final budgetChange = Budget.addIncome(
    context.dropCoreComponent,
    incomeCents: incomeCents,
    envelopeById: envelopes.mapToMap((envelope) => MapEntry(envelope.nameProperty.value, envelope)),
  );
  expect(
    budgetChange.modifiedEnvelopeById.map((id, envelope) => MapEntry(id, envelope.amountCentsProperty.value)),
    expectedCentsByEnvelopeName,
  );
}
