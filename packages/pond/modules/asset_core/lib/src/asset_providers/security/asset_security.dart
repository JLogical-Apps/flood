import 'package:asset_core/src/asset_providers/security/asset_permission.dart';
import 'package:asset_core/src/asset_providers/security/repository/repository_permission_asset_modifier.dart';
import 'package:drop_core/drop_core.dart';

class AssetSecurity {
  final AssetPermission read;
  final AssetPermission write;
  final AssetPermission delete;

  AssetSecurity({required this.read, required this.write, required this.delete});

  AssetSecurity.readWrite({required this.read, required this.write}) : delete = write;

  AssetSecurity.all(AssetPermission assetPermission) : this.readWrite(read: assetPermission, write: assetPermission);

  AssetSecurity.public() : this.all(AssetPermission.all);

  AssetSecurity.authenticated() : this.all(AssetPermission.authenticated);

  AssetSecurity.none() : this.all(AssetPermission.none);

  factory AssetSecurity.fromRepository(Repository repository) {
    final repositorySecurity = RepositoryMetaModifier.getModifier(repository).getSecurity(repository) ??
        (throw Exception(
            'Cannot generate asset security from repository security when repository does not have security!'));
    return AssetSecurity(
      read: RepositoryPermissionAssetModifier.getAssetPermission(repository, repositorySecurity.read),
      write: RepositoryPermissionAssetModifier.getAssetPermission(repository, repositorySecurity.update),
      delete: RepositoryPermissionAssetModifier.getAssetPermission(repository, repositorySecurity.delete),
    );
  }

  AssetSecurity copyWith({AssetPermission? read, AssetPermission? write, AssetPermission? delete}) {
    return AssetSecurity(
      read: read ?? this.read,
      write: write ?? this.write,
      delete: delete ?? this.delete,
    );
  }

  AssetSecurity withRead(AssetPermission read) {
    return copyWith(read: read);
  }

  AssetSecurity withWrite(AssetPermission write) {
    return copyWith(write: write, delete: write);
  }
}
