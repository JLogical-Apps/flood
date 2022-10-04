class ContextMetadata {
  final BuildType buildType;
  final BuildTarget buildTarget;

  const ContextMetadata({required this.buildType, required this.buildTarget});

  bool get isWeb => buildTarget == BuildTarget.web;
}

enum BuildType {
  debug,
  release,
}

enum BuildTarget {
  mobile,
  web,

  /// This is for neither mobile nor web.
  standalone,
}
