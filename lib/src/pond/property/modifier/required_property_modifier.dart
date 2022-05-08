import 'package:jlogical_utils/src/pond/property/modifier/property_modifier.dart';

import '../../../patterns/export_core.dart';

class RequiredPropertyModifier<T> extends PropertyModifier<T> {
  @override
  SyncValidator? get validator => Validator.required().syncMap((_) => context.property.getUnvalidated());
}
