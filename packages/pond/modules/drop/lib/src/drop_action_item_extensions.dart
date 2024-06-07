import 'dart:async';

import 'package:drop/drop.dart';
import 'package:flutter/material.dart';
import 'package:pond/pond.dart';
import 'package:port_drop_core/port_drop_core.dart';
import 'package:port_style/port_style.dart';
import 'package:runtime_type/type.dart';
import 'package:style/style.dart';
import 'package:utils/utils.dart';

extension DropActionItemExtensions on ActionItemStatic {
  ActionItem editValueObject<V extends ValueObject>(
    BuildContext context, {
    required V valueObject,
    required FutureOr Function(V result) onAccept,
    String? contentTypeName,
    String? title,
    String? description,
    List<String>? only,
  }) {
    contentTypeName ??= context.dropCoreComponent.getRuntimeTypeRuntime(valueObject.runtimeType).name.titleCase;

    return ActionItem.static.edit(
      contentTypeName: contentTypeName,
      title: title,
      description: description,
      onPerform: (_) async {
        await context.showStyledDialog(StyledPortDialog(
          titleText: 'Edit $contentTypeName',
          port: valueObject.asPort(context.corePondContext, only: only),
          onAccept: onAccept,
        ));
      },
    );
  }

  ActionItem duplicateValueObject<V extends ValueObject>(
    BuildContext context, {
    required V valueObject,
    required FutureOr Function(V result) onAccept,
    V Function(V object)? duplicator,
    String? contentTypeName,
    String? title,
    String? description,
    List<String>? only,
  }) {
    contentTypeName ??= context.dropCoreComponent.getRuntimeTypeRuntime(valueObject.runtimeType).name.titleCase;

    return ActionItem.static.duplicate(
      contentTypeName: contentTypeName,
      title: title,
      description: description,
      onPerform: (_) async {
        final newInstance =
            context.dropCoreComponent.getRuntimeTypeRuntime(valueObject.runtimeType).createInstance() as V;
        newInstance.duplicateFrom(context.dropCoreComponent, valueObject);
        await context.showStyledDialog(StyledPortDialog(
          titleText: 'Duplicate $contentTypeName',
          port: (duplicator?.call(newInstance) ?? newInstance).asPort(context.corePondContext, only: only),
          onAccept: onAccept,
        ));
      },
    );
  }

  ActionItem deleteValueObject<V extends ValueObject>(
    BuildContext context, {
    required V valueObject,
    required FutureOr Function() onAccept,
    String? contentTypeName,
    String? title,
    String? description,
  }) {
    contentTypeName ??= context.dropCoreComponent.getRuntimeTypeRuntime(valueObject.runtimeType).name.titleCase;

    return ActionItem.static.delete(
      contentTypeName: contentTypeName,
      title: title,
      description: description,
      onPerform: (_) async {
        await context.showStyledDialog(StyledDialog.yesNo(
          titleText: 'Confirm Delete $contentTypeName',
          bodyText: 'Are you sure you want to delete this $contentTypeName? You cannot undo this.',
          onAccept: onAccept,
        ));
      },
    );
  }

  ActionItem editEntity<E extends Entity<V>, V extends ValueObject>(
    BuildContext context, {
    required E entity,
    String? contentTypeName,
    String? title,
    String? description,
    List<String>? only,
  }) {
    return editValueObject(
      context,
      valueObject: entity.value,
      contentTypeName: contentTypeName,
      only: only,
      title: title,
      description: description,
      onAccept: (V result) async {
        await context.dropCoreComponent.updateEntity(entity..set(result));
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
    return duplicateValueObject(
      context,
      contentTypeName: contentTypeName,
      valueObject: entity.value,
      duplicator: duplicator,
      only: only,
      title: title,
      description: description,
      onAccept: (V result) async {
        final newEntity = context.dropCoreComponent.getRuntimeTypeRuntime(entity.runtimeType).createInstance() as E;
        await context.dropCoreComponent.updateEntity(newEntity..set(result));
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
    return deleteValueObject(
      context,
      contentTypeName: contentTypeName,
      valueObject: entity.value,
      title: title,
      description: description,
      onAccept: () async {
        await context.dropCoreComponent.delete(entity);
      },
    );
  }

  List<ActionItem> valueObjectCrudActions<V extends ValueObject>(
    BuildContext context, {
    required V valueObject,
    required FutureOr Function(V result)? onEdit,
    required FutureOr Function(V result)? onDuplicate,
    required FutureOr Function()? onDelete,
    V Function(V value)? duplicator,
    String? contentTypeName,
    List<String>? only,
  }) {
    return [
      if (onEdit != null)
        editValueObject(
          context,
          valueObject: valueObject,
          onAccept: onEdit,
          contentTypeName: contentTypeName,
          only: only,
        ),
      if (onDuplicate != null)
        duplicateValueObject(
          context,
          valueObject: valueObject,
          onAccept: onDuplicate,
          contentTypeName: contentTypeName,
          duplicator: duplicator,
          only: only,
        ),
      if (onDelete != null)
        deleteValueObject(
          context,
          valueObject: valueObject,
          contentTypeName: contentTypeName,
          onAccept: onDelete,
        ),
    ];
  }

  List<ActionItem> entityCrudActions<E extends Entity<V>, V extends ValueObject>(
    BuildContext context, {
    required E entity,
    String? contentTypeName,
    V Function(V value)? duplicator,
    List<String>? only,
  }) {
    return [
      editEntity(context, entity: entity, contentTypeName: contentTypeName, only: only),
      duplicateEntity(context, entity: entity, contentTypeName: contentTypeName, duplicator: duplicator, only: only),
      deleteEntity(context, entity: entity, contentTypeName: contentTypeName),
    ];
  }
}
