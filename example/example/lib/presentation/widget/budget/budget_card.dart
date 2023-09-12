import 'dart:async';

import 'package:example/presentation/style.dart';
import 'package:example_core/features/budget/budget_entity.dart';
import 'package:example_core/features/envelope/envelope_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class BudgetEntityCard extends HookWidget {
  final String budgetId;

  final FutureOr Function()? onPressed;

  const BudgetEntityCard({super.key, required this.budgetId, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final budgetModel = useEntityOrNull<BudgetEntity>(budgetId);
    final envelopesModel =
        useQuery(EnvelopeEntity.getBudgetEnvelopesQuery(budgetId: budgetId, isArchived: false).all());

    return ModelBuilder(
        model: Model.union([budgetModel, envelopesModel]),
        builder: (List results) {
          final [BudgetEntity? budgetEntity, List<EnvelopeEntity> envelopeEntities] = results;

          final cents = envelopeEntities.sumByInt((envelopeEntity) => envelopeEntity.value.amountCentsProperty.value);

          return StyledCard(
            titleText: budgetEntity?.value.nameProperty.value ?? 'N/A',
            body: StyledText.body.withColor(getCentsColor(cents))(cents.formatCentsAsCurrency()),
            onPressed: onPressed,
          );
        });
  }
}
