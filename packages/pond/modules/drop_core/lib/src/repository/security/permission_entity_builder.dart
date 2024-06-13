import 'package:auth_core/auth_core.dart';
import 'package:drop_core/drop_core.dart';

class PermissionEntityBuilder<E extends Entity> {
  final PermissionField permissionField;

  PermissionEntityBuilder({required this.permissionField});

  PermissionField propertyName(String propertyName) {
    return EntityPropertyPermissionField<E>(permissionField: permissionField, propertyName: propertyName);
  }
}

class EntityPropertyPermissionField<E extends Entity> implements PermissionField {
  final PermissionField permissionField;
  final String propertyName;

  Type get entityType => E;

  EntityPropertyPermissionField({required this.permissionField, required this.propertyName});

  @override
  Future<dynamic> extractValue(
    DropCoreContext context, {
    required State state,
    required Account? loggedInAccount,
  }) async {
    final id = await permissionField.extractValue(context, state: state, loggedInAccount: loggedInAccount);
    if (id == null) {
      return null;
    }

    final entity = await Query.getByIdOrNull<E>(id).get(context);
    if (entity == null) {
      return null;
    }

    final entityState = entity.getState(context);
    return entityState[propertyName];
  }

  @override
  Future<bool> isValidValue(DropCoreContext context, {required State state, required Account? loggedInAccount}) async {
    final id = await permissionField.extractValue(context, state: state, loggedInAccount: loggedInAccount);
    if (id == null) {
      return false;
    }

    final entity = await Query.getByIdOrNull<E>(id).get(context);
    return entity != null;
  }
}
