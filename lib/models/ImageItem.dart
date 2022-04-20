import 'package:hive/hive.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:snozzy/models/SharedItem.dart';

part 'ImageItem.g.dart';

@HiveType(typeId: 4)
class ImageItem extends SharedItem {
  @HiveField(4)
  late String path;

  ImageItem(this.path) : super.normal(null, null);

  ImageItem.normal(SharedMediaFile value)
      : super.normal(DateTime.now(), SharedItemType.IMAGE) {
    path = value.path;
    title = 'Image ' + getFormatedTimeShared();
  }

  ImageItem.fab(String path)
      : super.normal(DateTime.now(), SharedItemType.IMAGE) {
    this.path = path;
    title = 'Image ' + getFormatedTimeShared();
  }
}
