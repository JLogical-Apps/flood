import 'package:flood_core/flood_core.dart';

class PublicSettings extends ValueObject {
  static const minVersionField = 'minVersion';
  late final minVersionProperty = field<String>(name: minVersionField);

  @override
  List<ValueObjectBehavior> get behaviors => [minVersionProperty];
}
