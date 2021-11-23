abstract class Synchronizable<L> {
  Future<void> lock(L lock);

  void unlock(L lock);
}