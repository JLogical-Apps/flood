abstract class EnvironmentType {
  String get name;

  static EnvironmentTypeStatic static = EnvironmentTypeStatic();
}

extension EnvironmentTypeExtensions on EnvironmentType {
  bool get isOnline => [
        EnvironmentType.static.qa,
        EnvironmentType.static.staging,
        EnvironmentType.static.production,
      ].contains(this);
}

class EnvironmentTypeStatic {
  final TestingEnvironmentType testing = TestingEnvironmentType();
  final DeviceEnvironmentType device = DeviceEnvironmentType();
  final QaEnvironmentType qa = QaEnvironmentType();
  final StagingEnvironmentType staging = StagingEnvironmentType();
  final ProductionEnvironmentType production = ProductionEnvironmentType();

  List<EnvironmentType> get defaultTypes => [
        testing,
        device,
        qa,
        staging,
        production,
      ];
}

class TestingEnvironmentType implements EnvironmentType {
  @override
  String get name => 'testing';
}

class DeviceEnvironmentType implements EnvironmentType {
  @override
  String get name => 'device';
}

class QaEnvironmentType implements EnvironmentType {
  @override
  String get name => 'qa';
}

class StagingEnvironmentType implements EnvironmentType {
  @override
  String get name => 'staging';
}

class ProductionEnvironmentType implements EnvironmentType {
  @override
  String get name => 'production';
}
