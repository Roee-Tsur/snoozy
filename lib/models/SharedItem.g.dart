// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SharedItem.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SharedItemAdapter extends TypeAdapter<SharedItem> {
  @override
  final int typeId = 0;

  @override
  SharedItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SharedItem()
      ..id = fields[0] as String
      ..title = fields[1] as String
      ..type = fields[2] as SharedItemType
      ..timeShared = fields[3] as DateTime
      ..reminderTime = fields[10] as DateTime
      ..enteredHistoryTime = fields[11] as DateTime?
      ..wasViewed = fields[12] as bool
      ..searchableText = fields[13] as String
      ..notificationId = fields[14] as int;
  }

  @override
  void write(BinaryWriter writer, SharedItem obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.timeShared)
      ..writeByte(10)
      ..write(obj.reminderTime)
      ..writeByte(11)
      ..write(obj.enteredHistoryTime)
      ..writeByte(12)
      ..write(obj.wasViewed)
      ..writeByte(13)
      ..write(obj.searchableText)
      ..writeByte(14)
      ..write(obj.notificationId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SharedItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SharedItemTypeAdapter extends TypeAdapter<SharedItemType> {
  @override
  final int typeId = 1;

  @override
  SharedItemType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SharedItemType.VIDEO;
      case 1:
        return SharedItemType.IMAGE;
      case 2:
        return SharedItemType.FILE;
      case 3:
        return SharedItemType.TEXT;
      case 4:
        return SharedItemType.LINK;
      default:
        return SharedItemType.VIDEO;
    }
  }

  @override
  void write(BinaryWriter writer, SharedItemType obj) {
    switch (obj) {
      case SharedItemType.VIDEO:
        writer.writeByte(0);
        break;
      case SharedItemType.IMAGE:
        writer.writeByte(1);
        break;
      case SharedItemType.FILE:
        writer.writeByte(2);
        break;
      case SharedItemType.TEXT:
        writer.writeByte(3);
        break;
      case SharedItemType.LINK:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SharedItemTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
