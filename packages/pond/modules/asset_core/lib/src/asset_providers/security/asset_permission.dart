import 'dart:async';

import 'package:asset_core/src/asset.dart';
import 'package:asset_core/src/asset_path_context.dart';
import 'package:asset_core/src/asset_providers/security/field/asset_permission_field.dart';

abstract class AssetPermission {
  static AssetPermission get all => AllAssetPermission();

  static AssetPermission get none => NoneAssetPermission();

  static AssetPermission get authenticated => AuthenticatedAssetPermission();

  static AssetPermission get admin => AdminAssetPermission();

  static AssetPermission equals(AssetPermissionField field1, AssetPermissionField field2) =>
      EqualsAssetPermission(field1: field1, field2: field2);

  static AssetPermission and(List<AssetPermission> permissions) => AndAssetPermission(permissions: permissions);

  static AssetPermission or(List<AssetPermission> permissions) => OrAssetPermission(permissions: permissions);

  FutureOr<bool> passes(AssetPathContext context, {required AssetPermissionContext permissionContext});

  FutureOr<bool> passesWrite(
    AssetPathContext context, {
    required Asset asset,
    required AssetPermissionContext permissionContext,
  });

  operator &(AssetPermission other);

  operator |(AssetPermission other);
}

mixin IsAssetPermission implements AssetPermission {
  @override
  operator &(AssetPermission other) {
    return AndAssetPermission(permissions: [this, other]);
  }

  @override
  operator |(AssetPermission other) {
    return OrAssetPermission(permissions: [this, other]);
  }

  @override
  Future<bool> passesWrite(
    AssetPathContext context, {
    required Asset asset,
    required AssetPermissionContext permissionContext,
  }) async {
    return await passes(context, permissionContext: permissionContext);
  }
}

class AllAssetPermission with IsAssetPermission {
  @override
  bool passes(AssetPathContext context, {required AssetPermissionContext permissionContext}) {
    return true;
  }
}

class NoneAssetPermission with IsAssetPermission {
  @override
  bool passes(AssetPathContext context, {required AssetPermissionContext permissionContext}) {
    return false;
  }
}

class AuthenticatedAssetPermission with IsAssetPermission {
  @override
  bool passes(AssetPathContext context, {required AssetPermissionContext permissionContext}) {
    return context.context.getLoggedInAccount() != null;
  }
}

class AdminAssetPermission with IsAssetPermission {
  @override
  bool passes(AssetPathContext context, {required AssetPermissionContext permissionContext}) {
    final loggedInAccount = context.context.getLoggedInAccount();
    if (loggedInAccount == null) {
      return false;
    }

    return loggedInAccount.isAdmin;
  }
}

class EqualsAssetPermission with IsAssetPermission {
  final AssetPermissionField field1;
  final AssetPermissionField field2;

  EqualsAssetPermission({required this.field1, required this.field2});

  @override
  Future<bool> passes(AssetPathContext context, {required AssetPermissionContext permissionContext}) async {
    // If creating an asset and the root entity does not exist, allow creating if the user is logged in.
    if (permissionContext == AssetPermissionContext.create) {
      for (final field in [field1, field2]) {
        if (field.dependsOnRootEntity() && await field.getRootEntity(context) == null) {
          return context.context.getLoggedInAccount()?.accountId != null;
        }
      }
    }

    if (!await field1.isValidValue(context, permissionContext: permissionContext) ||
        !await field2.isValidValue(context, permissionContext: permissionContext)) {
      return false;
    }

    return await field1.extractValue(context, permissionContext: permissionContext) ==
        await field2.extractValue(context, permissionContext: permissionContext);
  }

  @override
  Future<bool> passesWrite(
    AssetPathContext context, {
    required Asset asset,
    required AssetPermissionContext permissionContext,
  }) async {
    // If creating an asset and the root entity does not exist, allow creating if the user is logged in.
    if (permissionContext == AssetPermissionContext.create) {
      for (final field in [field1, field2]) {
        if (field.dependsOnRootEntity() && await field.getRootEntity(context) == null) {
          return context.context.getLoggedInAccount()?.accountId != null;
        }
      }
    }

    if (!await field1.isValidValue(context, permissionContext: permissionContext) ||
        !await field2.isValidValue(context, permissionContext: permissionContext)) {
      return false;
    }

    return await field1.extractAssetValue(context, asset: asset, permissionContext: permissionContext) ==
        await field2.extractAssetValue(context, asset: asset, permissionContext: permissionContext);
  }
}

class AndAssetPermission with IsAssetPermission {
  final List<AssetPermission> permissions;

  AndAssetPermission({required this.permissions});

  @override
  Future<bool> passes(
    AssetPathContext context, {
    required AssetPermissionContext permissionContext,
  }) async {
    for (final permission in permissions) {
      if (!await permission.passes(context, permissionContext: permissionContext)) {
        return false;
      }
    }

    return true;
  }

  @override
  Future<bool> passesWrite(
    AssetPathContext context, {
    required Asset asset,
    required AssetPermissionContext permissionContext,
  }) async {
    for (final permission in permissions) {
      if (!await permission.passesWrite(context, asset: asset, permissionContext: permissionContext)) {
        return false;
      }
    }

    return true;
  }
}

class OrAssetPermission with IsAssetPermission {
  final List<AssetPermission> permissions;

  OrAssetPermission({required this.permissions});

  @override
  Future<bool> passes(AssetPathContext context, {required AssetPermissionContext permissionContext}) async {
    for (final permission in permissions) {
      if (await permission.passes(context, permissionContext: permissionContext)) {
        return true;
      }
    }

    return false;
  }

  @override
  Future<bool> passesWrite(
    AssetPathContext context, {
    required Asset asset,
    required AssetPermissionContext permissionContext,
  }) async {
    for (final permission in permissions) {
      if (await permission.passesWrite(context, asset: asset, permissionContext: permissionContext)) {
        return true;
      }
    }

    return false;
  }
}

enum AssetPermissionContext {
  read,
  create,
  update,
  delete;
}
