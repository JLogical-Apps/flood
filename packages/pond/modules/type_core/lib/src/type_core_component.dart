import 'package:pond_core/pond_core.dart';
import 'package:type/type.dart';

class TypeCoreComponent extends CorePondComponent with IsTypeContextWrapper {
  @override
  late final TypeContext typeContext = TypeContext();
}
