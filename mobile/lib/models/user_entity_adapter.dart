import 'package:hive/hive.dart';

import 'user_entity.dart';

class UserEntityAdapter extends TypeAdapter<UserEntity> {
  static const int kTypeId = 1;

  @override
  final int typeId = kTypeId;

  @override
  UserEntity read(BinaryReader reader) {
    final fieldCount = reader.readByte();
    final fields = <int, dynamic>{
      for (var i = 0; i < fieldCount; i++) reader.readByte(): reader.read(),
    };

    return UserEntity(
      id: fields[0] as int,
      name: fields[1] as String,
      username: fields[2] as String,
      email: fields[3] as String,
      phone: fields[4] as String,
      website: fields[5] as String,
      companyName: fields[6] as String,
      city: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserEntity obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.username)
      ..writeByte(3)
      ..write(obj.email)
      ..writeByte(4)
      ..write(obj.phone)
      ..writeByte(5)
      ..write(obj.website)
      ..writeByte(6)
      ..write(obj.companyName)
      ..writeByte(7)
      ..write(obj.city);
  }
}
