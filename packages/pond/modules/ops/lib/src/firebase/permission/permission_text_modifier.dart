import 'package:drop_core/drop_core.dart';
import 'package:ops/src/firebase/permission/admin_permission_text_modifier.dart';
import 'package:ops/src/firebase/permission/all_permission_text_modifier.dart';
import 'package:ops/src/firebase/permission/and_permission_text_modifier.dart';
import 'package:ops/src/firebase/permission/authenticated_permission_text_modifier.dart';
import 'package:ops/src/firebase/permission/equals_permission_text_modifier.dart';
import 'package:ops/src/firebase/permission/none_permission_text_modifier.dart';
import 'package:ops/src/firebase/permission/or_permission_text_modifier.dart';
import 'package:ops/src/firebase/permission/permission_context.dart';
import 'package:utils_core/utils_core.dart';

abstract class PermissionTextModifier<P extends Permission> with IsTypedModifier<P, Permission> {
  String getText(DropCoreContext context, PermissionContext permissionContext, P permission);

  static final permissionTextModifierResolver = ModifierResolver<PermissionTextModifier, Permission>(modifiers: [
    AllPermissionTextModifier(),
    NonePermissionTextModifier(),
    AuthenticatedPermissionTextModifier(),
    AdminPermissionTextModifier(),
    EqualsPermissionTextModifier(),
    AndPermissionTextModifier(permissionTextModifierGetter: getModifier),
    OrPermissionTextModifier(permissionTextModifierGetter: getModifier),
  ]);

  static PermissionTextModifier getModifier(Permission permission) {
    return permissionTextModifierResolver.resolve(permission);
  }
}
