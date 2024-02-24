import 'package:pond_cli/pond_cli.dart';
import 'package:release/src/release_context.dart';
import 'package:release/src/release_platforms/android_release_platform.dart';
import 'package:release/src/release_platforms/ios_release_platform.dart';
import 'package:release/src/release_platforms/web_release_platform.dart';

abstract class ReleasePlatform {
  String get name;
  String get title;

  Future onBuild(AutomateCommandContext context, ReleaseContext releaseContext);

  static final ReleasePlatform android = AndroidReleasePlatform();
  static final ReleasePlatform ios = IosReleasePlatform();
  static final ReleasePlatform web = WebReleasePlatform();
}
