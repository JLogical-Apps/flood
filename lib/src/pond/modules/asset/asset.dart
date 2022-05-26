abstract class Asset<T> {
  final String id;
  final T value;

  const Asset({required this.id, required this.value});
}
