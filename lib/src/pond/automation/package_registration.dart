abstract class PackageRegistration {
  Future<bool> isPackageRegistered(String packageName, {bool? isDevDependency});

  Future<void> registerPackage(String packageName, {required bool isDevDependency});
}
