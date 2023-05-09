import 'package:collection/collection.dart';
import 'package:example/features/budget/budget_change.dart';
import 'package:example/features/envelope/envelope.dart';
import 'package:example/features/transaction/budget_transaction.dart';
import 'package:example/features/user/user_entity.dart';
import 'package:jlogical_utils_core/jlogical_utils_core.dart';

class Budget extends ValueObject {
  static const nameField = 'name';
  late final nameProperty = field<String>(name: nameField).withDisplayName('Name').isNotBlank();

  static const ownerField = 'owner';
  late final ownerProperty = reference<UserEntity>(name: ownerField).required();

  @override
  late final List<ValueObjectBehavior> behaviors = [
    nameProperty,
    ownerProperty,
    creationTime(),
  ];

  /// Returns a [BudgetChange] of adding income to the budget. Does not actually apply the income to this budget.
  ///
  /// Here is the formula for adding income to a budget:
  /// 1. Group envelopes by their rule's priority.
  /// 2. Begin a *round*. Get the requested amount each envelope is asking for from the remaining cents.
  /// 3. Give each envelope their requested amount of cents.
  /// 4. Repeat step 2 until all envelopes have finished.
  /// 5. If there are more cents remaining, distribute it based on the proportion of the amount that the final group of
  ///    envelopes requested it for.
  ///
  /// Notes:
  /// * If a round requested more than the remaining cents, distribute the remaining cents based on the proportion of
  ///   the amount that group of envelopes requested it for.
  BudgetChange addIncome({
    required DropCoreContext context,
    required int incomeCents,
    required Map<String, Envelope> envelopeById,
  }) {
    if (envelopeById.isEmpty) {
      return BudgetChange(modifiedCentsByEnvelopeId: {}, isIncome: true);
    }

    var remainingCents = incomeCents;

    final modifiedCentsByEnvelopeId = <String, int>{};

    // A map that maps priorities with a map of (envelope ids -> envelopes) of that priority.
    final envelopesMapByPriority = envelopeById.entries
        .groupListsBy((entry) => entry.value.ruleProperty.value!.priority)
        .map((priority, idToEnvelopeEntries) => MapEntry(priority, Map.fromEntries(idToEnvelopeEntries)));

    final envelopePriorities = envelopesMapByPriority.keys.toList()..sort();

    /// Runs a round that has the [priority] and an indicator of whether this round is the last round.
    void addCentsToEnvelope({required String envelopeId, required int cents}) {
      final currentCentsGained = modifiedCentsByEnvelopeId[envelopeId] ?? 0;
      final totalCentsGained = currentCentsGained + cents;
      modifiedCentsByEnvelopeId[envelopeId] = totalCentsGained;
    }

    /// If [isExtraIncome], then all envelopes have gotten their satisfied amounts and this round is for collecting extra income.
    void runRound({required Map<String, Envelope> envelopeById, bool isExtraIncome = false}) {
      final envelopeRequestedCentsAmountById = envelopeById.map((id, envelope) => MapEntry(
          id,
          envelope.ruleProperty.value?.requestIncome(
                context: context,
                envelope: envelope,
                incomeCents: remainingCents,
                isExtraIncome: isExtraIncome,
              ) ??
              0));

      /// Returns a map of an envelope id to the amount of cents it gained based on the [totalRequestedCents] of all
      /// other envelopes in the same round.
      Map<String, int> getEnvelopeCentsGainedById({required int totalRequestedCents}) {
        final shouldCollectRequestedAmount = totalRequestedCents <= remainingCents && !isExtraIncome;
        if (shouldCollectRequestedAmount) {
          return envelopeRequestedCentsAmountById;
        } else if (totalRequestedCents == 0) {
          // If no cents were requested, each envelope gained nothing.
          return envelopeById.map((id, envelope) => MapEntry(id, 0));
        } else {
          // Divide the income evenly among the rules based on their requested amount.
          return envelopeRequestedCentsAmountById.map((key, requestedCents) =>
              MapEntry(key, ((requestedCents / totalRequestedCents) * remainingCents).floor()));
        }
      }

      final envelopeCentsGainedById =
          getEnvelopeCentsGainedById(totalRequestedCents: envelopeRequestedCentsAmountById.values.sum);

      final totalGainedCents = envelopeCentsGainedById.values.sum;
      remainingCents -= totalGainedCents;

      envelopeCentsGainedById.forEach((id, cents) {
        /// Do not modify the cents of an envelope that just gained 0 cents.
        if (cents == 0) {
          return;
        }

        addCentsToEnvelope(envelopeId: id, cents: cents);
      });
    }

    for (final priority in envelopePriorities) {
      runRound(envelopeById: envelopesMapByPriority[priority]!);
    }

    final lastPriority = envelopePriorities.last;
    final lastRoundEnvelopeById = envelopeById.entries
        .where((entry) => entry.value.ruleProperty.value!.priority == lastPriority)
        .mapToMap((id, envelope) => MapEntry(
            id,
            envelope.withIncomeAdded(
              context: context,
              incomeCents: modifiedCentsByEnvelopeId[id]?.floor() ?? 0,
            )));
    if (remainingCents > 0 && envelopePriorities.isNotEmpty) {
      runRound(envelopeById: lastRoundEnvelopeById, isExtraIncome: true);
    }

    final hasDiscardedCents = remainingCents != 0;
    if (hasDiscardedCents) {
      final firstEnvelopeId = lastRoundEnvelopeById.keys.first;
      addCentsToEnvelope(envelopeId: firstEnvelopeId, cents: remainingCents);
    }

    return BudgetChange(modifiedCentsByEnvelopeId: modifiedCentsByEnvelopeId, isIncome: true);
  }

  BudgetChange addTransactions({
    required Map<String, Envelope> envelopeById,
    required List<BudgetTransaction> transactions,
  }) {
    var modifiedCentsByEnvelopeId =
        envelopeById.map((id, envelope) => MapEntry(id, envelope.amountCentsProperty.value));

    for (final transaction in transactions) {
      final budgetChange = transaction.getBudgetChange(centsByEnvelopeId: modifiedCentsByEnvelopeId);
      modifiedCentsByEnvelopeId = budgetChange.modifiedCentsByEnvelopeId;
    }

    return BudgetChange(modifiedCentsByEnvelopeId: modifiedCentsByEnvelopeId, isIncome: false);
  }
}
