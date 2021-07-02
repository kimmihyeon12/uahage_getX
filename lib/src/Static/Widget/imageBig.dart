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
  String swipeDirection;

  @override
  Widget build(BuildContext context) {
    return page == "reviewImage"
        ? Scaffold(
            body: GestureDetector(
              onPanUpdate: (details) {
                swipeDirection = details.delta.dx < 0 ? 'left' : 'right';
              },
              onPanEnd: (details) {
                if (swipeDirection == 'left') {
                  //handle swipe left event
                  print("left");
                  if (index < image.length - 1) {
                    setState(() {
                      index++;
                    });
                  }
                }
                if (swipeDirection == 'right') {
                  //handle swipe right event
                  print("right");
                  if (index > 0) {
                    setState(() {
                      index--;
                    });
                  }
                }
              },
              child: Stack(
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
                        Padding(padding: EdgeInsets.only(left: 100.w)),
                        index > 0
                            ? InkWell(
                                child: Image.asset(
                                  "assets/reviewPage/left.png",
                                  width: 80.w,
                                ),
                                onTap: () {
                                  setState(() {
                                    if (index > 0) {
                                      setState(() {
                                        index--;
                                      });
                                    }
                                  });
                                },
                              )
                            : SizedBox(
                                width: 80.w,
                              ),
                        Padding(padding: EdgeInsets.only(left: 1150.w)),
                        (index < image.length - 1)
                            ? InkWell(
                                child: Image.asset(
                                  "assets/reviewPage/right.png",
                                  width: 80.w,
                                ),
                                onTap: () {
                                  if (index < image.length - 1) {
                                    setState(() {
                                      index++;
                                    });
                                  }
                                },
                              )
                            : SizedBox(
                                width: 80.w,
                              )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        : Scaffold(
            body: GestureDetector(
              onPanUpdate: (details) {
                swipeDirection = details.delta.dx < 0 ? 'left' : 'right';
              },
              onPanEnd: (details) {
                if (swipeDirection == 'left') {
                  //handle swipe left event
                  print("left");
                  if (index < image.length - 1) {
                    setState(() {
                      index++;
                    });
                  }
                }
                if (swipeDirection == 'right') {
                  //handle swipe right event
                  print("right");
                  if (index > 0) {
                    setState(() {
                      index--;
                    });
                  }
                }
              },
              child: Stack(
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
                      color: Colors.black,
                    ),
                  ),
                  Center(
                    child: Row(
                      children: [
                        Padding(padding: EdgeInsets.only(left: 100.w)),
                        index > 0
                            ? InkWell(
                                child: Image.asset(
                                  "assets/reviewPage/left.png",
                                  width: 80.w,
                                ),
                                onTap: () {
                                  setState(() {
                                    if (index > 0) {
                                      setState(() {
                                        index--;
                                      });
                                    }
                                  });
                                },
                              )
                            : SizedBox(
                                width: 80.w,
                              ),
                        Padding(padding: EdgeInsets.only(left: 1150.w)),
                        (index < image.length - 1)
                            ? InkWell(
                                child: Image.asset(
                                  "assets/reviewPage/right.png",
                                  width: 80.w,
                                ),
                                onTap: () {
                                  if (index < image.length - 1) {
                                    setState(() {
                                      index++;
                                    });
                                  }
                                },
                              )
                            : SizedBox(
                                width: 80.w,
                              ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
  }
}
