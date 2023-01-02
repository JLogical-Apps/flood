import 'package:path_core/path_core.dart';
import 'package:pond/src/app/page/vrouter_segment_wrapper.dart';

class StringVRouterSegmentWrapper extends VRouterSegmentWrapper<StringPathDefinitionSegment> {
  @override
  String getVRouterSegment(StringPathDefinitionSegment segment) {
    return segment.segment;
  }
}
