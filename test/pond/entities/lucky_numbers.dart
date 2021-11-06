import 'package:jlogical_utils/src/pond/export.dart';

class LuckyNumbers extends ValueObject {
  late final ListProperty<int> luckyNumbersProperty = ListProperty(name: 'luckyNumbers');

  List<Property> get properties => [luckyNumbersProperty];
}
