abstract class EnvironmentType {
  static EnvironmentTypeStatic get static => EnvironmentTypeStatic();
}

class EnvironmentTypeStatic {
  final TestingEnvironmentType testing = TestingEnvironmentType();
  final DeviceEnvironmentType device = DeviceEnvironmentType();
  final QaEnvironmentType qa = QaEnvironmentType();
  final ProductionEnvironmentType production = ProductionEnvironmentType();
}

class TestingEnvironmentType implements EnvironmentType {}

class DeviceEnvironmentType implements EnvironmentType {}

class QaEnvironmentType implements EnvironmentType {}

class ProductionEnvironmentType implements EnvironmentType {}
