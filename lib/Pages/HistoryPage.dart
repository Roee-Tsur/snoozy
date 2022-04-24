import 'dart:io';

import 'package:flutter/material.dart';
import 'package:snozzy/CustomWidgets/GlobalWidgets.dart';
import 'package:snozzy/CustomWidgets/ItemWidget.dart';
import 'package:snozzy/CustomWidgets/MainDrawer.dart';
import 'package:snozzy/Pages/MainListPage.dart';
import 'package:snozzy/models/FileItem.dart';
import 'package:snozzy/models/ImageItem.dart';
import 'package:snozzy/models/LinkItem.dart';
import 'package:snozzy/models/SharedItem.dart';
import 'package:snozzy/models/TextItem.dart';
import 'package:snozzy/models/VideoItem.dart';
import 'package:snozzy/services/Analytics.dart';
import 'package:snozzy/services/Database.dart';

import '../Globals.dart';

class HistoryPage extends StatefulWidget {
  static final String routeName = '/historyPage';

  State<StatefulWidget> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String searchText = '';
  Widget appBarTitle = Text(
    'History',
    style: TextStyle(color: Globals.strongGray),
  );
  Icon actionIcon = Icon(Icons.search);
  TextEditingController controller = TextEditingController();
  late Widget deleteWidget;

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      setState(() {
        searchText = controller.text;
      });
    });

    deleteWidget = deleteAllIcon();
  }

  @override
  Widget build(BuildContext context) {
    List itemsList = Database.getAllItemsInBox(Database.historyList);
    itemsList
        .removeWhere((element) => !element.searchableText.contains(searchText));
    return Scaffold(
      appBar: buildAppBar(context),
      drawer: MainDrawer(CurrentPage.History),
      body: itemsList.isEmpty
          ? emptyListWidget()
          : ListView.builder(
              padding: EdgeInsets.only(bottom: 200),
              itemCount: itemsList.length,
              itemBuilder: (BuildContext context, int index) {
                dynamic currItem = itemsList[index];
                if (itemsList.isEmpty)
                  return Text('no items');
                else
                  return makeItemCard(currItem);
              },
            ),
    );
  }

  PreferredSize buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(80),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppBar(
              backgroundColor: Colors.white,
              centerTitle: true,
              title: AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                child: appBarTitle,
                transitionBuilder:
                    (Widget child, Animation<double> animation) =>
                        ScaleTransition(child: child, scale: animation),
              ),
              actions: [
                IconButton(
                    icon: actionIcon,
                    onPressed: () {
                      setState(() {
                        if (actionIcon.icon == Icons.search) {
                          actionIcon = Icon(Icons.close);
                          deleteWidget = Container(width: 0, height: 0);
                          appBarTitle = TextField(
                            controller: controller,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search),
                              hintText: "Search...",
                            ),
                          );
                          setState(() {});
                        } else
                          setState(() {
                            actionIcon = Icon(
                              Icons.search,
                            );
                            deleteWidget = deleteAllIcon();
                            appBarTitle = Padding(
                              padding: EdgeInsets.only(top: 12, bottom: 12),
                              child: Image.asset('assets/logo.jpg'),
                            );
                            controller.clear();
                          });
                      });
                    }),
                Database.getAllItemsInBox(Database.historyList).isEmpty
                    ? Container(
                        width: 0,
                        height: 0,
                      )
                    : AnimatedSwitcher(
                        child: deleteWidget,
                        duration: Duration(milliseconds: 300),
                      )
              ]),
        ],
      ),
    );
  }

  Widget makeItemCard(SharedItem sharedItem) {
    return Dismissible(
      key: ObjectKey(sharedItem.id),
      secondaryBackground: GlobalWidgets.rightDismissable,
      background: GlobalWidgets.leftDismissable,
      confirmDismiss: (DismissDirection direction) {
        return showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  elevation: 20.0,
                  title: Text('This item will be permanently deleted'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          setState(() {});
                        },
                        child: Text(
                          'Dismiss',
                          style: TextStyle(color: Colors.red.shade400),
                        )),
                    TextButton(
                      onPressed: () async {
                        Analytics.itemPermanentlyDeleted(
                            sharedItem.typeToText());
                        await sharedItem.delete();
                        Navigator.pop(context);
                        setState(() {});
                      },
                      child: Text('Proceed',
                          style: TextStyle(color: Colors.green.shade400)),
                    )
                  ],
                ));
      },
      child: Card(
        elevation: 4,
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: InkWell(
          child: getItemWidget(sharedItem),
          onTap: () {
            MainListPageState.openItemViewer(
                sharedItem, context, 'history_page');
          },
        ),
      ),
    );
  }

  Widget getItemWidget(SharedItem sharedItem) {
    String? videoDuration;
    Image? imageWidget;

    switch (sharedItem.runtimeType) {
      case VideoItem:
        VideoItem videoItem = sharedItem as VideoItem;
        videoDuration = videoItem.getFormatedDuration();
        imageWidget = Image(
          image: Image.file(File(videoItem.thumbnail)).image,
        );
        break;
      case ImageItem:
        imageWidget = Image(
          image: Image.file(File((sharedItem as ImageItem).path)).image,
        );
        break;
      case FileItem:
        imageWidget = null;
        break;
      case TextItem:
        imageWidget = null;
        break;
      case LinkItem:
        String? imageUrl = (sharedItem as LinkItem).imageUrl;
        if (imageUrl != null)
          imageWidget = Image(
            image: Image.network(imageUrl).image,
          );
        break;
    }

    return ItemWidget(
      this,
      title: sharedItem.title,
      imageWidget: imageWidget,
      sharedItem: sharedItem,
      subTitle: 'subtitle',
      videoDuration: videoDuration,
      parentPage: 'history',
    );
  }

  Widget deleteAllIcon() => IconButton(
        icon: Icon(Icons.delete),
        onPressed: () => showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  elevation: 20.0,
                  title: Text(
                      'Are you sure you want to permanently delete all of your saved history?'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          setState(() {});
                        },
                        child: Text(
                          'Dismiss',
                          style: TextStyle(
                            color: Colors.red.shade400,
                          ),
                        )),
                    TextButton(
                        onPressed: () async {
                          await Database.deleteAllHistory();
                          setState(() {});
                          Navigator.pop(context);
                        },
                        child: Text('Proceed',
                            style: TextStyle(
                              color: Colors.green.shade400,
                            ))),
                  ],
                )),
      );

  Widget emptyListWidget() => Center(
        child: Text("Looks like your history list is empty",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
      );
}
