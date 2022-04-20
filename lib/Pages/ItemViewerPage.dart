import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:snozzy/Globals.dart';
import 'package:snozzy/models/SharedItem.dart';

class ItemViewerPage extends StatelessWidget {
  SharedItem sharedItem;
  BuildContext? context;
  dynamic contentWidget;

  ItemViewerPage(this.sharedItem);

  @override
  Widget build(BuildContext context) {
    contentWidget = SharedItem.getContentWidget(sharedItem, context);
    this.context = context;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            sharedItem.title,
            maxLines: 1,
            style: TextStyle(color: Globals.textBlack),
          ),
          actions: [
            PopupMenuButton(
                itemBuilder: (context) => contentWidget.getPopupMenuButtons())
          ],
        ),
        body: contentWidget);
  }
}

abstract class ItemViewerContentWidget {
  List<PopupMenuItem> getPopupMenuButtons();
}
