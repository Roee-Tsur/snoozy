import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mime/mime.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snozzy/CustomWidgets/GlobalWidgets.dart';

import 'package:snozzy/CustomWidgets/ItemWidget.dart';
import 'package:snozzy/CustomWidgets/MainDrawer.dart';
import 'package:snozzy/CustomWidgets/TimePickerDialog.dart' as mDialog;
import 'package:snozzy/Globals.dart';
import 'package:snozzy/models/FileItem.dart';
import 'package:snozzy/models/ImageItem.dart';
import 'package:snozzy/models/LinkItem.dart';
import 'package:snozzy/models/SharedItem.dart';
import 'package:snozzy/models/TextItem.dart';
import 'package:snozzy/models/VideoItem.dart';
import 'package:snozzy/services/Analytics.dart';
import 'package:snozzy/services/Database.dart';
import 'package:snozzy/Pages/ItemViewerPage.dart' as ItemViewerPage;
import 'package:snozzy/services/Notifications.dart';
import 'package:string_validator/string_validator.dart';
import 'package:url_launcher/url_launcher.dart';

class MainListPage extends StatefulWidget {
  static final String routeName = '/';

  @override
  MainListPageState createState() => MainListPageState();
}

class MainListPageState extends State<MainListPage> {
  GlobalKey _key = GlobalKey();
  bool isSnoozedTabOpen = false;

  String searchText = '';
  Widget appBarTitle = Padding(
    padding: EdgeInsets.only(top: 12, bottom: 12),
    child: Image.asset('assets/logo.jpg'),
  );
  Icon actionIcon = Icon(Icons.search);
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    searchController.addListener(() {
      setState(() {
        searchText = searchController.text;
      });
    });

    // For sharing images coming from outside the app while the app is in the memory
    ReceiveSharingIntent.getMediaStream().listen((List<SharedMediaFile> value) {
      handleNewSharedItem(value.first);
      value.clear();
    });

    // For sharing images coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialMedia().then((List<SharedMediaFile> value) {
      if (value.isEmpty) return;
      handleNewSharedItem(value.first);
      value.clear();
    });

    // For sharing or opening urls/text coming from outside the app while the app is in the memory
    ReceiveSharingIntent.getTextStream().listen((String value) {
      handleNewSharedItem(value);
    });

    // For sharing or opening urls/text coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialText().then((String? value) {
      handleNewSharedItem(value);
    });
  }

  @override
  void dispose() {
    super.dispose();
    ReceiveSharingIntent.reset();
  }

  Future handleNewSharedItem(dynamic value) async {
    print('enteredHandleSharedItem with $value');
    if (value == null) return;
    dynamic sharedItem;
    if (value is String) {
      if (isURL(value))
        sharedItem = LinkItem.normal(value);
      else
        sharedItem = TextItem.normal(value);
    } else {
      switch ((value as SharedMediaFile).type) {
        case SharedMediaType.IMAGE:
          sharedItem = ImageItem.normal(value);
          break;
        case SharedMediaType.VIDEO:
          sharedItem = VideoItem.normal(value);
          break;
        case SharedMediaType.FILE:
          sharedItem = FileItem.normal(value);
          break;
      }
    }
    Database.addSharedItem(Database.sharesList, sharedItem);
    await getReminderTimeFromUser().then((value) async {
      sharedItem.setReminderTime(value);
      setState(() {});
    });
    Analytics.itemCreated(sharedItem.type.toString());
    ReceiveSharingIntent.reset();
  }

  Future<DateTime?> getReminderTimeFromUser() {
    return showDialog(
        context: context,
        builder: (BuildContext context) => mDialog.TimePickerDialog());
  }

  @override
  Widget build(BuildContext context) {
    SharedPreferences.getInstance().then((value) =>
        value.containsKey('numberOfItemsCreated') &&
                value.getInt('numberOfItemsCreated')! > 2 &&
                !value.containsKey('reviewDialogSeen')
            ? showRateUsDialog(value)
            : null);

    List itemsList = Database.getAllItemsInBox(Database.sharesList);
    itemsList
        .removeWhere((element) => !element.searchableText.contains(searchText));
    return Scaffold(
      key: _key,
      appBar: buildAppBar(context),
      drawer: MainDrawer(CurrentPage.MainList),
      body: itemsList.isEmpty
          ? emptyListTextWidget()
          : ListView.builder(
              padding: EdgeInsets.only(bottom: 200),
              itemCount: itemsList.length,
              itemBuilder: (BuildContext context, int index) {
                dynamic currItem = itemsList[index];
                return makeItemCard(currItem);
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Globals.snoozyPurple,
        onPressed: () => addNewItemDialog(),
        child: Icon(Icons.add),
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
                  duration: Duration(milliseconds: 250),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) =>
                          SlideTransition(
                            child: child,
                            position: Tween<Offset>(
                                    begin: Offset(-1, 0), end: Offset(0, 0))
                                .animate(animation),
                          ),
                  child: appBarTitle),
              actions: [
                IconButton(
                    icon: actionIcon,
                    onPressed: () {
                      setState(() {
                        if (actionIcon.icon == Icons.search) {
                          actionIcon = Icon(Icons.close);
                          appBarTitle = TextField(
                            controller: searchController,
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
                            appBarTitle = Padding(
                              padding: EdgeInsets.only(top: 12, bottom: 12),
                              child: Image.asset('assets/logo.jpg'),
                            );
                            searchController.clear();
                          });
                      });
                    })
              ]),
        ],
      ),
    );
  }

  Widget makeItemCard(SharedItem sharedItem) => Dismissible(
        key: ObjectKey(sharedItem.id),
        secondaryBackground: GlobalWidgets.rightDismissable,
        background: GlobalWidgets.leftDismissable,
        onDismissed: (direction) async {
          Analytics.itemMovedToHistory(sharedItem.typeToText());
          await sharedItem.delete();
          Notifications.cancelNotification(sharedItem.notificationId);
          sharedItem.enteredHistoryTime = DateTime.now();
          sharedItem.reminderTime = DateTime.now();
          Database.addSharedItem(Database.historyList, sharedItem);
          setState(() {});
        },
        child: Card(
          elevation: 4,
          margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: InkWell(
            child: getItemWidget(sharedItem),
            onTap: () {
              openItemViewer(sharedItem, context, 'main_page');
              setState(() {});
            },
          ),
        ),
      );

  Widget getItemWidget(SharedItem sharedItem) {
    String? videoDuration;
    Image? imageWidget;

    switch (sharedItem.runtimeType) {
      case VideoItem:
        VideoItem videoItem = sharedItem as VideoItem;
        videoDuration = videoItem.getFormatedDuration();
        if (videoItem.thumbnail != '')
          imageWidget = Image(
            image: Image.file(File(videoItem.thumbnail)).image,
          );
        else
          imageWidget = null;
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
      parentPage: 'main',
    );
  }

  Widget emptyListTextWidget() => Center(
          child: InkWell(
        onTap: () => addNewItemDialog(),
        child: Text(
          "Looks like you don't have saved items",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ));

  static openItemViewer(
      SharedItem sharedItem, BuildContext context, String source) {
    sharedItem.wasViewed = true;
    sharedItem.save();
    Analytics.itemOpened(sharedItem.typeToText(), source);
    Navigator.push(
        context,
        MaterialPageRoute(
            settings:
                RouteSettings(name: '${sharedItem.typeToText()}ItemViewer'),
            builder: (context) {
              Analytics.setCurrentScreen(
                  '${sharedItem.typeToText()}ItemViewer');
              return ItemViewerPage.ItemViewerPage(
                sharedItem,
              );
            }));
  }

  void addNewItemDialog() {
    showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: "",
        pageBuilder: (BuildContext context, __, ___) {
          return FabDialogContent(
              createItemFromFile: createItemFromFilePicker,
              createItemFromText: createItemFromTextField);
        });
  }

  void createItemFromFilePicker(String? path) async {
    if (path == null || path.isEmpty) return;
    dynamic sharedItem;
    String? mimeType = lookupMimeType(path);
    if (mimeType!.startsWith('image'))
      sharedItem = ImageItem.fab(path);
    else if (mimeType.startsWith('video'))
      sharedItem = VideoItem.fab(path);
    else
      sharedItem = FileItem.fab(path);
    Database.addSharedItem(Database.sharesList, sharedItem);
    await getReminderTimeFromUser().then((value) {
      sharedItem.setReminderTime(value);
      setState(() {});
    });
    Analytics.itemCreatedFAB(sharedItem);
  }

  void createItemFromTextField(String? value) async {
    if (value == null) return;
    dynamic sharedItem;
    if (isURL(value))
      sharedItem = LinkItem.normal(value);
    else
      sharedItem = TextItem.normal(value);

    Database.addSharedItem(Database.sharesList, sharedItem);
    await getReminderTimeFromUser().then((value) {
      sharedItem.setReminderTime(value);
      setState(() {});
    });
    Analytics.itemCreatedFAB(sharedItem.toString());
  }

  showRateUsDialog(SharedPreferences value) {
    value.setBool('reviewDialogSeen', true);
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text(
                'Do you like Snoozy? \nRate us!',
                textAlign: TextAlign.center,
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'No, Thanks',
                      style: TextStyle(color: Colors.red),
                    )),
                TextButton(
                    onPressed: () => launch(
                        'https://play.google.com/store/apps/details?id=surk.inc.snoozy'),
                    child: Text(
                      'Review now',
                      style: TextStyle(color: Colors.green),
                    ))
              ],
            ));
  }
}

class FabDialogContent extends StatefulWidget {
  Function createItemFromText, createItemFromFile;

  FabDialogContent(
      {required this.createItemFromFile, required this.createItemFromText});

  @override
  State<FabDialogContent> createState() => _FabDialogContentState();
}

class _FabDialogContentState extends State<FabDialogContent> {
  final String textOption = "text_option", fileOption = "file_option";
  var chosenOption = '';
  final textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.3,
        width: MediaQuery.of(context).size.width * 0.5,
        child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
          Text(
            'Add New Item',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          Container(
            height: 15,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          chosenOption == textOption
                              ? Globals.snoozyPurple
                              : Globals.strongGray)),
                  child: Text("Text / Link"),
                  onPressed: () {
                    setState(() {
                      chosenOption = textOption;
                    });
                  }),
              Container(width: 10),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          chosenOption == fileOption
                              ? Globals.snoozyPurple
                              : Globals.strongGray)),
                  onPressed: () {
                    setState(() {
                      chosenOption = fileOption;
                    });
                  },
                  child: Text("File"))
            ],
          ),
          Container(
            height: 15,
          ),
          chosenOption == textOption ? showTextOption() : Container(),
          chosenOption == fileOption ? showFileOption() : Container()
        ]),
      ),
    );
  }

  Widget showTextOption() {
    return Row(
      children: [
        Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
          controller: textEditingController,
          decoration: InputDecoration(
              border: OutlineInputBorder(),
                labelText: 'link or text',
                contentPadding: EdgeInsets.only(left: 4)),
        ),
            )),
        IconButton(
          icon: Icon(Icons.done),
          onPressed: () {
            if (textEditingController.text == '') {
              Fluttertoast.showToast(msg: 'please enter what you want to save');
              return;
            }
            Navigator.pop(context);
            widget.createItemFromText(textEditingController.text);
          },
        ),
      ],
    );
  }

  Widget showFileOption() {
    return InkWell(
      onTap: () {
        FilePicker.platform
            .pickFiles(
          allowMultiple: false,
        )
            .then((value) {
          if (value == null) return;
          Navigator.pop(context);
          widget.createItemFromFile(value.paths.first);
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('tap to upload a file'),
          Icon(Icons.upload_rounded),
        ],
      ),
    );
  }
}
