import 'package:hive/hive.dart';
import 'package:metadata_fetch/metadata_fetch.dart';

import 'SharedItem.dart';

part 'LinkItem.g.dart';

@HiveType(typeId: 2)
class LinkItem extends SharedItem {
  @HiveField(4)
  late String url;
  @HiveField(5)
  late String websiteUrl;
  @HiveField(6)
  String? description;
  @HiveField(7)
  String? imageUrl;
  @HiveField(8)
  bool isMetaDataFetched = false;

  LinkItem(this.url, this.websiteUrl, this.description)
      : super.normal(null, null);

  LinkItem.normal(String value)
      : super.normal(DateTime.now(), SharedItemType.LINK) {
    url = value;
    title = "Link " + getFormatedTimeShared();
    isMetaDataFetched = false;
    websiteUrl = value;

    getMetaData(url);
  }

  Future<void> getMetaData(String url) async {
    MetadataFetch.extract(url).then((value) {
      if (value == null) return;

      if (value.description == null)
        description = websiteUrl;
      else
        description = value.description!;
      if (value.title != null) title = value.title!;
      if (value.url != null) websiteUrl = value.url!;

      imageUrl = value.image;

      searchableText += websiteUrl + description!;

      this.save().then((value) => isMetaDataFetched = true);
    });
  }
}
