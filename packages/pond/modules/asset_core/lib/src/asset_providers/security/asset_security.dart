import 'package:asset_core/src/asset_providers/security/asset_permission.dart';

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
