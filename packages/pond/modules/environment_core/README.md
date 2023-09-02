# Environment (Core)

This package exports `EnvironmentCoreComponent` which manages the environment of the application.

## EnvironmentCoreComponent

Pass in an `EnvironmentConfig` that defines the environmental config of the app.

## EnvironmentConfig

Defines:

- `get<T>(keyName)`: Returns an environment variable with `keyName`.
- `getEnvironmentType()`: Returns the `EnvironmentType` such as `EnvironmentType.static.production` or `EnvironmentType.static.testing`.
- `getBuildType()`: Returns the `BuildType` such as `BuildType.release` or `BuildType.regular`.
- `getPlatform()`: Returns the `Platform` such as `Platform.mobile` or `Platform.cli`.
- `getFileSystem()`: Returns a `FileSystem` which can be used to create permanent or temporary files.
