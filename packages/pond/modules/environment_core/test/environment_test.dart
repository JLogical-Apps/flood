import 'package:environment_core/src/environment_config.dart';
import 'package:test/test.dart';

const typesKey = 'types';
const typesValue = ['String', 'int'];

const urlKey = 'url';
const basicUrl = 'http://localhost';
const qaUrl = 'http://localhost/qa';

void main() {
  test('basic config values', () async {
    final config = EnvironmentConfig.memory({
      urlKey: basicUrl,
      typesKey: typesValue,
    });

    expect(await config.get<String>(urlKey), basicUrl);
    expect(await config.get<List<String>>(typesKey), typesValue);
    expect(await config.getOrDefault('random', fallback: () => 'myValue'), 'myValue');
    expect(await config.getOrNull('random'), isNull);
  });

  test('collapsed config values', () async {
    final qaConfig = EnvironmentConfig.memory({urlKey: qaUrl, 'qaKey': 'qaValue'});
    final basicConfig = EnvironmentConfig.memory({urlKey: basicUrl, 'basicKey': 'basicValue'});

    final collapsedConfig = EnvironmentConfig.collapsed([qaConfig, basicConfig]);

    expect(await collapsedConfig.get<String>(urlKey), qaUrl);
    expect(await collapsedConfig.get<String>('qaKey'), 'qaValue');
    expect(await collapsedConfig.get<String>('basicKey'), 'basicValue');
  });
}
