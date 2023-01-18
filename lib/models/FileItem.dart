import 'package:flutter/material.dart';
import 'package:path/path.dart' as pathLib;
import 'package:hive/hive.dart';
import 'package:mime/mime.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

import 'SharedItem.dart';

part 'FileItem.g.dart';

@HiveType(typeId: 6)
class FileItem extends SharedItem {
  @HiveField(4)
  late String path;
  @HiveField(5)
  late String fileType;

  FileItem(this.path) : super.normal(null, null);

  FileItem.normal(SharedMediaFile value)
      : super.normal(DateTime.now(), SharedItemType.FILE) {
    path = value.path;
    fileType = extensionFromMime(lookupMimeType(path)!);
    title = pathLib.basename(path);
  }

  FileItem.fab(String path)
      : super.normal(DateTime.now(), SharedItemType.FILE) {
    this.path = path;
    fileType = extensionFromMime(lookupMimeType(path)!);
    title = pathLib.basename(path);
  }

  Icon getIconWidget() {
    switch (fileType) {
      case ('doc'):
        return Icon(Icons.description);
      case ('docx'):
        return Icon(Icons.description);
      case ('pdf'):
        return Icon(Icons.picture_as_pdf);
      case ('ppt'):
        return Icon(Icons.slideshow);
      case ('pptx'):
        return Icon(Icons.slideshow);
      case ('ods'):
        return Icon(Icons.slideshow);
      case ('txt'):
        return Icon(Icons.text_snippet);
    }
    return Icon(Icons.insert_drive_file);
  }
}
