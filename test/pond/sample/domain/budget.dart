import 'package:jlogical_utils/src/pond/export.dart';

import 'envelope.dart';

class Budget extends Entity {
  late final ListProperty<Envelope> envelopesProperty = ListProperty(name: 'envelopes');
}