import 'package:path_core/path_core.dart';
import 'package:pond/src/app/page/vrouter_segment_modifier.dart';

class StringVRouterSegmentModifier extends VRouterSegmentModifier<StringPathDefinitionSegment> {
  @override
  String getVRouterSegment(StringPathDefinitionSegment segment) {
    return segment.segment;
  }
}
