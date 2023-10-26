abstract class PathDefinitionSegment {
  bool matches(String segment);

  void onMatch(String segment);

  String get segmentPart;

  String get templatePart;
}

mixin IsPathDefinitionSegment implements PathDefinitionSegment {
  @override
  void onMatch(String segment) {}
}
