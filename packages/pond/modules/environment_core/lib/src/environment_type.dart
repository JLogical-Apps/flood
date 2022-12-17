abstract class EnvironmentType {
  String get name;

  static EnvironmentTypeStatic static = EnvironmentTypeStatic();
}

class EnvironmentTypeStatic {
  final TestingEnvironmentType testing = TestingEnvironmentType();
  final DeviceEnvironmentType device = DeviceEnvironmentType();
  final QaEnvironmentType qa = QaEnvironmentType();
  final ProductionEnvironmentType production = ProductionEnvironmentType();

  List<EnvironmentType> get defaultTypes => [
        testing,
        device,
        qa,
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

class ProductionEnvironmentType implements EnvironmentType {
  @override
  String get name => 'production';
}
