import 'package:jlogical_utils/src/pond/export.dart';

class LuckyNumbers extends ValueObject {
  late final ListFieldProperty<int> luckyNumbersProperty = ListFieldProperty(name: 'luckyNumbers');

  List<Property> get properties => [luckyNumbersProperty];
}
