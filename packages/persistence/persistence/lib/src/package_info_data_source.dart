import 'package:package_info_plus/package_info_plus.dart';
import 'package:persistence/persistence.dart';

class PackageInfoDataSource with IsDataSource<PackageInfo> {
  @override
  Stream<PackageInfo>? getXOrNull() async* {
    yield await PackageInfo.fromPlatform();
  }

  @override
  Future<void> set(PackageInfo data) {
    throw Exception('Cannot set package info!');
  }

  @override
  Future<void> delete() {
    throw Exception('Cannot delete package info!');
  }
}

extension PackageInfoDataSourceStaticExtension on DataSourceStatic {
  PackageInfoDataSource packageInfo() {
    return PackageInfoDataSource();
  }
}
