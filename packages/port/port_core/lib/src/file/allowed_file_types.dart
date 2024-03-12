abstract class AllowedFileTypes {
  static AllowedFileTypes get any => AnyAllowedFileTypes();

  static AllowedFileTypes get image => ImageAllowedFileTypes();

  static AllowedFileTypes get audio => AudioAllowedFileTypes();

  static AllowedFileTypes get video => VideoAllowedFileTypes();

  static AllowedFileTypes custom(List<String> allowedFileTypes) =>
      CustomAllowedFileTypes(allowedFileTypes: allowedFileTypes);
}

class AnyAllowedFileTypes implements AllowedFileTypes {}

class ImageAllowedFileTypes implements AllowedFileTypes {}

class AudioAllowedFileTypes implements AllowedFileTypes {}

class VideoAllowedFileTypes implements AllowedFileTypes {}

class CustomAllowedFileTypes implements AllowedFileTypes {
  final List<String> allowedFileTypes;

  CustomAllowedFileTypes({required this.allowedFileTypes});
}
