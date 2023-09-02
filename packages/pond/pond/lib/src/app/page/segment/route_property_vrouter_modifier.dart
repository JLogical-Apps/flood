import 'package:path_core/path_core.dart';
import 'package:pond/src/app/page/vrouter_segment_modifier.dart';

class RoutePropertyVRouterSegmentModifier extends VRouterSegmentModifier<RoutePropertyPathDefinitionSegment> {
  @override
  String getVRouterSegment(RoutePropertyPathDefinitionSegment segment) {
    return ':${segment.property.name}';
  }
}
