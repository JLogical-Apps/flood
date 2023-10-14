import 'dart:async';

import 'package:auth_core/auth_core.dart';
import 'package:drop_core/src/context/drop_core_context.dart';

abstract class Permission {
  static Permission get all => AllPermission();

  static Permission get none => NonePermission();

  static Permission get authenticated => AuthenticatedPermission();

  static Permission get admin => AdminPermission();

  static Permission and(List<Permission> permissions) => AndPermission(permissions: permissions);

  FutureOr<bool> passes(
    DropCoreContext context, {
    required Account? loggedInAccount,
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
  Future<bool> passes(
    DropCoreContext context, {
    required Account? loggedInAccount,
  }) async {
    if (loggedInAccount == null) {
      return false;
    }

    return loggedInAccount.isAdmin;
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
      if (!await permission.passes(
        context,
        loggedInAccount: loggedInAccount,
      )) {
        return false;
      }
    }

    return true;
  }
}
