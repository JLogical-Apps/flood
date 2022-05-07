import 'package:jlogical_utils/jlogical_utils.dart';

class LuckyNumbers extends ValueObject {
  late final luckyNumbersProperty = ListFieldProperty<int>(name: 'luckyNumbers');

  List<Property> get properties => [luckyNumbersProperty];
}
