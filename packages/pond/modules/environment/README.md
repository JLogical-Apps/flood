# Environment

This package exports extensions to `EnvironmentConfig.static`, which allows you to setup `EnvironmentConfig`s based on Flutter-related assets.

## EnvironmentConfigs

- `EnvironmentConfig.static.flutterAssets()`: Environment is setup by looking at `config.overrides.yaml` first, then `config.release.yaml` if it's a release build, then `config.web.yaml` if it's a web build, then `config.testing.yaml` if the environment is testing, then `config.device.yaml` if the environment is device, then `config.qa.yaml` if the environment is qa, then `config.staging.yaml` if the environment is staging, then `config.production.yaml` if the environment is production, then `config.yaml` for anything else. It sets the platform, build type, and environment based on the flutter configs.
