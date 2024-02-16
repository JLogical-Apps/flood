import 'package:release/release.dart';

class ReleaseContext {
  final List<ReleasePlatform> platforms;
  final bool isDebug;

  const ReleaseContext({required this.platforms, this.isDebug = false});
}
