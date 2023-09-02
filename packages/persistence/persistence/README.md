# Persistence

This package exports DataSources to use in a Flutter context.

## New DataSources

- `DataSource.static.asset('assets/config.yaml')`: A String representation of the asset at `assets/config.yaml`. You can use `.mapYaml()` at the end to tranform the value into a Map<String, dynamic> instead of dealing with the raw String. You cannot `.set()` or `.delete()` an asset DataSource.

- `DataSource.static.rawAsset('assets/music.wav')`: Returns the raw bytes for the asset at `assets/music.wav`.
