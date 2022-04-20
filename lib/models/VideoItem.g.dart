// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'VideoItem.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VideoItemAdapter extends TypeAdapter<VideoItem> {
  @override
  final int typeId = 5;

  @override
  VideoItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VideoItem(
      fields[4] as String,
      fields[5] as String,
      fields[6] as int,
    )
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
  void write(BinaryWriter writer, VideoItem obj) {
    writer
      ..writeByte(12)
      ..writeByte(4)
      ..write(obj.path)
      ..writeByte(5)
      ..write(obj.thumbnail)
      ..writeByte(6)
      ..write(obj.duration)
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
      other is VideoItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
