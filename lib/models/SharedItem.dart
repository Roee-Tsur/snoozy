import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:snozzy/ItemViewers/FileViewerWidget.dart';
import 'package:snozzy/ItemViewers/ImageViewerWidget.dart';
import 'package:snozzy/ItemViewers/LinkViewerWidget.dart';
import 'package:snozzy/ItemViewers/TextViewerWidget.dart';
import 'package:snozzy/ItemViewers/VideoViewerWidget.dart';
import 'package:snozzy/services/Analytics.dart';
import 'package:snozzy/services/Notifications.dart';

import 'FileItem.dart';
import 'ImageItem.dart';
import 'LinkItem.dart';
import 'TextItem.dart';
import 'VideoItem.dart';

part 'SharedItem.g.dart';

@HiveType(typeId: 0)
class SharedItem extends HiveObject {
  @HiveField(0)
  late String id;
  @HiveField(1)
  late String title;
  @HiveField(2)
  late SharedItemType type;
  @HiveField(3)
  late DateTime timeShared;
  @HiveField(10)
  late DateTime reminderTime;
  @HiveField(11)
  DateTime? enteredHistoryTime;
  @HiveField(12)
  late bool wasViewed;
  @HiveField(13)
  late String searchableText;
  @HiveField(14)
  late int notificationId;

  SharedItem();

  SharedItem.normal(DateTime? timeShared, SharedItemType? type) {
    if (timeShared == null || type == null) return;
    this.timeShared = timeShared;
    this.type = type;
    this.reminderTime = DateTime.now();
    this.id = UniqueKey().toString();
    this.notificationId = Random().nextInt(10000000);
    wasViewed = false;
    searchableText = '';
    searchableText += '' + typeToText() + /*title +*/ getFormatedTimeShared();
  }

  static int compareHistoryList(first, second) {
    if (first.enteredHistoryTime == null ||
        first.enteredHistoryTime.isAfter(second.enteredHistoryTime)) return -1;
    return 1;
  }

  static int compareMainList(first, second) {
    DateTime now = DateTime.now();
    if (first.reminderTime == null) first.reminderTime = now;
    if (second.reminderTime == null) second.reminderTime = now;
    if (first.reminderTime.isAfter(now) && second.reminderTime.isAfter(now)) {
      if (first.reminderTime.isBefore(second.reminderTime)) return -1;
      return 1;
    }

    if (first.reminderTime.isAfter(now)) return -1;
    if (second.reminderTime.isAfter(now)) return 1;

    if (first.timeShared.isBefore(second.timeShared)) return 1;
    return -1;
  }

  String getFormatedTimeShared() {
    return 'shared at ' +
        timeShared.day.toString() +
        '/' +
        timeShared.month.toString() +
        '/' +
        timeShared.year.toString() +
        ' ' +
        timeShared.hour.toString() +
        ':' +
        (timeShared.minute < 10 ? '0' : '') +
        timeShared.minute.toString();
  }

  String typeToText() {
    return type.toString().toLowerCase().split('.')[1];
  }

  Icon getIconWidget() {
    switch (type) {
      case SharedItemType.VIDEO:
        return Icon(Icons.ondemand_video_outlined);
      case SharedItemType.IMAGE:
        return Icon(Icons.image);
      case SharedItemType.FILE:
        return Icon(Icons.insert_drive_file);
      case SharedItemType.TEXT:
        return Icon(Icons.text_fields);
      case SharedItemType.LINK:
        return Icon(Icons.link);
    }
  }

  void setReminderTime(DateTime? newTime) {
    print('setReminderTime: $newTime');
    if (newTime == null)
      this.reminderTime = DateTime.now();
    else
      this.reminderTime = newTime;
    this.save();
    setNotification();
  }

  void setNotification() {
    Notifications.scheduleNotification(
        notificationId,
        'Snozzed - view your ' + typeToText() + ' !',
        "Click to view $title",
        this.id,
        reminderTime);
  }

  setNewTitle(String text) {
    Analytics.editItemTitle(typeToText(), title, text);
    title = text;
    save();
  }

  static getContentWidget(SharedItem sharedItem, BuildContext context) {
    switch (sharedItem.type) {
      case SharedItemType.VIDEO:
        return VideoViewerWidget(sharedItem as VideoItem);
      case SharedItemType.IMAGE:
        return ImageViewerWidget(sharedItem as ImageItem);
      case SharedItemType.FILE:
        return FileViewerWidget(sharedItem as FileItem, context);
      case SharedItemType.TEXT:
        return TextViewerWidget(sharedItem as TextItem);
      case SharedItemType.LINK:
        return LinkViewerWidget(sharedItem as LinkItem);
    }
  }
}

@HiveType(typeId: 1)
enum SharedItemType {
  @HiveField(0)
  VIDEO,
  @HiveField(1)
  IMAGE,
  @HiveField(2)
  FILE,
  @HiveField(3)
  TEXT,
  @HiveField(4)
  LINK
}
