import 'package:drop/drop.dart';
import 'package:drop_core/drop_core.dart';
import 'package:flutter/material.dart';
import 'package:pond/pond.dart';
import 'package:port_drop_core/port_drop_core.dart';
import 'package:port_style/port_style.dart';
import 'package:runtime_type/type.dart';
import 'package:style/style.dart';
import 'package:utils/utils.dart';

extension DropActionItemExtensions on ActionItemStatic {
  ActionItem editEntity<E extends Entity<V>, V extends ValueObject>(
    BuildContext context, {
    required E entity,
    String? contentTypeName,
    String? title,
    String? description,
    List<String>? only,
  }) {
    contentTypeName ??= context.dropCoreComponent.getRuntimeTypeRuntime(entity.value.runtimeType).name.titleCase;

    return ActionItem.static.edit(
      contentTypeName: contentTypeName,
      title: title,
      description: description,
      onPerform: (_) async {
        await context.showStyledDialog(StyledPortDialog(
          titleText: 'Edit $contentTypeName',
          port: entity.value.asPort(context.corePondContext, only: only),
          onAccept: (V result) async {
            await context.dropCoreComponent.updateEntity(entity..set(result));
          },
        ));
      },
    );
  }

  ActionItem duplicateEntity<E extends Entity<V>, V extends ValueObject>(
    BuildContext context, {
    required E entity,
    V Function(V valueObject)? duplicator,
    String? contentTypeName,
    String? title,
    String? description,
    List<String>? only,
  }) {
    contentTypeName ??= context.dropCoreComponent.getRuntimeTypeRuntime(entity.value.runtimeType).name.titleCase;

    return ActionItem.static.duplicate(
      contentTypeName: contentTypeName,
      title: title,
      description: description,
      onPerform: (_) async {
        final newInstance =
            context.dropCoreComponent.getRuntimeTypeRuntime(entity.value.runtimeType).createInstance() as V;
        newInstance.copyFrom(context.dropCoreComponent, entity.value);

        await context.showStyledDialog(StyledPortDialog(
          titleText: 'Duplicate $contentTypeName',
          port: (duplicator?.call(newInstance) ?? newInstance).asPort(context.corePondContext, only: only),
          onAccept: (V result) async {
            final newEntity = context.dropCoreComponent.getRuntimeType<E>().createInstance();
            await context.dropCoreComponent.updateEntity(newEntity..set(result));
          },
        ));
      },
    );
  }

  ActionItem deleteEntity<E extends Entity<V>, V extends ValueObject>(
    BuildContext context, {
    required E entity,
    String? contentTypeName,
    String? title,
    String? description,
  }) {
    contentTypeName ??= context.dropCoreComponent.getRuntimeTypeRuntime(entity.value.runtimeType).name.titleCase;

    return ActionItem.static.delete(
      contentTypeName: contentTypeName,
      title: title,
      description: description,
      onPerform: (_) async {
        await context.showStyledDialog(StyledDialog.yesNo(
          titleText: 'Confirm Delete $contentTypeName',
          bodyText: 'Are you sure you want to delete this $contentTypeName? You cannot undo this.',
          onAccept: () async {
            await context.dropCoreComponent.delete(entity);
          },
        ));
      },
    );
  }

  List<ActionItem> entityCrudActions<E extends Entity<V>, V extends ValueObject>(
    BuildContext context, {
    required E entity,
    String? contentTypeName,
    V Function(V value)? duplicator,
  }) {
    return [
      editEntity(context, entity: entity, contentTypeName: contentTypeName),
      duplicateEntity(context, entity: entity, contentTypeName: contentTypeName, duplicator: duplicator),
      deleteEntity(context, entity: entity, contentTypeName: contentTypeName),
    ];
  }
}
