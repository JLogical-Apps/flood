import 'package:drop_core/drop_core.dart';
import 'package:ops/src/firebase/permission/permission_context.dart';
import 'package:ops/src/firebase/permission/permission_text_modifier.dart';
import 'package:pond_core/pond_core.dart';
import 'package:utils_core/utils_core.dart';

class FirebaseSecurityRulesGenerator {
  String generateFirestoreRules(CorePondContext context) {
    final repositories = context.dropCoreComponent.repositories;

    String getPermissionText(PermissionContext permissionContext, Permission permission) {
      return PermissionTextModifier.getModifier(permission)
          .getText(context.dropCoreComponent, permissionContext, permission);
    }

    final repositoryRules = repositories
        .map((repository) {
          final securityModifier = RepositoryMetaModifier.getModifierOrNull(repository);
          if (securityModifier == null) {
            return null;
          }

          final path = securityModifier.getPath(repository);
          final security = securityModifier.getSecurity(repository);

          if (path == null || security == null) {
            return null;
          }

          final firestorePermissions = {
            'read': security.read,
            'create': security.create,
            'update': security.update,
            'delete': security.delete,
          }
              .mapToIterable((action, permission) =>
                  'allow $action: if ${getPermissionText(getPermissionContext(action), permission)};')
              .join('\n');

          return '''\
match /$path/{id} {
${firestorePermissions.withIndent(2)}
}''';
        })
        .whereNonNull()
        .join('\n');

    return '''\
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if false;
    }
${repositoryRules.withIndent(4)}
  }
}''';
  }

  PermissionContext getPermissionContext(String action) {
    return PermissionContext.values.byName(action);
  }
}
