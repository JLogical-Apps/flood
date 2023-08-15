import 'dart:async';

import 'package:drop_core/src/context/drop_core_context.dart';
import 'package:drop_core/src/query/query.dart';
import 'package:drop_core/src/query/request/query_request.dart';
import 'package:drop_core/src/state/state_change.dart';

abstract class Permission {
  static Permission get all => AllPermission();

  static Permission get none => NonePermission();

  static Permission get authenticated => AuthenticatedPermission();

  static Permission isAdmin({required Type userEntityType, required String adminField}) => AdminPermission(
        userEntityType: userEntityType,
        adminField: adminField,
      );

  static Permission unmodifiable(String field) => UnmodifiablePermission(field: field);

  static Permission and(List<Permission> permissions) => AndPermission(permissions: permissions);

  FutureOr<bool> passes(
    DropCoreContext context, {
    required String? authenticatedUserId,
    required StateChange? stateChange,
  });

  operator &(Permission other);
}

mixin IsPermission implements Permission {
  @override
  operator &(Permission other) {
    return AndPermission(permissions: [this, other]);
  }
}

class AllPermission with IsPermission {
  @override
  bool passes(
    DropCoreContext context, {
    required String? authenticatedUserId,
    required StateChange? stateChange,
  }) {
    return true;
  }
}

class NonePermission with IsPermission {
  @override
  bool passes(
    DropCoreContext context, {
    required String? authenticatedUserId,
    required StateChange? stateChange,
  }) {
    return false;
  }
}

class AuthenticatedPermission with IsPermission {
  @override
  bool passes(
    DropCoreContext context, {
    required String? authenticatedUserId,
    required StateChange? stateChange,
  }) {
    return authenticatedUserId != null;
  }
}

class AdminPermission with IsPermission {
  final Type userEntityType;
  final String adminField;

  AdminPermission({required this.userEntityType, required this.adminField});

  @override
  Future<bool> passes(
    DropCoreContext context, {
    required String? authenticatedUserId,
    required StateChange? stateChange,
  }) async {
    if (authenticatedUserId == null) {
      return false;
    }

    final userEntity = await Query.getByIdOrNullRuntime(userEntityType, authenticatedUserId).get(context);
    if (userEntity == null) {
      return false;
    }

    return userEntity.getState(context).data[adminField] == true;
  }
}

class UnmodifiablePermission with IsPermission {
  final String field;

  UnmodifiablePermission({required this.field});

  @override
  bool passes(
    DropCoreContext context, {
    required String? authenticatedUserId,
    required StateChange? stateChange,
  }) {
    if (stateChange == null) {
      throw Exception('Cannot add Permission.unmodifiable() to a read or delete!');
    }

    final modifiedData = stateChange.getModifiedDataOrNew();
    if (modifiedData.containsKey(field)) {
      return false;
    }

    return true;
  }
}

class AndPermission with IsPermission {
  final List<Permission> permissions;

  AndPermission({required this.permissions});

  @override
  Future<bool> passes(
    DropCoreContext context, {
    required String? authenticatedUserId,
    required StateChange? stateChange,
  }) async {
    for (final permission in permissions) {
      if (!await permission.passes(
        context,
        authenticatedUserId: authenticatedUserId,
        stateChange: stateChange,
      )) {
        return false;
      }
    }

    return true;
  }
}
