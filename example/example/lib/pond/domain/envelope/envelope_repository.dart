import 'dart:io';

import 'package:jlogical_utils/jlogical_utils.dart';

import 'envelope.dart';
import 'envelope_entity.dart';

class EnvelopeRepository extends DefaultAdaptingRepository<EnvelopeEntity, Envelope> {
  @override
  final Directory baseDirectory;

  String get collectionPath => 'envelopes';

  EnvelopeRepository({required this.baseDirectory});

  @override
  EnvelopeEntity createEntity() {
    return EnvelopeEntity();
  }

  @override
  Envelope createValueObject() {
    return Envelope();
  }
}
