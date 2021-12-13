import 'package:jlogical_utils/src/pond/export.dart';

class LuckyNumbers extends ValueObject {
  late final luckyNumbersProperty = ListFieldProperty<int>(name: 'luckyNumbers');

  List<Property> get properties => [luckyNumbersProperty];
}
