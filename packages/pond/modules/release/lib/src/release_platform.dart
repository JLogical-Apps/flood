abstract class ReleasePlatform {
  String get name;

  static final ReleasePlatform android = AndroidReleasePlatform();
  static final ReleasePlatform ios = IosReleasePlatform();
  static final ReleasePlatform web = WebReleasePlatform();
}

class AndroidReleasePlatform implements ReleasePlatform {
  @override
  String get name => 'android';
}

class IosReleasePlatform implements ReleasePlatform {
  @override
  String get name => 'ios';
}

class WebReleasePlatform implements ReleasePlatform {
  @override
  String get name => 'web';
}
