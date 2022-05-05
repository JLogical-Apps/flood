class ContextMetadata {
  final BuildType buildType;

  const ContextMetadata({required this.buildType});
}

enum BuildType {
  debug,
  release,
}
