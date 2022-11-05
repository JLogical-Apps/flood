import 'package:pond_core/pond_core.dart';
import 'package:type/type.dart';

class TypeCoreComponent extends CorePondComponent with WithTypeContextWrapper {
  @override
  late final TypeContext typeContext = TypeContext();
}
