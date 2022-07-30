class AssetMetadata {
  /// The time the asset was last updated.
  final DateTime? lastUpdated;

  /// The time the asset was originally created.
  final DateTime? timeCreated;

  /// Size of the asset in bytes.
  final int? size;

  const AssetMetadata({this.lastUpdated, this.timeCreated, required this.size});

  AssetMetadata.now({required this.size})
      : lastUpdated = DateTime.now(),
        timeCreated = DateTime.now();
}
