# Flood

[Flood](https://www.flooddev.com) is a framework for Flutter to streamline Flutter/Dart development.

## Example

Look in `example` to see an app that utilizes many of the features in Flood. Feel free to
modify the example app to include anything that would help with testing.

## Packages

All utilities are isolated into separate packages in `packages`. This allows each package to
explicitly declare its dependencies and not depend on frameworks it doesn't need. For example, a CLI
module cannot depend on Flutter, so the separate packages allow to clearly know whether a package
depends on Flutter or not.

The structure of this repository is called a `monorepo`. The `monorepo` is managed by a dart package
called [melos](https://pub.dev/packages/melos). More details on the tools `melos` provides are down
below.

Each package is a separate Dart/Flutter project with its own `pubspec.yaml` file and `lib` folder.

### Types of packages

Some packages define utilities for a Flutter app and contain utilities to be used in all contexts (
such as a CLI). Since CLIs cannot depend on Flutter, we break up such packages into a `core` package
and a regular package.

Packages that end with `_core` define core functionality of the package that can be used in all
contexts. Packages that do not end in `_core` are assumed to depend on Flutter.

### Referencing another package

In the case where a package needs to depend on another package, for example, `pond_core`
depends on the `utils_core` package, use this pattern in the `pubspec.yaml` of `pond_core`:

```yaml
dependencies:
  utils_core: # Must be the name of the package as defined in its `pubspec.yaml` `name` field. 
    git:
      url: git@github.com:JLogical-Apps/flood.git # Reference the git repository.
      ref: v4.2
      path: packages/utils/utils_core # The path of the package 
```

## Setup

Install melos using their [installation guide](https://pub.dev/packages/melos#getting-started)

## Development

### Adding a new dependency

Run `melos bootstrap` (`melos bs` for short) every time you add a new dependency to any of the
package (including `example`!). This will link all your packages up internally and get all the
external packages as well.

### Testing

Run `melos test` to run tests on all the packages.
