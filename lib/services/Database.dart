import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snozzy/models/CustomTimeOption.dart';

import 'package:snozzy/models/FileItem.dart';
import 'package:snozzy/models/ImageItem.dart';
import 'package:snozzy/models/LinkItem.dart';
import 'package:snozzy/models/SharedItem.dart';
import 'package:snozzy/models/TextItem.dart';
import 'package:snozzy/models/VideoItem.dart';

import 'Analytics.dart';

class Database {
  static final String sharesList = 'sharesList';
  static final String historyList = 'historyList';
  static final String snoozedList = 'snoozedList';
  static final String timeOptionsList = 'timeOptionsList';

  static Duration? deleteFromHistoryDuration;

  static databaseInit() async {
    Hive.registerAdapter<FileItem>(FileItemAdapter());
    Hive.registerAdapter<ImageItem>(ImageItemAdapter());
    Hive.registerAdapter<VideoItem>(VideoItemAdapter());
    Hive.registerAdapter<TextItem>(TextItemAdapter());
    Hive.registerAdapter<LinkItem>(LinkItemAdapter());
    Hive.registerAdapter<SharedItem>(SharedItemAdapter());
    Hive.registerAdapter<SharedItemType>(SharedItemTypeAdapter());
    Hive.registerAdapter<CustomTimeOption>(CustomTimeOptionAdapter());

    await Hive.initFlutter();
    await Hive.openBox(Database.sharesList);
    await Hive.openBox(Database.snoozedList);
    await Hive.openBox(Database.historyList);
    await Hive.openBox<CustomTimeOption>(Database.timeOptionsList);

    updateHistoryList();
    //updateSnoozedList();
  }

  static void addSharedItem(String boxName, dynamic sharedItem) async {
    Hive.box(boxName).put(sharedItem.id, sharedItem);

    await SharedPreferences.getInstance().then((value) => value
            .containsKey('numberOfItemsCreated')
        ? value.setInt(
            'numberOfItemsCreated', value.getInt('numberOfItemsCreated')! + 1)
        : value.setInt('numberOfItemsCreated', 1));
  }

  static SharedItem getItemById(String boxName, String id) {
    return getItems(boxName)[id];
  }

  static List getAllItemsInBox(String boxName) {
    List list = Hive.box(boxName).values.toList();
    if (boxName == Database.historyList)
      list.sort(SharedItem.compareHistoryList);
    if (boxName == Database.sharesList) list.sort(SharedItem.compareMainList);
    return list;
  }

  static Map getItems(
    String boxName,
  ) {
    return Hive.box(boxName).toMap();
  }

  static dynamic getItemAt(String boxName, int index) {
    return Hive.box(boxName).getAt(index);
  }

  static Box getItemsBox(
    String boxName,
  ) {
    return Hive.box(boxName);
  }

  static void updateHistoryList() {
    if (deleteFromHistoryDuration == null) return;
    DateTime updatedTime = DateTime.now().subtract(deleteFromHistoryDuration!);
    for (SharedItem item in Database.getItems(Database.historyList).values) {
      if (item.enteredHistoryTime!.isAfter(updatedTime)) item.delete();
    }
  }

  static void updateSnoozedList() {
    for (SharedItem item in Database.getItems(Database.sharesList).values) {
      if (item.reminderTime == null ||
          item.reminderTime.isBefore(DateTime.now())) {
        item.delete();
        addSharedItem(Database.snoozedList, item);
      }
    }
  }

  static Future deleteAllHistory() async {
    Analytics.deleteAllItemFromHistory(Hive.box(historyList).length);
    await Hive.box(historyList).clear();
  }

  static void addTimeOption(CustomTimeOption timeOption) {
    Hive.box<CustomTimeOption>(timeOptionsList).put(timeOption.id, timeOption);
  }

  static List<CustomTimeOption> getTimeOptions() {
    return Hive.box<CustomTimeOption>(timeOptionsList).values.toList();
  }

  static void deleteTimeOption(String customTimeOptionId) {
    Hive.box<CustomTimeOption>(timeOptionsList).delete(customTimeOptionId);
  }
}
