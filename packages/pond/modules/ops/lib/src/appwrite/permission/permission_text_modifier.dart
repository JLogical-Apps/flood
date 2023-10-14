import 'package:drop_core/drop_core.dart';
import 'package:ops/src/appwrite/permission/admin_permission_text_modifier.dart';
import 'package:ops/src/appwrite/permission/all_permission_text_modifier.dart';
import 'package:ops/src/appwrite/permission/and_permission_text_modifier.dart';
import 'package:ops/src/appwrite/permission/authenticated_permission_text_modifier.dart';
import 'package:ops/src/appwrite/permission/none_permission_text_modifier.dart';
import 'package:utils_core/utils_core.dart';

abstract class PermissionTextModifier<P extends Permission> with IsTypedModifier<P, Permission> {
  List<String> getPermissions(DropCoreContext context, P permission);

  static final permissionTextModifierResolver = ModifierResolver<PermissionTextModifier, Permission>(modifiers: [
    AllPermissionTextModifier(),
    NonePermissionTextModifier(),
    AuthenticatedPermissionTextModifier(),
    AdminPermissionTextModifier(),
    AndPermissionTextModifier(permissionTextModifierGetter: getModifier),
  ]);

  static PermissionTextModifier getModifier(Permission permission) {
    return permissionTextModifierResolver.resolve(permission);
  }
}
