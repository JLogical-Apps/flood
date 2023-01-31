import 'package:jlogical_utils_core/jlogical_utils_core.dart';

class User extends ValueObject {
  late final nameProperty = field<String>(name: 'name').required();

  @override
  List<ValueObjectBehavior> get behaviors => [nameProperty];
}
