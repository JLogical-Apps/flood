import 'package:path_core/path_core.dart';
import 'package:pond/src/app/page/go_router_segment_wrapper.dart';

class RoutePropertyGoRouterSegmentWrapper extends GoRouterSegmentWrapper<RoutePropertyPathDefinitionSegment> {
  @override
  String getGoRouteSegment(RoutePropertyPathDefinitionSegment segment) {
    return ':${segment.property.name}';
  }
}
