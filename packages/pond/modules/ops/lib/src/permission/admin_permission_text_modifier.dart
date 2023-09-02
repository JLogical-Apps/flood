import 'package:drop_core/drop_core.dart';
import 'package:ops/src/permission/permission_text_modifier.dart';
import 'package:ops/src/repository_security/repository_security_modifier.dart';

class AdminPermissionTextModifier extends PermissionTextModifier<AdminPermission> {
  @override
  String getText(DropCoreContext context, AdminPermission permission) {
    final userRepository = context.getRepositoryForTypeRuntime(permission.userEntityType);
    final userRepositoryModifier = RepositorySecurityModifier.getModifier(userRepository);
    final userRepositoryPath = userRepositoryModifier.getPath(userRepository);

    return 'request.auth.uid != null && get(/databases/\$(database)/documents/$userRepositoryPath/\$(request.auth.uid)).data.${permission.adminField} == true';
  }
}
