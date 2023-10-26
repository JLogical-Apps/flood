import 'dart:io';

import 'package:utils_core/src/extensions/file_extensions.dart';

Directory get homeDirectory => Directory(Platform.isLinux || Platform.isMacOS
    ? Platform.environment['HOME'] ?? (throw StateError('HOME not defined in environment.'))
    : Platform.isWindows
        ? Platform.environment['USERPROFILE'] ?? (throw StateError('USERPROFILE not defined in environment.'))
        : Platform.isAndroid
            ? '/sdcard'
            : throw UnsupportedError('userHome is not supported on ${Platform.operatingSystem}.'));

Directory get sshDirectory => homeDirectory / '.ssh';
