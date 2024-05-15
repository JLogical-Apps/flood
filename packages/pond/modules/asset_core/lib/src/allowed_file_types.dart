abstract class AllowedFileTypes {
  static final AllowedFileTypes any = AnyAllowedFileTypes();

  static final AllowedFileTypes image = ImageAllowedFileTypes();

  static final AllowedFileTypes audio = AudioAllowedFileTypes();

  static final AllowedFileTypes video = VideoAllowedFileTypes();

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
