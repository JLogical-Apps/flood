import 'package:example/features/budget/budget.dart';
import 'package:example/features/budget/budget_change.dart';
import 'package:example/features/envelope/envelope.dart';
import 'package:example/features/envelope_rule/daily_time_rule.dart';
import 'package:example/features/envelope_rule/firstfruit_envelope_rule.dart';
import 'package:example/features/envelope_rule/monthly_time_rule.dart';
import 'package:example/features/envelope_rule/repeating_goal_envelope_rule.dart';
import 'package:example/features/envelope_rule/surplus_envelope_rule.dart';
import 'package:example/features/envelope_rule/target_goal_envelope_rule.dart';
import 'package:example/features/transaction/envelope_transaction.dart';
import 'package:example/features/transaction/income_transaction.dart';
import 'package:example/features/transaction/transfer_transaction.dart';
import 'package:example/pond.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

void main() {
  late CorePondContext pondContext;
  setUp(() async {
    pondContext = await getCorePondContext();
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
            ..timeRuleProperty.set(MonthlyTimeRule()..dayOfMonthProperty.set(1))
            ..goalCentsProperty.set(totalIncome))
          ..budgetProperty.set(budgetId),
        Envelope()
          ..nameProperty.set('Repeating B')
          ..ruleProperty.set(RepeatingGoalEnvelopeRule()
            ..timeRuleProperty.set(MonthlyTimeRule()..dayOfMonthProperty.set(1))
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

    final budgetChange = Budget().addTransactions(
      envelopeById: envelopes.mapToMap((envelope) => MapEntry(envelope.nameProperty.value, envelope)),
      transactions: [
        IncomeTransaction()
          ..centsByEnvelopeProperty.set({
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
          ..nameProperty.set('Transfer')
          ..amountCentsProperty.set(10 * 100)
          ..fromEnvelopeProperty.set('Target')
          ..toEnvelopeProperty.set('Surplus')
          ..budgetProperty.set(budgetId)
      ],
    );

    expect(
        budgetChange,
        isA<BudgetChange>()
            .having((budgetChange) => budgetChange.isIncome, 'isIncome', isFalse)
            .having((budgetChange) => budgetChange.modifiedCentsByEnvelopeId['Firstfruit'], 'Firstfruit', 10 * 100)
            .having((budgetChange) => budgetChange.modifiedCentsByEnvelopeId['Repeating'], 'Repeating', 30 * 100)
            .having((budgetChange) => budgetChange.modifiedCentsByEnvelopeId['Target'], 'Target', 10 * 100)
            .having((budgetChange) => budgetChange.modifiedCentsByEnvelopeId['Surplus'], 'Surplus', 30 * 100));
  });
}

void expectBudgetChange({
  required CorePondContext context,
  required List<Envelope> envelopes,
  required int incomeCents,
  required Map<String, int> expectedCentsByEnvelopeName,
}) {
  final budgetChange = Budget().addIncome(
    context: context.locate<DropCoreComponent>(),
    incomeCents: incomeCents,
    envelopeById: envelopes.mapToMap((envelope) => MapEntry(envelope.nameProperty.value, envelope)),
  );
  expect(budgetChange.modifiedCentsByEnvelopeId, expectedCentsByEnvelopeName);
}
