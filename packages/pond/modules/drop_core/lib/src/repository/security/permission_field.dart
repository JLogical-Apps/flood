import 'dart:async';

import 'package:auth_core/auth_core.dart';
import 'package:drop_core/src/context/drop_core_context.dart';
import 'package:drop_core/src/record/entity.dart';
import 'package:drop_core/src/repository/security/permission_entity_builder.dart';
import 'package:drop_core/src/state/state.dart';

abstract class PermissionField {
  static ValuePermissionField value(dynamic value) {
    return ValuePermissionField(value: value);
  }

  static EntityIdPermissionField get entityId => EntityIdPermissionField();

  static PropertyPermissionField propertyName(String propertyName) =>
      PropertyPermissionField(propertyName: propertyName);

  static LoggedInUserIdPermissionField get loggedInUserId => LoggedInUserIdPermissionField();

  static PermissionEntityBuilder<E> entity<E extends Entity>(PermissionField field) {
    return PermissionEntityBuilder<E>(permissionField: field);
  }

  FutureOr<bool> isValidValue(DropCoreContext context, {required State state, required Account? loggedInAccount});

  FutureOr<dynamic> extractValue(DropCoreContext context, {required State state, required Account? loggedInAccount});
}

class ValuePermissionField implements PermissionField {
  final dynamic value;

  ValuePermissionField({required this.value});

  @override
  bool isValidValue(DropCoreContext context, {required State state, required Account? loggedInAccount}) {
    return true;
  }

  @override
  extractValue(DropCoreContext context, {required State state, required Account? loggedInAccount}) {
    return value;
  }
}

class PropertyPermissionField implements PermissionField {
  final String propertyName;

  PropertyPermissionField({required this.propertyName});

  @override
  bool isValidValue(DropCoreContext context, {required State state, required Account? loggedInAccount}) {
    return true;
  }

  @override
  extractValue(DropCoreContext context, {required State state, required Account? loggedInAccount}) {
    return state[propertyName];
  }
}

class EntityIdPermissionField implements PermissionField {
  @override
  bool isValidValue(DropCoreContext context, {required State state, required Account? loggedInAccount}) {
    return state.id != null;
  }

  @override
  extractValue(DropCoreContext context, {required State state, required Account? loggedInAccount}) {
    return state.id;
  }
}

class LoggedInUserIdPermissionField implements PermissionField {
  @override
  FutureOr<bool> isValidValue(DropCoreContext context, {required State state, required Account? loggedInAccount}) {
    return true;
  }

  @override
  extractValue(DropCoreContext context, {required State state, required Account? loggedInAccount}) {
    return loggedInAccount?.accountId;
  }
}
