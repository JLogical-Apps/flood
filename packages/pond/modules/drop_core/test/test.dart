void main() {
  final r = AllQueryRequest<MyEntity>();
  print(r is AllQueryRequest);
}

class MyEntity {}

abstract class QueryRequest<E, T> {}

class AllQueryRequest<E> extends QueryRequest<E, List<E>> {}
