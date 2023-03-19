import 'package:example/features/budget/budget.dart';
import 'package:example/features/envelope/envelope.dart';
import 'package:example/features/envelope_rule/daily_time_rule.dart';
import 'package:example/features/envelope_rule/firstfruit_envelope_rule.dart';
import 'package:example/features/envelope_rule/repeating_goal_envelope_rule.dart';
import 'package:example/features/envelope_rule/surplus_envelope_rule.dart';
import 'package:example/features/envelope_rule/target_goal_envelope_rule.dart';
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
