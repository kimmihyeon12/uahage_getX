import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uahage/src/Controller/bookmark.controller.dart';
import 'package:uahage/src/Controller/user.controller.dart';
import 'package:uahage/src/Service/bookmark.dart';
import 'package:uahage/src/Static/Widget/appbar.dart';
import 'package:uahage/src/Static/Widget/icon.dart';

class Star extends GetView<BookmarkController> {
  var listimage = [
    "./assets/listPage/clipGroup.png",
    "./assets/listPage/clipGroup1.png",
    "./assets/listPage/layer1.png",
    "./assets/listPage/layer2.png",
  ];
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  Bookmark bookmark = new Bookmark();
  bookselect() async {
    Bookmark bookmark = new Bookmark();
    await bookmark.bookmarkSelectAll(UserController.to.userId.value);
  }

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => BookmarkController());
    controller.starListInit();
    bookselect();
    ScreenUtil.init(context, width: 1501, height: 2667);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: imageAppbar(context, "즐겨찾기"),
        body: Obx(() => (() {
              if (controller.starList.length == 0) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 803.h),
                      child: Image.asset(
                        './assets/starPage/group.png',
                        height: 600.h,
                        width: 800.w,
                      ),
                    ),
                  ],
                );
              } else {
                return ListView.builder(
                    key: listKey,
                    itemCount: controller.starList.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
                        key: UniqueKey(),
                        resizeDuration: Duration(milliseconds: 200),
                        background: Container(
                          color: Colors.red[400],
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 30.w),
                              )
                            ],
                          ),
                        ),
                        onDismissed: (direction) async {
                          //  var data = snapshot.data[index];
                          //     await click_star(data.address);
                          // setState(() {
                          //  snapshot.data.removeAt(index);
                          // });
                        },
                        child: Card(
                          elevation: 0.3,
                          child: Container(
                              height: 450.h,
                              padding: EdgeInsets.only(
                                top: 1.h,
                                left: 26.w,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  InkWell(
                                    highlightColor: Colors.white,
                                    onTap: () async {
                                      await Get.toNamed("/listsub", arguments: {
                                        "data": controller.starList[index],
                                        "placeCode": controller
                                            .starList[index].place_code,
                                        "index": index,
                                      });
                                    },
                                    child: Container(
                                      width: 1280.w,
                                      //     color:Colors.pink,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          (() {
                                            if (index % 4 == 1) {
                                              return Image.asset(
                                                listimage[0],
                                                height: 414.h,
                                                width: 413.w,
                                              );
                                            } else if (index % 4 == 2) {
                                              return Image.asset(
                                                listimage[1],
                                                height: 414.h,
                                                width: 413.w,
                                              );
                                            } else if (index % 4 == 3) {
                                              return Image.asset(
                                                listimage[2],
                                                height: 414.h,
                                                width: 413.w,
                                              );
                                            } else {
                                              return Image.asset(
                                                listimage[3],
                                                height: 414.h,
                                                width: 413.w,
                                              );
                                            }
                                          }()),
                                          Padding(
                                              padding: EdgeInsets.only(
                                            left: 53.w,
                                          )),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 10.h)),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        top: 20.h),
                                                    width: 700.w,
                                                    height: 82.h,
                                                    child: Text(
                                                      controller
                                                          .starList[index].name,
                                                      style: TextStyle(
                                                        fontSize: 56.sp,
                                                        fontFamily:
                                                            'NotoSansCJKkr_Medium',
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                height: 135.h,
                                                width: 650.w,
                                                child: Text(
                                                  controller
                                                      .starList[index].address,
                                                  style: TextStyle(
                                                    // fontFamily: 'NatoSans',
                                                    color: Colors.grey,
                                                    fontSize: 56.sp,
                                                    fontFamily:
                                                        'NotoSansCJKkr_Medium',
                                                    height: 1.3,
                                                  ),
                                                ),
                                              ),
                                              controller.starList[index]
                                                          .place_code ==
                                                      1
                                                  ? Container(
                                                      margin: EdgeInsets.only(
                                                          top: 15.h),
                                                      height: 120.h,
                                                      width: 650.w,
                                                      alignment:
                                                          Alignment.bottomRight,
                                                      child: Row(
                                                        children: [
                                                          icon(
                                                              context,
                                                              controller
                                                                  .starList[
                                                                      index]
                                                                  .menu
                                                                  .toString(),
                                                              controller
                                                                  .starList[
                                                                      index]
                                                                  .carriage
                                                                  .toString(),
                                                              controller
                                                                  .starList[
                                                                      index]
                                                                  .bed
                                                                  .toString(),
                                                              controller
                                                                  .starList[
                                                                      index]
                                                                  .tableware
                                                                  .toString(),
                                                              controller
                                                                  .starList[
                                                                      index]
                                                                  .nursingroom
                                                                  .toString(),
                                                              controller
                                                                  .starList[
                                                                      index]
                                                                  .meetingroom
                                                                  .toString(),
                                                              controller
                                                                  .starList[
                                                                      index]
                                                                  .diapers
                                                                  .toString(),
                                                              controller
                                                                  .starList[
                                                                      index]
                                                                  .playroom
                                                                  .toString(),
                                                              controller
                                                                  .starList[
                                                                      index]
                                                                  .chair
                                                                  .toString())
                                                        ],
                                                      ),
                                                    )
                                                  : Container()
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.only(left: 30.w, top: 25.h),
                                    child: IconButton(
                                      padding: EdgeInsets.all(0),
                                      constraints: BoxConstraints(
                                        maxWidth: 70.w,
                                        maxHeight: 70.h,
                                      ),
                                      icon: Image.asset(
                                        false
                                            ? "./assets/listPage/love_grey.png"
                                            : "./assets/listPage/love_color.png",
                                        height: 60.h,
                                      ),
                                      onPressed: () async {
                                        print('star click');
                                        await bookmark.bookmarkDelete(
                                            UserController.to.userId.value,
                                            controller.starList[index].id);

                                        controller.starListrefresh(index);
                                      },
                                    ),
                                  ),
                                ],
                              )),
                        ),
                      );
                    });
              }
            }())));
  }
}
