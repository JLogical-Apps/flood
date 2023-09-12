import 'dart:async';

import 'package:collection/collection.dart';
import 'package:example_core/features/envelope/envelope.dart';
import 'package:example_core/features/tray/tray_entity.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class EnvelopeEditDialog extends StyledPortDialog<Envelope> {
  EnvelopeEditDialog._({super.titleText, required super.port, super.children, super.onAccept});

  static Future<EnvelopeEditDialog> create({
    required CorePondContext corePondContext,
    String? titleText,
    required Envelope envelope,
    FutureOr Function(Envelope result)? onAccept,
  }) async {
    final trayEntities = await TrayEntity.getBudgetTraysQuery(budgetId: envelope.budgetProperty.value)
        .all()
        .get(corePondContext.dropCoreComponent);

    final port = envelope.asPort(
      corePondContext,
      overrides: [
        PortGeneratorOverride.override(
          Envelope.trayField,
          portField: PortField.option<TrayEntity?, String?>(
            initialValue: envelope.trayProperty.value
                ?.mapIfNonNull((trayId) => trayEntities.firstWhereOrNull((trayEntity) => trayEntity.id == trayId)),
            options: [
              null,
              ...trayEntities,
            ],
            submitMapper: (trayEntity) => trayEntity?.id,
          ),
        ),
      ],
    );
    return EnvelopeEditDialog._(
      titleText: titleText,
      port: port,
      children: [
        StyledObjectPortBuilder(port: port),
      ],
      onAccept: onAccept,
    );
  }
}
