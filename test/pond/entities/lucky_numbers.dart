import 'package:jlogical_utils/src/pond/export.dart';

class LuckyNumbers extends Entity {
  late final ListProperty<int> luckyNumbers = ListProperty(name: 'luckyNumbers');

  List<Property> get properties => [luckyNumbers];
}
