import 'package:jlogical_utils/jlogical_utils.dart';

class User extends ValueObject {
  late final nameProperty = field<String>(name: 'name').required();

  @override
  List<ValueObjectBehavior> get behaviors => [nameProperty];
}
