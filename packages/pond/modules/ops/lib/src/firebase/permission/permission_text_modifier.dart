import 'package:drop_core/drop_core.dart';
import 'package:ops/src/firebase/permission/admin_permission_text_modifier.dart';
import 'package:ops/src/firebase/permission/all_permission_text_modifier.dart';
import 'package:ops/src/firebase/permission/and_permission_text_modifier.dart';
import 'package:ops/src/firebase/permission/authenticated_permission_text_modifier.dart';
import 'package:ops/src/firebase/permission/none_permission_text_modifier.dart';
import 'package:utils_core/utils_core.dart';

abstract class PermissionTextModifier<P extends Permission> with IsTypedModifier<P, Permission> {
  String getText(DropCoreContext context, P permission);

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
