import 'package:hive/hive.dart';
import 'package:snozzy/models/SharedItem.dart';

part 'TextItem.g.dart';

@HiveType(typeId: 3)
class TextItem extends SharedItem {
  static final int MAX_NUMBER_OF_CHARS_IN_DESCRIPTION = 50;

  @HiveField(4)
  late String text;

  TextItem(this.text) : super.normal(null, null);

  TextItem.normal(String value)
      : super.normal(DateTime.now(), SharedItemType.TEXT) {
    text = value;
    if(text.length < MAX_NUMBER_OF_CHARS_IN_DESCRIPTION)
      title = text;
    else
      title = limitedText;
    searchableText += title;
  }

  String get limitedText {
    String description = '';
    for (int i = 0;
        i < MAX_NUMBER_OF_CHARS_IN_DESCRIPTION - 3 && i < text.length;
        i++) description += text[i];
    description += '...';
    return description;
  }
}
