import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:snozzy/CustomWidgets/NewTitleDialog.dart';
import 'package:snozzy/CustomWidgets/TimePickerDialog.dart' as TPD;
import 'package:snozzy/models/SharedItem.dart';
import 'package:snozzy/services/Analytics.dart';
import 'package:snozzy/services/Database.dart';

import '../Globals.dart';

class ItemWidget extends StatefulWidget {
  SharedItem? sharedItem;
  String title, subTitle;
  String? videoDuration;
  Image? imageWidget;
  String parentPage;
  State parentPageState;

  ItemWidget(this.parentPageState,
      {this.sharedItem,
      required this.title,
      required this.subTitle,
      this.videoDuration,
      this.imageWidget,
      required this.parentPage});

  @override
  _ItemWidgetState createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<ItemWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.sharedItem == null) return Container(width: 0.0, height: 0.0);

    SharedItem sharedItem = widget.sharedItem!;
    bool wasViewed = sharedItem.wasViewed;
    if (widget.parentPage == 'history') wasViewed = true;

    MediaQueryData mediaScreen = MediaQuery.of(context);
    double screenWidth = mediaScreen.orientation == Orientation.landscape
        ? mediaScreen.size.height
        : mediaScreen.size.width;

    return Wrap(children: [
      Container(
          width: screenWidth,
          child: Column(
            children: [
              widget.imageWidget == null
                  ? Container(
                      height: 0,
                      width: 0,
                    )
                  : Image(
                      image: widget.imageWidget!.image,
                      width: screenWidth,
                      height: 120,
                      fit: BoxFit.fitWidth,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          height: 120,
                          width: screenWidth,
                          child: Center(
                            child: SizedBox(
                              height: 8,
                              width: 8,
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        );
                      },
                      errorBuilder: (BuildContext context, Object exception,
                              StackTrace? stackTrace) =>
                          Container(),
                    ),
              ListTile(
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [widget.sharedItem!.getIconWidget()],
                ),
                title: Column(
                  children: [
                    Text(sharedItem.title,
                        textAlign: TextAlign.center,
                        style: !wasViewed
                            ? TextStyle(fontWeight: FontWeight.bold)
                            : null),
                    Padding(padding: EdgeInsets.only(top: 6)),
                    CountdownTimer(
                      endTime: sharedItem.reminderTime != null
                          ? sharedItem.reminderTime.millisecondsSinceEpoch
                          : 0,
                      widgetBuilder: (_, CurrentRemainingTime? time) {
                        if (widget.parentPage == 'history')
                          return Container(
                            height: 0,
                            width: 0,
                          );
                        if (time == null) {
                          return Text('snoozed',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight:
                                      !wasViewed ? FontWeight.bold : null));
                        }
                        return Text(getRemainingTimeText(time),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight:
                                    !wasViewed ? FontWeight.bold : null));
                      },
                    ),
                  ],
                ),
                trailing: PopupMenuButton(
                  itemBuilder: (BuildContext context) {
                    if (widget.parentPage == 'history')
                      return [
                        popupMenuItems(sharedItem)['newTitle']!,
                        popupMenuItems(sharedItem)['restoreItem']!
                      ];
                    if (widget.parentPage == 'main') {
                      var list = [
                        popupMenuItems(sharedItem)['newTitle']!,
                        popupMenuItems(sharedItem)['setReminder']!
                      ];
                      if (sharedItem.wasViewed)
                        list.add(popupMenuItems(sharedItem)['markUnseen']!);
                      return list;
                    }
                    return [];
                  },
                ),
              )
            ],
          )),
    ]);
  }

  Map<String, PopupMenuItem> popupMenuItems(SharedItem sharedItem) {
    return {
      'newTitle': PopupMenuItem(
          child: TextButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return NewTitleDialog(sharedItem);
              }).then((value) {
            widget.parentPageState.setState(() {});
            Navigator.pop(context);
          });
          //editTitleDialog(context);
        },
        child: Row(
          children: [
            Icon(
              Icons.edit,
              color: Globals.strongGray,
            ),
            SizedBox(width: 10),
            Text(
              'Edit title',
              style: TextStyle(color: Globals.textBlack),
            ),
          ],
        ),
      )),
      'setReminder': PopupMenuItem(
          child: TextButton(
        onPressed: () async {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return TPD.TimePickerDialog();
              }).then((value) {
            if (value != null) {
              Analytics.newReminderTime(
                  sharedItem.typeToText(),
                  DateTime.now().isAfter(sharedItem.reminderTime),
                  DateTime.now().difference(value));
              sharedItem.setReminderTime(value);
              widget.parentPageState.setState(() {});
            }
            Navigator.pop(context);
          });
        },
        child: Row(
          children: [
            Icon(Icons.add_alert, color: Globals.strongGray),
            SizedBox(width: 10),
            Text('New reminder time',
                style: TextStyle(color: Globals.textBlack)),
          ],
        ),
      )),
      'markUnseen': PopupMenuItem(
          child: TextButton(
        onPressed: () {
          Analytics.markAsUnseen(sharedItem.typeToText());
          sharedItem.wasViewed = false;
          sharedItem.save();
          widget.parentPageState.setState(() {});
          Navigator.pop(context);
        },
        child: Row(
          children: [
            Icon(Icons.remove_red_eye_outlined, color: Globals.strongGray),
            SizedBox(width: 10),
            Text('Mark as unseen', style: TextStyle(color: Globals.textBlack)),
          ],
        ),
      )),
      'restoreItem': PopupMenuItem(
          child: TextButton(
        onPressed: () {
          Analytics.itemRestoredFromHistory(sharedItem.typeToText());
          sharedItem.delete();
          Database.addSharedItem(Database.sharesList, sharedItem);
          widget.parentPageState.setState(() {});
          Navigator.pop(context);
        },
        child: Row(
          children: [
            Icon(Icons.restore, color: Globals.strongGray),
            SizedBox(width: 10),
            Text('Restore item', style: TextStyle(color: Globals.textBlack)),
          ],
        ),
      )),
      'shareItem': SharedItem.getContentWidget(sharedItem, context)
          .getPopupMenuButtons()
          .last
    };
  }

  String getRemainingTimeText(CurrentRemainingTime time) {
    if (time.days != null) {
      return 'reminder in less then ${time.days! + 1} days';
    }
    if (time.hours != null) {
      return 'reminder in less then ${time.hours! + 1} hours';
    }
    if (time.min != null) {
      return 'reminder in less then ${time.min! + 1} minutes';
    }
    return 'reminder in ${time.sec} seconds';
  }
}
