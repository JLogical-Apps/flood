import 'dart:async';

import 'package:asset_core/src/asset.dart';
import 'package:asset_core/src/asset_path_context.dart';
import 'package:asset_core/src/asset_providers/security/field/entity_asset_permission_builder.dart';
import 'package:drop_core/drop_core.dart';

abstract class AssetPermissionField {
  static AssetPermissionField value(dynamic value) => ValueAssetPermissionField(value: value);

  static AssetPermissionField get loggedInUserId => LoggedInUserIdAssetPermissionField();

  static AssetPermissionField pathMetadata(String field) => PathMetadataAssetPermissionField(pathMetadataField: field);

  static AssetPermissionField get entityId => pathMetadata(State.idField);

  static AssetPermissionEntityBuilder<E> entity<E extends Entity>(AssetPermissionField field, {Type? entityType}) {
    return AssetPermissionEntityBuilder<E>(permissionField: field, entityType: entityType);
  }

  FutureOr<bool> isValidValue(AssetPathContext context);

  FutureOr<dynamic> extractValue(AssetPathContext context);

  FutureOr<dynamic> extractAssetValue(AssetPathContext context, {required Asset asset});
}

mixin IsAssetPermissionField implements AssetPermissionField {
  @override
  Future<dynamic> extractAssetValue(AssetPathContext context, {required Asset asset}) async {
    return await extractValue(context);
  }
}

class ValueAssetPermissionField with IsAssetPermissionField {
  final dynamic value;

  ValueAssetPermissionField({required this.value});

  @override
  bool isValidValue(AssetPathContext context) {
    return true;
  }

  @override
  extractValue(AssetPathContext context) {
    return value;
  }
}

class LoggedInUserIdAssetPermissionField with IsAssetPermissionField {
  @override
  FutureOr<bool> isValidValue(AssetPathContext context) {
    return true;
  }

  @override
  extractValue(AssetPathContext context) {
    return context.context.getLoggedInAccount()?.accountId;
  }
}

class PathMetadataAssetPermissionField with IsAssetPermissionField {
  final String pathMetadataField;

  PathMetadataAssetPermissionField({required this.pathMetadataField});

  @override
  FutureOr<bool> isValidValue(AssetPathContext context) {
    return true;
  }

  @override
  extractValue(AssetPathContext context) {
    return context.values[pathMetadataField];
  }
}
