import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:uahage/src/Static/Font/font.dart';

class ImageBig extends StatefulWidget {
  @override
  _ImageBigState createState() => _ImageBigState();
}

class _ImageBigState extends State<ImageBig> {
  var image = Get.arguments['image'];
  var index = Get.arguments['index'];
  var page = Get.arguments['page'];
  @override
  Widget build(BuildContext context) {
    return page == "reviewImage"
        ? Scaffold(
            body: Stack(
              children: [
                Center(
                  child: Container(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        image: DecorationImage(
                            image: NetworkImage(image[index]["image_path"]),
                            fit: BoxFit.contain),
                      ),
                    ),
                    color: Colors.black,
                  ),
                ),
                Center(
                  child: Row(
                    children: [
                      Padding(padding: EdgeInsets.only(left: 50.w)),
                      TextButton.icon(
                        onPressed: () {
                          setState(() {
                            if (index > 0) {
                              setState(() {
                                index--;
                              });
                            }
                          });
                        },
                        icon: Icon(
                          Icons.arrow_left_outlined,
                          size: 250.w,
                          color: Colors.black,
                        ),
                        label: Text(""),
                      ),
                      Padding(padding: EdgeInsets.only(left: 750.w)),
                      TextButton.icon(
                        onPressed: () {
                          print(index);
                          print(image.length);
                          if (index < image.length - 1) {
                            setState(() {
                              index++;
                            });
                          }
                        },
                        icon: Icon(
                          Icons.arrow_right_outlined,
                          size: 250.w,
                          color: Colors.black,
                        ),
                        label: Text(""),
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        : Scaffold(
            body: Stack(
              children: [
                Center(
                  child: Container(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        image: DecorationImage(
                            image: NetworkImage(image[index]),
                            fit: BoxFit.contain),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Row(
                    children: [
                      Padding(padding: EdgeInsets.only(left: 50.w)),
                      TextButton.icon(
                        onPressed: () {
                          setState(() {
                            if (index > 0) {
                              setState(() {
                                index--;
                              });
                            }
                          });
                        },
                        icon: Icon(
                          Icons.arrow_left_outlined,
                          size: 250.w,
                          color: Colors.black,
                        ),
                        label: Text(""),
                      ),
                      Padding(padding: EdgeInsets.only(left: 750.w)),
                      TextButton.icon(
                        onPressed: () {
                          print(index);
                          print(image.length);
                          if (index < image.length - 1) {
                            setState(() {
                              index++;
                            });
                          }
                        },
                        icon: Icon(
                          Icons.arrow_right_outlined,
                          size: 250.w,
                          color: Colors.black,
                        ),
                        label: Text(""),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
  }
}
