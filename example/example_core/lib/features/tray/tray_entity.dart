import 'package:example_core/features/envelope/envelope.dart';
import 'package:example_core/features/envelope/envelope_entity.dart';
import 'package:example_core/features/tray/tray.dart';
import 'package:jlogical_utils_core/jlogical_utils_core.dart';

class TrayEntity extends Entity<Tray> {
  static Query<TrayEntity> getBudgetTraysQuery({required String budgetId}) {
    return Query.from<TrayEntity>().where(Tray.budgetField).isEqualTo(budgetId);
  }

  @override
  Future onBeforeDelete(CoreDropContext context) async {
    final envelopeEntities =
        await EnvelopeEntity.getBudgetEnvelopesQuery(budgetId: value.budgetProperty.value, isArchived: null)
            .where(Envelope.trayField)
            .isEqualTo(id)
            .all()
            .get(context);

    await Future.wait(envelopeEntities.map((entity) => context.updateEntity(
          entity,
          (Envelope envelope) => envelope.trayProperty.set(null),
        )));
  }
}
