import 'package:drop_core/drop_core.dart';
import 'package:ops/src/firebase/repository/field/entity_id_permission_field_text_modifier.dart';
import 'package:ops/src/firebase/repository/field/entity_property_permission_field_text_modifier.dart';
import 'package:ops/src/firebase/repository/field/logged_in_user_id_permission_field_text_modifier.dart';
import 'package:ops/src/firebase/repository/field/property_permission_field_text_modifier.dart';
import 'package:ops/src/firebase/repository/field/value_permission_field_text_modifier.dart';
import 'package:ops/src/firebase/repository/permission_context.dart';
import 'package:utils_core/utils_core.dart';

abstract class PermissionFieldTextModifier<P extends PermissionField> with IsTypedModifier<P, PermissionField> {
  List<String> getText(DropCoreContext context, PermissionContext permissionContext, P permissionField);

  static final permissionFieldTextModifierResolver =
      ModifierResolver<PermissionFieldTextModifier, PermissionField>(modifiers: [
    ValuePermissionFieldTextModifier(),
    EntityIdPermissionFieldTextModifier(),
    PropertyPermissionFieldTextModifier(),
    EntityPropertyPermissionFieldTextModifier(modifierGetter: getModifier),
    LoggedInUserIdPermissionFieldTextModifier(),
  ]);

  static PermissionFieldTextModifier getModifier(PermissionField permissionField) {
    return permissionFieldTextModifierResolver.resolve(permissionField);
  }
}
