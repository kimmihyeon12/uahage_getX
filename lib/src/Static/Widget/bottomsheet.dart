import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Sheet {
  var image;

  Future bottomSheet(context, option) {
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: Icon(
                        Icons.photo_library,
                        color: Color.fromRGBO(255, 114, 148, 1.0),
                      ),
                      title: Text('갤러리'),
                      onTap: () async {
                        image = await _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                      leading: Icon(
                        Icons.photo_camera,
                        color: Color.fromRGBO(255, 114, 148, 1.0),
                      ),
                      title: Text('카메라'),
                      onTap: () async {
                        image = await _imgFromCamera();
                        Navigator.of(context).pop();
                      }),
                  option == "delete"
                      ? new ListTile(
                          leading: new Icon(
                            Icons.delete_rounded,
                            color: Color.fromRGBO(255, 114, 148, 1.0),
                          ),
                          title: new Text('삭제'),
                          onTap: () async {
                            image = null;
                            Navigator.of(context).pop();
                          },
                        )
                      : Container()
                ],
              ),
            ),
          );
        });
  }

  Future _imgFromCamera() async {
    try {
      var image = await ImagePicker().getImage(
        source: ImageSource.camera,
        imageQuality: 20,
      );
      return File(image.path);
    } catch (err) {
      print(err);
    }
  }

  Future _imgFromGallery() async {
    try {
      var image = await ImagePicker()
          .getImage(source: ImageSource.gallery, imageQuality: 20);
      return File(image.path);
    } catch (err) {
      print(err);
    }
  }
}
