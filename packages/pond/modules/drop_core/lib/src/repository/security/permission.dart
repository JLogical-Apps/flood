import 'dart:async';

import 'package:auth_core/auth_core.dart';
import 'package:drop_core/src/context/drop_core_context.dart';
import 'package:drop_core/src/repository/security/permission_field.dart';
import 'package:drop_core/src/state/state.dart';

abstract class Permission {
  static Permission get all => AllPermission();

  static Permission get none => NonePermission();

  static Permission get authenticated => AuthenticatedPermission();

  static Permission get admin => AdminPermission();

  static Permission equals(PermissionField field1, PermissionField field2) =>
      EqualsPermission(field1: field1, field2: field2);

  static Permission and(List<Permission> permissions) => AndPermission(permissions: permissions);

  static Permission or(List<Permission> permissions) => OrPermission(permissions: permissions);

  FutureOr<bool> passes(
    DropCoreContext context, {
    required Account? loggedInAccount,
  });

  FutureOr<bool> passesState(
    DropCoreContext context, {
    required State state,
    required Account? loggedInAccount,
  });

  operator &(Permission other);

  operator |(Permission other);
}

mixin IsPermission implements Permission {
  @override
  operator &(Permission other) {
    return AndPermission(permissions: [this, other]);
  }

  @override
  operator |(Permission other) {
    return OrPermission(permissions: [this, other]);
  }

  @override
  Future<bool> passesState(
    DropCoreContext context, {
    required State state,
    required Account? loggedInAccount,
  }) async {
    return await passes(context, loggedInAccount: loggedInAccount);
  }
}

class AllPermission with IsPermission {
  @override
  bool passes(
    DropCoreContext context, {
    required Account? loggedInAccount,
  }) {
    return true;
  }
}

class NonePermission with IsPermission {
  @override
  bool passes(
    DropCoreContext context, {
    required Account? loggedInAccount,
  }) {
    return false;
  }
}

class AuthenticatedPermission with IsPermission {
  @override
  bool passes(
    DropCoreContext context, {
    required Account? loggedInAccount,
  }) {
    return loggedInAccount != null;
  }
}

class AdminPermission with IsPermission {
  @override
  bool passes(
    DropCoreContext context, {
    required Account? loggedInAccount,
  }) {
    if (loggedInAccount == null) {
      return false;
    }

    return loggedInAccount.isAdmin;
  }
}

class EqualsPermission with IsPermission {
  final PermissionField field1;
  final PermissionField field2;

  EqualsPermission({required this.field1, required this.field2});

  @override
  bool passes(DropCoreContext context, {required Account? loggedInAccount}) {
    return true;
  }

  @override
  Future<bool> passesState(
    DropCoreContext context, {
    required State state,
    required Account? loggedInAccount,
  }) async {
    if (!await field1.isValidValue(context, state: state, loggedInAccount: loggedInAccount) ||
        !await field2.isValidValue(context, state: state, loggedInAccount: loggedInAccount)) {
      return false;
    }

    return await field1.extractValue(context, state: state, loggedInAccount: loggedInAccount) ==
        await field2.extractValue(context, state: state, loggedInAccount: loggedInAccount);
  }
}

class AndPermission with IsPermission {
  final List<Permission> permissions;

  AndPermission({required this.permissions});

  @override
  Future<bool> passes(
    DropCoreContext context, {
    required Account? loggedInAccount,
  }) async {
    for (final permission in permissions) {
      if (!await permission.passes(context, loggedInAccount: loggedInAccount)) {
        return false;
      }
    }

    return true;
  }

  @override
  Future<bool> passesState(
    DropCoreContext context, {
    required State state,
    required Account? loggedInAccount,
  }) async {
    for (final permission in permissions) {
      if (!await permission.passesState(
        context,
        state: state,
        loggedInAccount: loggedInAccount,
      )) {
        return false;
      }
    }

    return true;
  }
}

class OrPermission with IsPermission {
  final List<Permission> permissions;

  OrPermission({required this.permissions});

  @override
  Future<bool> passes(
    DropCoreContext context, {
    required Account? loggedInAccount,
  }) async {
    for (final permission in permissions) {
      if (await permission.passes(context, loggedInAccount: loggedInAccount)) {
        return true;
      }
    }

    return false;
  }

  @override
  Future<bool> passesState(
    DropCoreContext context, {
    required State state,
    required Account? loggedInAccount,
  }) async {
    for (final permission in permissions) {
      if (await permission.passesState(
        context,
        state: state,
        loggedInAccount: loggedInAccount,
      )) {
        return true;
      }
    }

    return false;
  }
}
