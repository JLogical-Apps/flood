import 'dart:async';

import 'package:example_core/features/envelope/envelope.dart';
import 'package:jlogical_utils_core/jlogical_utils_core.dart';

class EnvelopeEntity extends Entity<Envelope> {
  static Query<EnvelopeEntity> getBudgetEnvelopesQuery({required String budgetId, required bool? isArchived}) {
    Query<EnvelopeEntity> query = Query.from<EnvelopeEntity>()
        .where(Envelope.budgetField)
        .isEqualTo(budgetId)
        .orderByAscending(Envelope.nameField);
    if (isArchived != null) {
      query = query.where(Envelope.archivedField).isEqualTo(isArchived);
    }
    return query;
  }

  static Query<EnvelopeEntity> getTrayEnvelopesQuery({required String trayId}) {
    return Query.from<EnvelopeEntity>()
        .where(Envelope.trayField)
        .isEqualTo(trayId)
        .orderByAscending(Envelope.nameField);
  }

  @override
  FutureOr onAfterInitalize(DropCoreContext context) async {
    await value.onInitialize(context);
  }
}
