import 'dart:async';

import 'package:example/features/envelope/envelope.dart';
import 'package:jlogical_utils_core/jlogical_utils_core.dart';

class EnvelopeEntity extends Entity<Envelope> {
  static Query<EnvelopeEntity> getBudgetEnvelopesQuery({required String budgetId, required bool? isArchived}) {
    var query = Query.from<EnvelopeEntity>().where(Envelope.budgetField).isEqualTo(budgetId);
    if (isArchived != null) {
      query = query.where(Envelope.archivedField).isEqualTo(isArchived);
    }
    return query;
  }

  @override
  FutureOr onAfterInitalize(CoreDropContext context) async {
    await value.onInitialize(context);
  }
}
