import 'package:path_core/path_core.dart';
import 'package:pond/src/app/page/vrouter_segment_wrapper.dart';

class StringGoRouterSegmentWrapper extends VRouterSegmentWrapper<StringPathDefinitionSegment> {
  @override
  String getGoRouteSegment(StringPathDefinitionSegment segment) {
    return segment.segment;
  }
}
