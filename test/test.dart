import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

void main() {
  test('yaml', () {
    final yaml = ConfigYamlPersistenceGenerator();
    final config = Config(version: 3);
    expect(yaml.save(config), 'version: 3');
    expect(yaml.load('version: 3'), config);
  });
}

class Config extends Equatable {
  final int version;

  const Config({required this.version});

  @override
  List<Object?> get props => [version];
}

class ConfigYamlPersistenceGenerator extends YamlPersistenceGenerator<Config> {
  @override
  Config fromJson(Map<String, dynamic> jsonObject) {
    return Config(version: jsonObject['version']);
  }

  @override
  Map<String, dynamic> toJson(Config config) => {
        'version': config.version,
      };
}
