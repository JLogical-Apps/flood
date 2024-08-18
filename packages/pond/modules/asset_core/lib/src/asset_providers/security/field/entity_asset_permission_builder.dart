import 'dart:async';

import 'package:asset_core/src/asset_path_context.dart';
import 'package:asset_core/src/asset_providers/security/asset_permission.dart';
import 'package:asset_core/src/asset_providers/security/field/asset_permission_field.dart';
import 'package:drop_core/drop_core.dart';
import 'package:utils_core/utils_core.dart';

class AssetPermissionEntityBuilder<E extends Entity> {
  final AssetPermissionField permissionField;
  final Type entityType;

  AssetPermissionEntityBuilder({required this.permissionField, Type? entityType}) : entityType = entityType ?? E;

  AssetPermissionField propertyName(String propertyName) {
    return EntityPropertyAssetPermissionField(
      permissionField: permissionField,
      propertyName: propertyName,
      entityType: entityType,
    );
  }
}

class EntityPropertyAssetPermissionField with IsAssetPermissionField {
  final AssetPermissionField permissionField;
  final String propertyName;
  final Type entityType;

  EntityPropertyAssetPermissionField({
    required this.permissionField,
    required this.propertyName,
    required this.entityType,
  });

  @override
  bool dependsOnRootEntity() {
    return permissionField == AssetPermissionField.entityId || permissionField.dependsOnRootEntity();
  }

  @override
  Future<Entity?> getRootEntity(AssetPathContext context) async {
    if (permissionField == AssetPermissionField.entityId) {
      final entityId = context.entityId;
      if (entityId == null) {
        return null;
      }
      return await guardAsync<Entity?>(
        () => Query.getByIdOrNullRuntime(entityType, entityId).get(context.dropCoreComponent),
        onException: (e, stack) => print('$e\n$stack'),
      );
    } else {
      return await permissionField.getRootEntity(context);
    }
  }

  @override
  Type getRootEntityType() {
    if (permissionField == AssetPermissionField.entityId) {
      return entityType;
    } else {
      return permissionField.getRootEntityType();
    }
  }

  @override
  Future<dynamic> extractValue(AssetPathContext context, {required AssetPermissionContext permissionContext}) async {
    final id = await permissionField.extractValue(context, permissionContext: permissionContext);
    if (id == null) {
      return null;
    }

    final entity = await Query.getByIdOrNullRuntime(entityType, id).get(context.dropCoreComponent);
    if (entity == null) {
      return null;
    }

    final entityState = entity.getState(context.dropCoreComponent);
    return entityState[propertyName];
  }

  @override
  Future<bool> isValidValue(AssetPathContext context, {required AssetPermissionContext permissionContext}) async {
    final id = await permissionField.extractValue(context, permissionContext: permissionContext);
    if (id == null) {
      return false;
    }

    return await getRootEntity(context) != null;
  }
}
