import 'package:collection/collection.dart';
import 'package:localstorage/localstorage.dart';
import 'package:rxdart/rxdart.dart';

class WebCrossContext {
  static WebCrossContext global = WebCrossContext._();

  WebCrossContext._();

  LocalStorage? _localStorage;

  final BehaviorSubject<Map<String, dynamic>> _rootX = BehaviorSubject.seeded({});

  Future<Map<String, dynamic>> getRoot() async {
    final localStorage = await _initLocalStorage();

    final root = localStorage.getItem('items') as Map<String, dynamic>? ?? {};

    if (!DeepCollectionEquality().equals(root, _rootX.value)) {
      _rootX.value = root;
    }
    return root;
  }

  Stream<Map<String, dynamic>> getRootX() async* {
    await _initLocalStorage();
    yield* _rootX;
  }

  Future<void> updateRoot(Map<String, dynamic> root) async {
    final localStorage = await _initLocalStorage();

    await localStorage.setItem('items', root);

    _rootX.value = root;
  }

  Future<LocalStorage> _initLocalStorage() async {
    if (_localStorage != null) {
      return _localStorage!;
    }

    _localStorage = LocalStorage('persistence_core');
    await _localStorage!.ready;

    await getRoot();

    return _localStorage!;
  }
}
