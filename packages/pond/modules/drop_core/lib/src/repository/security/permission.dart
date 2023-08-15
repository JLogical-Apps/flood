import 'dart:async';

import 'package:drop_core/src/context/drop_core_context.dart';
import 'package:drop_core/src/query/query.dart';
import 'package:drop_core/src/query/request/query_request.dart';

abstract class Permission {
  static Permission get all => AllPermission();

  static Permission get none => NonePermission();

  static Permission get authenticated => AuthenticatedPermission();

  static Permission isAdmin({required Type userEntityType, required String adminField}) => AdminPermission(
        userEntityType: userEntityType,
        adminField: adminField,
      );

  FutureOr<bool> passes(DropCoreContext context, {required String? authenticatedUserId});
}

class AllPermission implements Permission {
  @override
  bool passes(DropCoreContext context, {required String? authenticatedUserId}) {
    return true;
  }
}

class NonePermission implements Permission {
  @override
  bool passes(DropCoreContext context, {required String? authenticatedUserId}) {
    return false;
  }
}

class AuthenticatedPermission implements Permission {
  @override
  bool passes(DropCoreContext context, {required String? authenticatedUserId}) {
    return authenticatedUserId != null;
  }
}

class AdminPermission implements Permission {
  final Type userEntityType;
  final String adminField;

  AdminPermission({required this.userEntityType, required this.adminField});

  @override
  Future<bool> passes(DropCoreContext context, {required String? authenticatedUserId}) async {
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
