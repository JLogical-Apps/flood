import 'package:environment_core/src/environment_config.dart';
import 'package:test/test.dart';

const environmentKey = 'env';
const qaValue = 'qa';

const typesKey = 'types';
const typesValue = ['String', 'int'];

void main() {
  test('basic config values', () async {
    final config = EnvironmentConfig.memory(keyValueMap: {
      environmentKey: qaValue,
    });

    expect(config.get<String>(environmentKey), qaValue);
    expect(config.get<List<String>>(typesKey), typesValue);
    expect(config.getOrDefault('random', fallback: () => 'myValue'), 'myValue');
    expect(config.getOrNull('random'), isNull);
  });
}
