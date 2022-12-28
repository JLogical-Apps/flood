import 'package:path_core/path_core.dart';
import 'package:pond/src/app/page/go_router_segment_wrapper.dart';

class StringGoRouterSegmentWrapper extends GoRouterSegmentWrapper<StringPathDefinitionSegment> {
  @override
  String getGoRouteSegment(StringPathDefinitionSegment segment) {
    return segment.segment;
  }
}
