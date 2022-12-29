import 'package:path_core/path_core.dart';
import 'package:pond/src/app/page/app_page.dart';
import 'package:pond/src/app/page/segment/route_property_go_router_segment.dart';
import 'package:pond/src/app/page/segment/string_go_router_segment_wrapper.dart';
import 'package:utils/utils.dart';

abstract class VRouterSegmentWrapper<T extends PathDefinitionSegment> with IsTypedWrapper<T, PathDefinitionSegment> {
  String getGoRouteSegment(T segment);

  static WrapperResolver<VRouterSegmentWrapper, PathDefinitionSegment> resolver = WrapperResolver(wrappers: [
    RoutePropertyGoRouterSegmentWrapper(),
    StringGoRouterSegmentWrapper(),
  ]);

  static String getVRouterPath(AppPage page) {
    return '/${page.segments.map((segment) => getWrapperOrNull(segment)?.getGoRouteSegment(segment)).whereNonNull().join('/')}';
  }

  static VRouterSegmentWrapper? getWrapperOrNull(PathDefinitionSegment segment) {
    return resolver.resolveOrNull(segment);
  }
}
