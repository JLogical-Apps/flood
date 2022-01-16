import 'dart:io';

import 'package:jlogical_utils/jlogical_utils.dart';

import 'envelope.dart';
import 'envelope_entity.dart';

class FileEnvelopeRepository extends DefaultAdaptingRepository<EnvelopeEntity, Envelope> {
  @override
  final Directory baseDirectory;

  FileEnvelopeRepository({required this.baseDirectory});

  @override
  EnvelopeEntity createEntity() {
    return EnvelopeEntity();
  }

  @override
  Envelope createValueObject() {
    return Envelope();
  }
}
