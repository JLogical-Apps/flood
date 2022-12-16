import 'package:environment_core/environment_core.dart';
import 'package:test/test.dart';

const typesKey = 'types';
const typesValue = ['String', 'int'];

const urlKey = 'url';
const basicUrl = 'http://localhost';
const testingUrl = 'http://localhost/testing';
const deviceUrl = 'http://localhost/device';
const qaUrl = 'http://localhost/qa';

void main() {
  test('basic config values', () async {
    final config = EnvironmentConfig.static.memory({
      urlKey: basicUrl,
      typesKey: typesValue,
    });

    expect(await config.get<String>(urlKey), basicUrl);
    expect(await config.get<List<String>>(typesKey), typesValue);
    expect(await config.getOrDefault('random', fallback: () => 'myValue'), 'myValue');
    expect(await config.getOrNull('random'), isNull);
  });

  test('collapsed config values', () async {
    final qaConfig = EnvironmentConfig.static.memory({urlKey: qaUrl, 'qaKey': 'qaValue'});
    final basicConfig = EnvironmentConfig.static.memory({urlKey: basicUrl, 'basicKey': 'basicValue'});

    final collapsedConfig = EnvironmentConfig.static.collapsed([qaConfig, basicConfig]);

    expect(await collapsedConfig.get<String>(urlKey), qaUrl);
    expect(await collapsedConfig.get<String>('qaKey'), 'qaValue');
    expect(await collapsedConfig.get<String>('basicKey'), 'basicValue');
  });

  test('environmental config values', () async {
    final testingConfig = EnvironmentConfig.static.memory({urlKey: testingUrl, 'testingKey': 'testingValue'});
    final deviceConfig = EnvironmentConfig.static.memory({urlKey: deviceUrl, 'deviceKey': 'deviceValue'});
    final qaConfig = EnvironmentConfig.static.memory({urlKey: qaUrl, 'qaKey': 'qaValue'});
    final basicConfig = EnvironmentConfig.static.memory({urlKey: basicUrl, 'basicKey': 'basicValue'});

    EnvironmentConfig getConfigFromDevice(EnvironmentType environmentType) => EnvironmentConfig.static.environmental(
          environmentTypeGetter: () => environmentType,
          environmentGetter: (type) {
            final environmentConfigs = <EnvironmentConfig>[
              if (type is TestingEnvironmentType) testingConfig,
              if (type is DeviceEnvironmentType) deviceConfig,
              if (type is QaEnvironmentType) qaConfig,
              basicConfig,
            ];
            return EnvironmentConfig.static.collapsed(environmentConfigs);
          },
        );

    expect(await getConfigFromDevice(EnvironmentType.static.testing).get(urlKey), testingUrl);
    expect(await getConfigFromDevice(EnvironmentType.static.device).get(urlKey), deviceUrl);
    expect(await getConfigFromDevice(EnvironmentType.static.qa).get(urlKey), qaUrl);
    expect(await getConfigFromDevice(EnvironmentType.static.production).get(urlKey), basicUrl);
  });
}
