import 'package:auth_core/auth_core.dart';
import 'package:drop_core/drop_core.dart';

abstract class PermissionField {
  static EntityIdPermissionField get entityId => EntityIdPermissionField();

  static PropertyPermissionField propertyName(String propertyName) =>
      PropertyPermissionField(propertyName: propertyName);

  static LoggedInUserIdPermissionField get loggedInUserId => LoggedInUserIdPermissionField();

  dynamic extractValue(DropCoreContext context, {required State state, required Account? loggedInAccount});
}

abstract class PermissionFieldSource extends PermissionField {
  String getStateField(DropCoreContext context);
}

abstract class PermissionFieldValue extends PermissionField {
  dynamic getFieldValue(DropCoreContext context, {required Account? loggedInAccount});
}

class PropertyPermissionField implements PermissionField, PermissionFieldSource {
  final String propertyName;

  PropertyPermissionField({required this.propertyName});

  @override
  extractValue(DropCoreContext context, {required State state, required Account? loggedInAccount}) {
    return state[propertyName];
  }

  @override
  String getStateField(DropCoreContext context) {
    return propertyName;
  }
}

class EntityIdPermissionField implements PermissionField, PermissionFieldSource {
  @override
  extractValue(DropCoreContext context, {required State state, required Account? loggedInAccount}) {
    return state.id;
  }

  @override
  String getStateField(DropCoreContext context) {
    return State.idField;
  }
}

class LoggedInUserIdPermissionField implements PermissionField, PermissionFieldValue {
  @override
  extractValue(DropCoreContext context, {required State state, required Account? loggedInAccount}) {
    return loggedInAccount?.accountId;
  }

  @override
  getFieldValue(DropCoreContext context, {required Account? loggedInAccount}) {
    return loggedInAccount?.accountId;
  }
}
