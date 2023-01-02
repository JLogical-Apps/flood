import 'package:path_core/path_core.dart';
import 'package:pond/src/app/page/app_page.dart';
import 'package:pond/src/app/page/segment/route_property_vrouter_segment.dart';
import 'package:pond/src/app/page/segment/string_vrouter_segment_wrapper.dart';
import 'package:utils/utils.dart';

abstract class VRouterSegmentWrapper<T extends PathDefinitionSegment> with IsTypedWrapper<T, PathDefinitionSegment> {
  String getVRouterSegment(T segment);

  static WrapperResolver<VRouterSegmentWrapper, PathDefinitionSegment> resolver = WrapperResolver(wrappers: [
    RoutePropertyVRouterSegmentWrapper(),
    StringVRouterSegmentWrapper(),
  ]);

  static String getVRouterPath(AppPage page) {
    return '/${page.segments.map((segment) => getWrapperOrNull(segment)?.getVRouterSegment(segment)).whereNonNull().join('/')}';
  }

  static VRouterSegmentWrapper? getWrapperOrNull(PathDefinitionSegment segment) {
    return resolver.resolveOrNull(segment);
  }
}
