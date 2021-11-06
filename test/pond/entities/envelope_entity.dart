import 'package:jlogical_utils/src/pond/export.dart';

import 'envelope.dart';

class EnvelopeEntity extends Entity<Envelope> {
  EnvelopeEntity({required Envelope initialEnvelope}) : super(initialState: initialEnvelope);

  void changeName(String newName) {
    state = state.withNameChanged(newName);
  }
}
