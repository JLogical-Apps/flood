import 'dart:io';

import 'package:jlogical_utils/src/pond/record/entity.dart';
import 'package:jlogical_utils/src/pond/record/value_object.dart';

import 'default_file_repository.dart';

class SimpleFileRepository<E extends Entity<V>, V extends ValueObject> extends DefaultFileRepository<E, V> {
  @override
  final Directory baseDirectory;

  final E Function() onCreateEntity;
  final V Function() onCreateValueObject;

  SimpleFileRepository({required this.baseDirectory, required this.onCreateEntity, required this.onCreateValueObject});

  @override
  E createEntity() => onCreateEntity();

  @override
  V createValueObject() => onCreateValueObject();
}
