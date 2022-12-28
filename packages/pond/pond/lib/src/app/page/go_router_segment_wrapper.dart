import 'package:path_core/path_core.dart';
import 'package:pond/src/app/page/app_page.dart';
import 'package:pond/src/app/page/segment/route_property_go_router_segment.dart';
import 'package:pond/src/app/page/segment/string_go_router_segment_wrapper.dart';
import 'package:utils/utils.dart';

abstract class GoRouterSegmentWrapper<T extends PathDefinitionSegment> with IsTypedWrapper<T, PathDefinitionSegment> {
  String getGoRouteSegment(T segment);

  static WrapperResolver<GoRouterSegmentWrapper, PathDefinitionSegment> resolver = WrapperResolver(wrappers: [
    RoutePropertyGoRouterSegmentWrapper(),
    StringGoRouterSegmentWrapper(),
  ]);

  static String getGoRoutePath(AppPage page) {
    return '/${page.segments.map((segment) => getWrapperOrNull(segment)?.getGoRouteSegment(segment)).whereNonNull().join('/')}';
  }

  static GoRouterSegmentWrapper? getWrapperOrNull(PathDefinitionSegment segment) {
    return resolver.resolveOrNull(segment);
  }
}
