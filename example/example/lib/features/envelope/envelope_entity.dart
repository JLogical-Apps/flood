import 'package:example/features/envelope/envelope.dart';
import 'package:jlogical_utils_core/jlogical_utils_core.dart';

class EnvelopeEntity extends Entity<Envelope> {
  static Query<EnvelopeEntity> getBudgetEnvelopesQuery({required String budgetId, required bool? isArchived}) {
    return Query.from<EnvelopeEntity>().where(Envelope.budgetField).isEqualTo(budgetId);
  }
}
