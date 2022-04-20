import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:share/share.dart';
import 'package:snozzy/Pages/ItemViewerPage.dart';
import 'package:snozzy/models/ImageItem.dart';

import '../Globals.dart';

class ImageViewerWidget extends StatelessWidget
    implements ItemViewerContentWidget {
  ImageItem imageItem;

  ImageViewerWidget(this.imageItem);

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      child: Center(
        child: Image(
          image: Image.file(File(imageItem.path)).image,
        ),
      ),
    );
  }

  @override
  List<PopupMenuItem> getPopupMenuButtons() {
    return [PopupMenuItem(
        child: TextButton(
          onPressed: () => OpenFile.open(imageItem.path),
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
            onPressed: () => Share.shareFiles([imageItem.path]),
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