import 'package:jlogical_utils/jlogical_utils.dart';

import 'envelope.dart';

class EnvelopeEntity extends Entity<Envelope> {
  void changeName(String newName) {
    value = value.copy()..nameProperty.value = newName;
  }

  void changeAmount(int newAmount) {
    value = value.copy()..amountProperty.value = newAmount;
  }
}