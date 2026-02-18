abstract class StorageService<T, K> {
  Future<void> init();

  Future<List<T>> readAll();

  Future<void> writeAll(List<T> values);

  Future<void> write(K key, T value);

  Future<void> delete(K key);

  Future<void> clear();
}
