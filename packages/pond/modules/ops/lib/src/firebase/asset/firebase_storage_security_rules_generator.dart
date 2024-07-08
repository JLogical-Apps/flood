import 'package:asset_core/asset_core.dart';
import 'package:drop_core/drop_core.dart';
import 'package:ops/src/firebase/asset/asset_permission_text_modifier.dart';
import 'package:pond_core/pond_core.dart';
import 'package:utils_core/utils_core.dart';

class FirebaseStorageSecurityRulesGenerator {
  String generate(CorePondContext context) {
    final assetProviders = context.assetCoreComponent.assetProviders(context.assetCoreComponent);

    String getPermissionText(AssetPermissionContext assetPermissionContext, AssetPermission assetPermission) {
      return AssetPermissionTextModifier.getModifier(assetPermission)
          .getText(context.dropCoreComponent, assetPermissionContext, assetPermission);
    }

    final assetProviderRules = assetProviders
        .map((assetProvider) {
          final metaModifier = AssetProviderMetaModifier.getModifierOrNull(assetProvider);
          if (metaModifier == null) {
            return null;
          }

          final path = metaModifier.getPath(
              assetProvider,
              AssetPathContext(
                context: context.assetCoreComponent,
                values: {State.idField: '{id}'},
              ));
          final security = metaModifier.getSecurity(assetProvider);

          if (path == null || security == null) {
            return null;
          }

          final firebaseStoragePermissions = {
            'read': security.read,
            'create': security.create,
            'update': security.update,
            'delete': security.delete,
          }
              .mapToIterable((action, permission) =>
                  'allow $action: if ${getPermissionText(getPermissionContext(action), permission)};')
              .join('\n');

          return '''\
match /$path/{assetIds=**} {
${firebaseStoragePermissions.withIndent(2)}
}''';
        })
        .whereNonNull()
        .join('\n');

    return '''\
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /{assetIds=**} {
      allow read, write: if false;
    }
${assetProviderRules.withIndent(4)}
  }
}''';
  }

  AssetPermissionContext getPermissionContext(String action) {
    return AssetPermissionContext.values.byName(action);
  }
}
