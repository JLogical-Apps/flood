import 'dart:io';

import 'package:jlogical_utils/src/pond/context/directory/directory_provider.dart';

mixin WithDirectoryProviderDelegator implements DirectoryProvider {
  DirectoryProvider get directoryProvider;

  Directory get supportDirectory => directoryProvider.supportDirectory;
}
