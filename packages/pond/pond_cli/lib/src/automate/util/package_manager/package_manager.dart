abstract class PackageManager {
  Future<bool> isPackageRegistered(String packageName, {bool? isDevDependency});

  Future<void> registerPackage(String packageName, {required bool isDevDependency});
}

mixin IsPackageManager implements PackageManager {}

abstract class PackageManagerWrapper implements PackageManager {
  PackageManager get packageManager;
}

mixin IsPackageManagerWrapper implements PackageManagerWrapper {
  @override
  Future<bool> isPackageRegistered(String packageName, {bool? isDevDependency}) {
    return packageManager.isPackageRegistered(packageName, isDevDependency: isDevDependency);
  }

  @override
  Future<void> registerPackage(String packageName, {required bool isDevDependency}) {
    return packageManager.registerPackage(packageName, isDevDependency: isDevDependency);
  }
}
