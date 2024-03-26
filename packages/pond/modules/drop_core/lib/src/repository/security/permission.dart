import 'package:auth_core/auth_core.dart';
import 'package:drop_core/src/context/drop_core_context.dart';
import 'package:drop_core/src/query/query.dart';
import 'package:drop_core/src/record/entity.dart';
import 'package:drop_core/src/repository/security/permission_field.dart';
import 'package:drop_core/src/state/state.dart';

abstract class Permission {
  static Permission get all => AllPermission();

  static Permission get none => NonePermission();

  static Permission get authenticated => AuthenticatedPermission();

  static Permission get admin => AdminPermission();

  static Permission equals(PermissionFieldSource field1, PermissionFieldValue field2) =>
      EqualsPermission(field1: field1, field2: field2);

  static Permission and(List<Permission> permissions) => AndPermission(permissions: permissions);

  static Permission or(List<Permission> permissions) => OrPermission(permissions: permissions);

  bool passes(
    DropCoreContext context, {
    required Account? loggedInAccount,
  });

  bool passesState(
    DropCoreContext context, {
    required State state,
    required Account? loggedInAccount,
  });

  Query<E> modifyQuery<E extends Entity>(
    DropCoreContext context, {
    required Query<E> query,
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
  bool passesState(
    DropCoreContext context, {
    required State state,
    required Account? loggedInAccount,
  }) {
    return passes(context, loggedInAccount: loggedInAccount);
  }

  @override
  Query<E> modifyQuery<E extends Entity>(
    DropCoreContext context, {
    required Query<E> query,
    required Account? loggedInAccount,
  }) {
    return query;
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
  final PermissionFieldSource field1;
  final PermissionFieldValue field2;

  EqualsPermission({required this.field1, required this.field2});

  @override
  bool passes(DropCoreContext context, {required Account? loggedInAccount}) {
    return true;
  }

  @override
  bool passesState(
    DropCoreContext context, {
    required State state,
    required Account? loggedInAccount,
  }) {
    return field1.extractValue(context, state: state, loggedInAccount: loggedInAccount) ==
        field2.extractValue(context, state: state, loggedInAccount: loggedInAccount);
  }

  @override
  Query<E> modifyQuery<E extends Entity>(
    DropCoreContext context, {
    required Query<E> query,
    required Account? loggedInAccount,
  }) {
    return query
        .where(field1.getStateField(context))
        .isEqualTo(field2.getFieldValue(context, loggedInAccount: loggedInAccount));
  }
}

class AndPermission with IsPermission {
  final List<Permission> permissions;

  AndPermission({required this.permissions});

  @override
  bool passes(
    DropCoreContext context, {
    required Account? loggedInAccount,
  }) {
    for (final permission in permissions) {
      if (!permission.passes(context, loggedInAccount: loggedInAccount)) {
        return false;
      }
    }

    return true;
  }

  @override
  bool passesState(
    DropCoreContext context, {
    required State state,
    required Account? loggedInAccount,
  }) {
    for (final permission in permissions) {
      if (!permission.passesState(
        context,
        state: state,
        loggedInAccount: loggedInAccount,
      )) {
        return false;
      }
    }

    return true;
  }

  @override
  Query<E> modifyQuery<E extends Entity>(
    DropCoreContext context, {
    required Query<E> query,
    required Account? loggedInAccount,
  }) {
    for (final permission in permissions) {
      query = permission.modifyQuery(context, query: query, loggedInAccount: loggedInAccount);
    }
    return query;
  }
}

class OrPermission with IsPermission {
  final List<Permission> permissions;

  OrPermission({required this.permissions});

  @override
  bool passes(
    DropCoreContext context, {
    required Account? loggedInAccount,
  }) {
    for (final permission in permissions) {
      if (permission.passes(context, loggedInAccount: loggedInAccount)) {
        return true;
      }
    }

    return false;
  }

  @override
  bool passesState(
    DropCoreContext context, {
    required State state,
    required Account? loggedInAccount,
  }) {
    for (final permission in permissions) {
      if (permission.passesState(
        context,
        state: state,
        loggedInAccount: loggedInAccount,
      )) {
        return true;
      }
    }

    return false;
  }

  @override
  Query<E> modifyQuery<E extends Entity>(
    DropCoreContext context, {
    required Query<E> query,
    required Account? loggedInAccount,
  }) {
    for (final permission in permissions) {
      if (permission.passes(context, loggedInAccount: loggedInAccount)) {
        return permission.modifyQuery(context, query: query, loggedInAccount: loggedInAccount);
      }
    }

    return query;
  }
}
