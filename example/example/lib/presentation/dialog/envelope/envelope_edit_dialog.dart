import 'dart:async';

import 'package:collection/collection.dart';
import 'package:example_core/features/envelope/envelope.dart';
import 'package:example_core/features/tray/tray_entity.dart';
import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class EnvelopeEditDialog {
  static Future<void> show(
    BuildContext context, {
    String? titleText,
    required Envelope envelope,
    FutureOr Function(Envelope result)? onAccept,
  }) async {
    final trayEntities = await TrayEntity.getBudgetTraysQuery(budgetId: envelope.budgetProperty.value)
        .all()
        .get(context.dropCoreComponent);

    final port = envelope.asPort(
      context.corePondContext,
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

    await context.showStyledDialog(StyledPortDialog(
      port: port,
      onAccept: onAccept,
      titleText: titleText,
    ));
  }
}
