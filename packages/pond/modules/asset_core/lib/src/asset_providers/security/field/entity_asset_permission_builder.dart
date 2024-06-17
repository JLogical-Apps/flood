import 'package:asset_core/src/asset_path_context.dart';
import 'package:asset_core/src/asset_providers/security/field/asset_permission_field.dart';
import 'package:drop_core/drop_core.dart';

class AssetPermissionEntityBuilder<E extends Entity> {
  final AssetPermissionField permissionField;
  final Type entityType;

  AssetPermissionEntityBuilder({required this.permissionField, Type? entityType}) : entityType = entityType ?? E;

  AssetPermissionField propertyName(String propertyName) {
    return EntityPropertyPermissionField(
      permissionField: permissionField,
      propertyName: propertyName,
      entityType: entityType,
    );
  }
}

class EntityPropertyPermissionField with IsAssetPermissionField {
  final AssetPermissionField permissionField;
  final String propertyName;
  final Type entityType;

  EntityPropertyPermissionField({
    required this.permissionField,
    required this.propertyName,
    required this.entityType,
  });

  @override
  Future<dynamic> extractValue(AssetPathContext context) async {
    final id = await permissionField.extractValue(context);
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
  Future<bool> isValidValue(AssetPathContext context) async {
    final id = await permissionField.extractValue(context);
    if (id == null) {
      return false;
    }

    final entity = await Query.getByIdOrNullRuntime(entityType, id).get(context.dropCoreComponent);
    return entity != null;
  }
}
