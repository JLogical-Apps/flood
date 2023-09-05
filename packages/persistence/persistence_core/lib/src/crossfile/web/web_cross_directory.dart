import 'package:persistence_core/src/crossfile/cross_directory.dart';
import 'package:persistence_core/src/crossfile/cross_element.dart';
import 'package:persistence_core/src/crossfile/cross_file.dart';
import 'package:persistence_core/src/crossfile/web/web_cross_context.dart';
import 'package:persistence_core/src/crossfile/web/web_cross_file.dart';
import 'package:utils_core/utils_core.dart';

class WebCrossDirectory with IsCrossDirectory {
  @override
  final String path;

  WebCrossDirectory({required this.path});

  @override
  Future<void> create() async {}

  @override
  Future<void> delete() async {
    final elements = await list();
    for (final element in elements) {
      if (element is CrossFile) {
        await element.delete();
      } else if (element is CrossDirectory) {
        await element.delete();
      }
    }
  }

  @override
  Future<bool> exists() async {
    final elements = await listOrNull();
    return elements != null && elements.isNotEmpty;
  }

  @override
  CrossDirectory getDirectory(String path) {
    return WebCrossDirectory(path: '${this.path}/$path');
  }

  @override
  CrossFile getFile(String path) {
    return WebCrossFile(path: '${this.path}/$path');
  }

  @override
  Future<List<CrossElement>?> listOrNull() async {
    final root = await WebCrossContext.global.getRoot();

    return _findElements(root);
  }

  @override
  Stream<List<CrossElement>?> listX() {
    return WebCrossContext.global.getRootX().map((root) => _findElements(root));
  }

  Map<String, dynamic>? _findMap(Map<String, dynamic> root) {
    Map<String, dynamic>? map = root;
    for (final segment in path.split('/')) {
      map = map![segment];
      if (map == null) {
        return null;
      }
    }

    return map;
  }

  List<CrossElement>? _findElements(Map<String, dynamic> root) {
    final directoryRoot = _findMap(root);
    if (directoryRoot == null) {
      return null;
    }

    return directoryRoot.mapToIterable((key, content) {
      if (content is String) {
        return WebCrossFile(path: '$path/$key');
      } else if (content is Map) {
        return WebCrossDirectory(path: '$path/$key');
      }

      throw Exception('Unable to determine type of file in [$content]');
    }).toList();
  }
}
