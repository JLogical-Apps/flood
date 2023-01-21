import 'package:jlogical_utils/jlogical_utils.dart';

class Budget extends ValueObject {
  late final nameProperty = field<String>(name: 'name');

  @override
  List<ValueObjectBehavior> get behaviors => [nameProperty];
}
