import 'dart:async';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:environment_core/src/build_type.dart';
import 'package:environment_core/src/collapsed_environment_config.dart';
import 'package:environment_core/src/data_source_environment_config.dart';
import 'package:environment_core/src/environment_type.dart';
import 'package:environment_core/src/environment_type_environment_config.dart';
import 'package:environment_core/src/environmental_environment_config.dart';
import 'package:environment_core/src/file_asset_environment_config.dart';
import 'package:environment_core/src/platform.dart';
import 'package:environment_core/src/recognized_environment_types_environment_config.dart';
import 'package:persistence_core/persistence_core.dart';

abstract class EnvironmentConfig {
  Future<T> getOrDefault<T>(String key, {required T Function() fallback});

  Future<bool> containsKey(String key);

  Future<EnvironmentType> getEnvironmentType();

  Future<BuildType> getBuildType();

  Future<Platform> getPlatform();

  static EnvironmentConfigStatic get static => EnvironmentConfigStatic();
}

class EnvironmentConfigStatic {
  DataSourceEnvironmentConfig fromDataSource(DataSource<Map<String, dynamic>> dataSource) =>
      DataSourceEnvironmentConfig(dataSource: dataSource);

  CollapsedEnvironmentConfig collapsed(List<EnvironmentConfig> configs) => CollapsedEnvironmentConfig(configs: configs);

  DataSourceEnvironmentConfig memory([Map<String, dynamic> initialData = const {}]) =>
      fromDataSource(DataSource.static.memory(initialData: initialData));

  DataSourceEnvironmentConfig yamlFile(File file) => fromDataSource(DataSource.static.file(file).mapYaml());

  EnvironmentTypeEnvironmentConfig onlyEnvironmentType(EnvironmentType environmentType) =>
      EnvironmentTypeEnvironmentConfig(environmentType: environmentType);

  FileAssetEnvironmentConfig fileAssets() => FileAssetEnvironmentConfig();

  EnvironmentConfig testing() => memory({'environment': 'testing'});
}

extension EnvironmentConfigExtensions on EnvironmentConfig {
  Future<T> get<T>(String key) async {
    return await getOrDefault(key, fallback: () => throw Exception('Cannot find value for [$key] in config.'));
  }

  Future<T?> getOrNull<T>(String key) async {
    return await getOrDefault<T?>(key, fallback: () => null);
  }

  RecognizedEnvironmentTypesEnvironmentConfig withRecognizedEnvironmentTypes(List<EnvironmentType> enviromentTypes) {
    return RecognizedEnvironmentTypesEnvironmentConfig(
      environmentConfig: this,
      recognizedEnvironmentTypes: enviromentTypes,
    );
  }

  EnvironmentalEnvironmentConfig environmental(
    FutureOr<EnvironmentConfig> Function(EnvironmentType type) environmentConfigGetter,
  ) {
    return EnvironmentalEnvironmentConfig(
      environmentConfig: this,
      environmentGetter: environmentConfigGetter,
    );
  }
}

mixin IsEnvironmentConfig implements EnvironmentConfig {
  @override
  Future<bool> containsKey(String key) async {
    return await getOrNull(key) != null;
  }

  @override
  Future<EnvironmentType> getEnvironmentType() async {
    final environmentValue = await getOrNull<String>('environment');
    if (environmentValue == null) {
      return EnvironmentType.static.production;
    }

    return EnvironmentType.static.defaultTypes
            .firstWhereOrNull((environmentType) => environmentType.name == environmentValue) ??
        EnvironmentType.static.production;
  }

  @override
  Future<BuildType> getBuildType() => Future.value(BuildType.regular);

  @override
  Future<Platform> getPlatform() => Future.value(Platform.cli);
}

abstract class EnvironmentConfigWrapper implements EnvironmentConfig {
  EnvironmentConfig get environmentConfig;
}

mixin IsEnvironmentConfigWrapper implements EnvironmentConfigWrapper {
  @override
  Future<EnvironmentType> getEnvironmentType() => environmentConfig.getEnvironmentType();

  @override
  Future<BuildType> getBuildType() => environmentConfig.getBuildType();

  @override
  Future<Platform> getPlatform() => environmentConfig.getPlatform();

  @override
  Future<T> getOrDefault<T>(String key, {required T Function() fallback}) =>
      environmentConfig.getOrDefault<T>(key, fallback: fallback);

  @override
  Future<bool> containsKey(String key) => environmentConfig.containsKey(key);
}
