import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

class ImageInput extends StatefulWidget {
  final String storedImage;
  final Function onSelectImage;

  ImageInput(this.storedImage, this.onSelectImage);

  @override
  _ImageInputState createState() => _ImageInputState(storedImage);
}

class _ImageInputState extends State<ImageInput> {
  final String initStoredImage;
  File _storedImage;
  final ImagePicker _picker = ImagePicker();

  _ImageInputState(this.initStoredImage);

  @override
  void initState() {
    super.initState();
    setState(() {
      if (initStoredImage != null && !initStoredImage.startsWith("http")) {
        _storedImage = File(initStoredImage);
      }
    });
  }

  Future<void> _takePicture() async {
    final imageFile = await _picker.getImage(
      source: ImageSource.gallery,
      maxWidth: 600,
    );
    if (imageFile == null) {
      return;
    }
    // final image = await ImageUtil.fixExifRotation();
    setState(() {
      _storedImage = File(imageFile.path);
    });
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final savedImage = await _storedImage.copy('${appDir.path}/$fileName');
    widget.onSelectImage(savedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 150,
      // height: 100,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.grey),
      ),
      child: InkWell(
        onTap: _takePicture,
        child: _storedImage != null
            ? Image.file(
                _storedImage,
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
              )
            : initStoredImage != null && initStoredImage.startsWith("http")
                ? CachedNetworkImage(
                    imageUrl: initStoredImage,
                    fit: BoxFit.cover,
                    height: double.infinity,
                    width: double.infinity,
                    placeholder: (context, url) =>
                        Center(child: new CircularProgressIndicator()),
                    errorWidget: (context, url, error) => new Icon(Icons.error),
                  )
                : Container(),
      ),
      alignment: Alignment.center,
    );
  }
}
