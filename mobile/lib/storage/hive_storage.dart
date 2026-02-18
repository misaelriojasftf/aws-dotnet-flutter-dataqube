import 'package:hive_flutter/hive_flutter.dart';

import '../models/user_entity.dart';
import 'storage_service.dart';

class HiveStorage implements StorageService<UserEntity, int> {
  HiveStorage({this.boxName = kDefaultBoxName});

  static const String kDefaultBoxName = 'users_box';
  final String boxName;
  Box<UserEntity>? _box;

  @override
  Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox<UserEntity>(boxName);
  }

  Future<Box<UserEntity>> _ensureBox() async {
    if (_box != null && _box!.isOpen) {
      return _box!;
    }

    if (Hive.isBoxOpen(boxName)) {
      _box = Hive.box<UserEntity>(boxName);
      return _box!;
    }

    await init();
    return _box!;
  }

  @override
  Future<List<UserEntity>> readAll() async {
    final box = await _ensureBox();
    return box.values.toList(growable: false);
  }

  @override
  Future<void> writeAll(List<UserEntity> values) async {
    final box = await _ensureBox();
    await box.clear();
    final keyedValues = <int, UserEntity>{
      for (final user in values) user.id: user,
    };
    await box.putAll(keyedValues);
  }

  @override
  Future<void> write(int key, UserEntity value) async {
    final box = await _ensureBox();
    await box.put(key, value);
  }

  @override
  Future<void> delete(int key) async {
    final box = await _ensureBox();
    await box.delete(key);
  }

  @override
  Future<void> clear() async {
    final box = await _ensureBox();
    await box.clear();
  }
}
