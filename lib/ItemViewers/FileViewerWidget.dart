import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:share/share.dart';
import 'package:snozzy/Globals.dart';
import 'package:snozzy/Pages/ItemViewerPage.dart';
import 'package:snozzy/models/FileItem.dart';
import 'package:url_launcher/url_launcher.dart';

class FileViewerWidget extends StatefulWidget
    implements ItemViewerContentWidget {
  FileItem fileItem;
  BuildContext context;
  bool fileOpened = false;

  FileViewerWidget(this.fileItem, this.context);

  @override
  List<PopupMenuItem> getPopupMenuButtons() {
    return [
      PopupMenuItem(
          child: TextButton(
        onPressed: () => launch(fileItem.path),
        child: Row(
          children: [
            Icon(
              Icons.open_in_new,
              color: Globals.strongGray,
            ),
            SizedBox(width: 10),
            Text(
              'Open in system default',
              style: TextStyle(color: Globals.textBlack),
            ),
          ],
        ),
      )),
      PopupMenuItem(
          child: TextButton(
        onPressed: () => Share.shareFiles([fileItem.path]),
        child: Row(
          children: [
            Icon(Icons.share_outlined, color: Globals.strongGray),
            SizedBox(width: 10),
            Text('Share file', style: TextStyle(color: Globals.textBlack)),
          ],
        ),
      ))
    ];
  }

  FileViewerWidgetState createState() => FileViewerWidgetState();
}

class FileViewerWidgetState extends State<FileViewerWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.fileOpened)
      return Center(
        child: TextButton(
          onPressed: () => openFile(),
          child: Text('click to open file'),
        ),
      );
    else {
      openFile();
      return Center(
        child: Column(
          children: [CircularProgressIndicator(), Text('Loading document')],
        ),
      );
    }
  }

  openFile() {
    OpenFile.open(widget.fileItem.path).then((value) {
      widget.fileOpened = true;
      setState(() {});
    });
  }
}
