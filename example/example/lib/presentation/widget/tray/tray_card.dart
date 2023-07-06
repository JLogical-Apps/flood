import 'dart:async';

import 'package:example/features/envelope/envelope.dart';
import 'package:example/features/envelope/envelope_entity.dart';
import 'package:example/features/tray/tray.dart';
import 'package:example/features/tray/tray_entity.dart';
import 'package:example/presentation/widget/envelope/envelope_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class TrayCard extends HookWidget {
  final TrayEntity trayEntity;

  final FutureOr Function()? onPressed;
  final FutureOr Function(EnvelopeEntity envelopeEntity)? onEnvelopePressed;

  const TrayCard({super.key, required this.trayEntity, this.onPressed, this.onEnvelopePressed});

  @override
  Widget build(BuildContext context) {
    final tray = trayEntity.value;

    final envelopesModel = useQuery(
        EnvelopeEntity.getBudgetEnvelopesQuery(budgetId: tray.budgetProperty.value, isArchived: false)
            .where(Envelope.trayField)
            .isEqualTo(trayEntity.id!)
            .all());
    final envelopeEntities = envelopesModel.getOrNull();

    return StyledCard.subtle(
      title: StyledText.h6.withColor(Color(tray.colorProperty.value))(tray.nameProperty.value),
      onPressed: onPressed,
      actions: [
        ActionItem(
          titleText: 'Edit',
          descriptionText: 'Edit this tray.',
          iconData: Icons.edit,
          color: Colors.orange,
          onPerform: (context) async {
            await context.showStyledDialog(StyledPortDialog(
              port: tray.asPort(context.corePondContext),
              titleText: 'Edit Tray',
              onAccept: (Tray tray) async {
                await context.coreDropComponent.updateEntity(trayEntity..set(tray));
              },
            ));
          },
        ),
        ActionItem(
            titleText: 'Delete',
            descriptionText: 'Delete this tray.',
            iconData: Icons.delete,
            color: Colors.red,
            onPerform: (context) async {
              await context.showStyledDialog(StyledDialog.yesNo(
                titleText: 'Confirm Delete',
                bodyText: 'Are you sure you want to delete this tray? You cannot undo this.',
                onAccept: () async {
                  await context.coreDropComponent.delete(trayEntity);
                },
              ));
            }),
      ],
      children: [
        if (envelopeEntities != null && envelopeEntities.isNotEmpty)
          ModelBuilder(
            model: envelopesModel,
            builder: (List<EnvelopeEntity> envelopeEntities) {
              return StyledList.column(
                children: envelopeEntities
                    .map((envelopeEntity) => EnvelopeCard(
                          envelope: envelopeEntity.value,
                          onPressed: onEnvelopePressed == null ? null : () => onEnvelopePressed!(envelopeEntity),
                        ))
                    .toList(),
              );
            },
          ),
      ],
    );
  }
}
