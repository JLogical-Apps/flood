import 'dart:io';

import 'package:jlogical_utils/src/persistence/data_source/data_source.dart';
import 'package:jlogical_utils/src/persistence/data_source/with_file_data_source.dart';

/// Data source that points to a file.
/// The contents of the file is the persisted data.
class FileDataSource extends DataSource<String> with WithFileDataSource {
  /// The file this is pointing to.
  final File file;

  FileDataSource({required this.file});
}
