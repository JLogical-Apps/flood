import 'package:path_core/path_core.dart';
import 'package:pond/src/app/page/vrouter_segment_wrapper.dart';

class RoutePropertyGoRouterSegmentWrapper extends VRouterSegmentWrapper<RoutePropertyPathDefinitionSegment> {
  @override
  String getGoRouteSegment(RoutePropertyPathDefinitionSegment segment) {
    return ':${segment.property.name}';
  }
}
