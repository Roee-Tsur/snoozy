import 'dart:io';

import 'package:hive/hive.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:video_player/video_player.dart';

import 'SharedItem.dart';

part 'VideoItem.g.dart';

@HiveType(typeId: 5)
class VideoItem extends SharedItem {
  @HiveField(4)
  late String path;
  @HiveField(5)
  late String thumbnail;
  @HiveField(6)
  late int duration;

  VideoItem(this.path, this.thumbnail, this.duration)
      : super.normal(null, null);

  VideoItem.normal(SharedMediaFile value)
      : super.normal(DateTime.now(), SharedItemType.VIDEO) {
    thumbnail = value.thumbnail!;
    path = value.path;
    duration = value.duration! ~/ 1000;
    title = 'Video ' + getFormatedTimeShared();
    searchableText += duration.toString();
  }

  VideoItem.fab(String path)
      : super.normal(DateTime.now(), SharedItemType.VIDEO) {
    VideoPlayerController controller = VideoPlayerController.file(File(path));
    this.path = path;
    duration = controller.value.duration.inMilliseconds ~/ 1000;
    title = 'Video ' + getFormatedTimeShared();
  }

  String getFormatedDuration() {
    int minute, second;
    String str = '';

    minute = duration ~/ 60;
    if (minute < 10) str = '0';
    str += minute.toString() + ':';

    second = (duration % 60);
    if (second < 10) str += '0';
    str += second.toString();
    return str;
  }
}
