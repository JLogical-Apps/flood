import 'package:path_core/path_core.dart';
import 'package:pond/src/app/page/app_page.dart';
import 'package:pond/src/app/page/segment/route_property_vrouter_modifier.dart';
import 'package:pond/src/app/page/segment/string_vrouter_segment_modifier.dart';
import 'package:utils/utils.dart';

abstract class VRouterSegmentModifier<T extends PathDefinitionSegment> with IsTypedModifier<T, PathDefinitionSegment> {
  String getVRouterSegment(T segment);

  static ModifierResolver<VRouterSegmentModifier, PathDefinitionSegment> resolver = ModifierResolver(modifiers: [
    RoutePropertyVRouterSegmentModifier(),
    StringVRouterSegmentModifier(),
  ]);

  static String getVRouterPath(AppPage page) {
    return '/${page.segments.map((segment) => getModifierOrNull(segment)?.getVRouterSegment(segment)).whereNonNull().join('/')}';
  }

  static VRouterSegmentModifier? getModifierOrNull(PathDefinitionSegment segment) {
    return resolver.resolveOrNull(segment);
  }
}
