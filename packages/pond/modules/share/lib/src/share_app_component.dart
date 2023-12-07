import 'package:clipboard/clipboard.dart';
import 'package:environment/environment.dart';
import 'package:flutter/cupertino.dart';
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
}
