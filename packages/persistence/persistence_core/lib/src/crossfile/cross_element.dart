abstract class CrossElement {
  String get path;

  Future<void> create();

  Future<bool> exists();

  Future<void> delete();
}

extension CrossElementExtensions on CrossElement {
  Future<void> ensureCreated() async {
    if (!await exists()) {
      await create();
    }
  }
}
