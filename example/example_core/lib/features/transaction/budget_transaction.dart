import 'package:example_core/features/budget/budget_change.dart';
import 'package:example_core/features/budget/budget_entity.dart';
import 'package:example_core/features/envelope/envelope.dart';
import 'package:jlogical_utils_core/jlogical_utils_core.dart';
import 'package:meta/meta.dart';

abstract class BudgetTransaction extends ValueObject {
  static const affectedEnvelopesField = 'affectedEnvelopes';
  late final affectedEnvelopesProperty = computed<List<String>>(
    name: affectedEnvelopesField,
    computation: () => affectedEnvelopeIds,
  );

  static const budgetField = 'budget';
  late final budgetProperty = reference<BudgetEntity>(name: budgetField).required();

  static const transactionDateField = 'transactionDate';
  late final transactionDateProperty = field<Timestamp>(name: transactionDateField)
      .time()
      .onlyDate()
      .withDisplayName('Transaction Date')
      .withFallbackReplacement(() => Timestamp.now())
      .withDefault(() => Timestamp.now())
      .requiredOnEdit();

  List<String> get affectedEnvelopeIds;

  BudgetChange getBudgetChange(DropCoreContext context, {required Map<String, Envelope> envelopeById});

  @override
  @mustCallSuper
  late final List<ValueObjectBehavior> behaviors = [
    affectedEnvelopesProperty,
    budgetProperty,
    transactionDateProperty,
    creationTime(),
  ];
}
