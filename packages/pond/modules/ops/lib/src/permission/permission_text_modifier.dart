import 'package:drop_core/drop_core.dart';
import 'package:ops/src/permission/all_permission_text_modifier.dart';
import 'package:ops/src/permission/authenticated_permission_text_modifier.dart';
import 'package:ops/src/permission/none_permission_text_modifier.dart';
import 'package:utils_core/utils_core.dart';

abstract class PermissionTextModifier<P extends Permission> with IsTypedModifier<P, Permission> {
  String getText(P permission);

  static final permissionTextModifierResolver = ModifierResolver<PermissionTextModifier, Permission>(modifiers: [
    AllPermissionTextModifier(),
    NonePermissionTextModifier(),
    AuthenticatedPermissionTextModifier(),
  ]);

  static PermissionTextModifier getModifier(Permission permission) {
    return permissionTextModifierResolver.resolve(permission);
  }
}
