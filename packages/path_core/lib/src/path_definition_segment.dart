abstract class PathDefinitionSegment {
  bool matches(String segment);

  void onMatch(String segment);
}

mixin IsPathDefinitionSegment implements PathDefinitionSegment {
  @override
  void onMatch(String segment) {}
}
