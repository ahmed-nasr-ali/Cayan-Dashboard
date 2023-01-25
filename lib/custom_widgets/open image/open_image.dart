// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:photo_view/photo_view_gallery.dart';

class OpenImage extends StatefulWidget {
  String? userImage;
  File? imageSend;
  OpenImage({Key? key, this.userImage, this.imageSend}) : super(key: key);

  @override
  State<OpenImage> createState() => _OpenImageState();
}

class _OpenImageState extends State<OpenImage> {
  @override
  Widget build(BuildContext context) {
    return PhotoViewGallery.builder(
      itemCount: 1,
      builder: (context, index) {
        return PhotoViewGalleryPageOptions(
            imageProvider: widget.imageSend != null
                ? FileImage(widget.imageSend!) as ImageProvider
                : NetworkImage(widget.userImage!));
      },
    );
  }
}
