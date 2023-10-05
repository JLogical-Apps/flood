class AppwritePlatform {
  final String id;
  final String name;
  final String type;
  final String key;

  AppwritePlatform({
    required this.id,
    required this.name,
    required this.type,
    required this.key,
  });

  @override
  String toString() {
    return 'AppwritePlatform{id: $id, name: $name, type: $type, key: $key}';
  }
}
