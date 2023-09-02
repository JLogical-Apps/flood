abstract class AutomatePathDefinitionSegment {
  bool matches(String segment);

  void onMatch(String segment);

  String toSegmentPart();
}

mixin IsAutomatePathDefinitionSegment implements AutomatePathDefinitionSegment {
  @override
  void onMatch(String segment) {}
}
