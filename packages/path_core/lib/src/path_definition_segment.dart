abstract class PathDefinitionSegment {
  bool matches(String segment);
}

mixin IsPathDefinitionSegment implements PathDefinitionSegment {}
