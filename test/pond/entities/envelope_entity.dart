import 'package:jlogical_utils/src/pond/export.dart';

import 'envelope.dart';

class EnvelopeEntity extends Entity<Envelope> {
  void changeName(String newName) {
    value = value.copyWith(name: newName);
  }

  void changeAmount(int newAmount) {
    value = value.copyWith(amount: newAmount);
  }
}
