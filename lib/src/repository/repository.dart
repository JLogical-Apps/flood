import 'package:jlogical_utils/jlogical_utils.dart';

/// A repository is a special service that creates, reads, updates, and deletes data.
/// Some repositories do not have the capabilities to implement all the methods and may throw [UnimplementedError].
/// [T] is the type of object this repository gets.
/// [R] is the type of id associated with each object.
abstract class Repository<T, R> {
  /// Generates and returns a new id to use.
  Future<R> generateId();

  /// Creates a new object in the repository and returns its id.
  Future<R> create(T object);

  /// Returns the object in the repository with the [id], or null if not found.
  Future<T?> get(R id);

  /// Saves [object] with [id] in the repository.
  /// If the [id] is not in the repository yet, the save will be treated like [create].
  Future<void> save(R id, T object);

  /// Deletes the object with [id] from the repository.
  Future<void> delete(R id);

  /// Returns a paginated list of all the entries in the repository.
  Future<PaginationResult<T>> getAll();
}
