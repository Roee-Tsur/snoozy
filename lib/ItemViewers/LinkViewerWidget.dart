import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:share/share.dart';
import 'package:snozzy/Pages/ItemViewerPage.dart';
import 'package:snozzy/models/LinkItem.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Globals.dart';

class LinkViewerWidget extends StatelessWidget
    implements ItemViewerContentWidget {
  LinkItem linkItem;

  LinkViewerWidget(this.linkItem);

  @override
  Widget build(BuildContext context) {
    return InAppWebView(initialUrlRequest: URLRequest(url: Uri.parse(linkItem.url)) );
  }

  @override
  List<PopupMenuItem> getPopupMenuButtons() {
    return [
      PopupMenuItem(
          child: TextButton(
            onPressed: () => launch(linkItem.url),
            child: Row(
              children: [
                Icon(Icons.open_in_new, color: Globals.strongGray),
                SizedBox(width: 10),
                Text('Open in system default', style: TextStyle(color: Globals.textBlack)),
              ],
            ),
          )),
      PopupMenuItem(
          child: TextButton(
            onPressed: () => Clipboard.setData(ClipboardData(text: linkItem.url)),
            child: Row(
              children: [
                Icon(Icons.copy, color: Globals.strongGray),
                SizedBox(width: 10),
                Text('Copy link',
                    style: TextStyle(color: Globals.textBlack)),
              ],
            ),
          )),
      PopupMenuItem(
          child: TextButton(
            onPressed: () => Share.share(linkItem.url),
            child: Row(
              children: [
                Icon(Icons.share_outlined, color: Globals.strongGray),
                SizedBox(width: 10),
                Text('Share', style: TextStyle(color: Globals.textBlack)),
              ],
            ),
          ))
    ];
  }
}