import 'dart:typed_data';

import 'package:clipboard/clipboard.dart';
import 'package:environment/environment.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/cupertino.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';
import 'package:pond/pond.dart';
import 'package:share_plus/share_plus.dart';
import 'package:style/style.dart';

class ShareAppComponent with IsAppPondComponent {
  Future<void> shareText(BuildContext context, {required String text}) async {
    if (context.appPondContext.environmentCoreComponent.platform == Platform.web) {
      await FlutterClipboard.copy(text);
      await context.showStyledMessage(StyledMessage(labelText: 'Copied to clipboard!'));
      return;
    }

    final box = context.findRenderObject() as RenderBox?;
    await Share.share(
      text,
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );
  }

  Future<void> shareFile(
    BuildContext context, {
    String? text,
    String? subject,
    required String fileName,
    required Uint8List fileBytes,
    String? mimeType,
  }) async {
    mimeType ??= lookupMimeType(fileName, headerBytes: fileBytes.take(defaultMagicNumbersMaxLength).toList()) ??
        'application/octet-stream';

    if (context.corePondContext.platform == Platform.web) {
      await FileSaver.instance.saveFile(
        bytes: fileBytes,
        name: basenameWithoutExtension(fileName),
        ext: extension(fileName),
        customMimeType: mimeType,
      );
      return;
    }

    final size = MediaQuery.of(context).size;
    await Share.shareXFiles(
      [XFile.fromData(fileBytes, name: fileName, mimeType: mimeType)],
      text: text,
      subject: subject,
      sharePositionOrigin: Rect.fromLTWH(0, 0, size.width, size.height / 2),
    );
  }
}

extension ShareBuildContextExtensions on BuildContext {
  ShareAppComponent get shareAppComponent => find<ShareAppComponent>();
}

extension ShareAppContextExtensions on AppPondContext {
  ShareAppComponent get shareAppComponent => find<ShareAppComponent>();
}
