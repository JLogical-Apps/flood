abstract class ReleaseEnvironmentType {
  String get name;

  static final ReleaseEnvironmentType alpha = AlphaReleaseEnvironmentType();

  static final ReleaseEnvironmentType beta = BetaReleaseEnvironmentType();

  static final ReleaseEnvironmentType production = ProductionReleaseEnvironmentType();
}

class AlphaReleaseEnvironmentType implements ReleaseEnvironmentType {
  @override
  String get name => 'alpha';
}

class BetaReleaseEnvironmentType implements ReleaseEnvironmentType {
  @override
  String get name => 'beta';
}

class ProductionReleaseEnvironmentType implements ReleaseEnvironmentType {
  @override
  String get name => 'main';
}
