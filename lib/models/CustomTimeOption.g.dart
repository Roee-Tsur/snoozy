// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CustomTimeOption.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CustomTimeOptionAdapter extends TypeAdapter<CustomTimeOption> {
  @override
  final int typeId = 8;

  @override
  CustomTimeOption read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CustomTimeOption(
      title: fields[1] as String,
      subTitle: fields[2] as String,
      hours: fields[3] as int,
      minutes: fields[4] as int,
    )..id = fields[0] as String;
  }

  @override
  void write(BinaryWriter writer, CustomTimeOption obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.subTitle)
      ..writeByte(3)
      ..write(obj.hours)
      ..writeByte(4)
      ..write(obj.minutes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomTimeOptionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
