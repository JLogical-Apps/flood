import 'dart:async';

import 'package:asset_core/asset_core.dart';
import 'package:drop_core/drop_core.dart';

abstract class AssetPermissionField {
  static AssetPermissionField value(dynamic value) => ValueAssetPermissionField(value: value);

  static AssetPermissionField loggedInUserId = LoggedInUserIdAssetPermissionField();

  static AssetPermissionField pathMetadata(String field) => PathMetadataAssetPermissionField(pathMetadataField: field);

  static AssetPermissionField entityId = pathMetadata(State.idField);

  static AssetPermissionEntityBuilder<E> entity<E extends Entity>(AssetPermissionField field, {Type? entityType}) {
    return AssetPermissionEntityBuilder<E>(permissionField: field, entityType: entityType);
  }

  FutureOr<bool> isValidValue(AssetPathContext context, {required AssetPermissionContext permissionContext});

  bool dependsOnRootEntity();

  Future<Entity?> getRootEntity(AssetPathContext context);

  Type getRootEntityType();

  FutureOr<dynamic> extractValue(AssetPathContext context, {required AssetPermissionContext permissionContext});

  FutureOr<dynamic> extractAssetValue(
    AssetPathContext context, {
    required Asset asset,
    required AssetPermissionContext permissionContext,
  });
}

mixin IsAssetPermissionField implements AssetPermissionField {
  @override
  Future<dynamic> extractAssetValue(
    AssetPathContext context, {
    required Asset asset,
    required AssetPermissionContext permissionContext,
  }) async {
    return await extractValue(context, permissionContext: permissionContext);
  }

  @override
  bool dependsOnRootEntity() {
    return false;
  }

  @override
  Future<Entity<ValueObject>?> getRootEntity(AssetPathContext context) async {
    return null;
  }

  @override
  Type getRootEntityType() {
    throw UnimplementedError();
  }
}

class ValueAssetPermissionField with IsAssetPermissionField {
  final dynamic value;

  ValueAssetPermissionField({required this.value});

  @override
  bool isValidValue(AssetPathContext context, {required AssetPermissionContext permissionContext}) {
    return true;
  }

  @override
  extractValue(AssetPathContext context, {required AssetPermissionContext permissionContext}) {
    return value;
  }
}

class LoggedInUserIdAssetPermissionField with IsAssetPermissionField {
  @override
  FutureOr<bool> isValidValue(AssetPathContext context, {required AssetPermissionContext permissionContext}) {
    return true;
  }

  @override
  extractValue(AssetPathContext context, {required AssetPermissionContext permissionContext}) {
    return context.context.getLoggedInAccount()?.accountId;
  }
}

class PathMetadataAssetPermissionField with IsAssetPermissionField {
  final String pathMetadataField;

  PathMetadataAssetPermissionField({required this.pathMetadataField});

  @override
  FutureOr<bool> isValidValue(AssetPathContext context, {required AssetPermissionContext permissionContext}) {
    return true;
  }

  @override
  extractValue(AssetPathContext context, {required AssetPermissionContext permissionContext}) {
    return context.values[pathMetadataField];
  }
}
