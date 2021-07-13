import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uahage/src/Controller/place.restaurant.bookmark.controller.dart';
import 'package:uahage/src/Controller/place.controller.dart';
import 'package:uahage/src/Controller/user.controller.dart';

import 'package:uahage/src/Service/places.restaurant.bookmarks.dart';
import 'package:uahage/src/Static/Font/font.dart';
import 'package:uahage/src/Static/Widget/appbar.dart';
import 'package:uahage/src/Static/Widget/icon.dart';

class Star extends GetView<BookmarkController> {
  var listimage = [
    "./assets/listPage/clipGroup.png",
    "./assets/listPage/clipGroup1.png",
    "./assets/listPage/layer1.png",
    "./assets/listPage/layer2.png",
  ];
  var width = 1500 / 720;
  var height = 2667 / 1280;
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  Bookmark bookmark = new Bookmark();
  ScrollController scrollController = ScrollController();
  bookselect() async {
    Bookmark bookmark = new Bookmark();
    await bookmark.bookmarkSelectAll(UserController.to.userId.value);
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 1125, height: 2436);
    controller.placeBookmarkInit();
    bookselect();
    scrollController.addListener(() {
      double maxScroll = scrollController.position.maxScrollExtent;
      double currentScroll = scrollController.position.pixels;
      if (currentScroll == maxScroll) {
        bookselect();
      }
    });

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: imageAppbar(context, "즐겨찾기"),
        body: Obx(() => (() {
              if (controller.placeBookmark.length == 0) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 746.h*0.9),
                      child: Image.asset(
                        './assets/starPage/group.png',
                        height: 400.h*0.9,
                        width: 700.w*0.84,
                      ),
                    ),
                  ],
                );
              } else {
                return ListView.builder(
                    key: listKey,
                    itemCount: controller.placeBookmark.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 0.3,
                        child: Container(
                            height: 450.h*0.9,
                            padding: EdgeInsets.only(
                              top: 1.h*0.9,
                              left: 26.w*0.84,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  highlightColor: Colors.white,
                                  onTap: () async {
                                    var result = await Get.toNamed("/listsub",
                                        arguments: {
                                          "data":
                                              controller.placeBookmark[index],
                                          "placeCode": 1,
                                          "index": index,
                                        });
                                    print("result $result");

                                    controller.setPlaceBookmarkOne(
                                        index, result[0]);
                                    controller.setPlacetotal(
                                        index, "${result[1]}");
                                  },
                                  child: Container(
                                    width: 1150.w*0.84,
                                    //     color:Colors.pink,
                                    margin: EdgeInsets.only(top:15.h),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        (() {
                                          if (index % 4 == 1) {
                                            return Image.asset(
                                              listimage[0],
                                              height: 413.w*0.84,
                                              width: 413.w*0.84,
                                            );
                                          } else if (index % 4 == 2) {
                                            return Image.asset(
                                              listimage[1],
                                              height: 413.w*0.84,
                                              width: 413.w*0.84,
                                            );
                                          } else if (index % 4 == 3) {
                                            return Image.asset(
                                              listimage[2],
                                              height: 413.w*0.84,
                                              width: 413.w*0.84,
                                            );
                                          } else {
                                            return Image.asset(
                                              listimage[3],
                                              height: 413.w*0.84,
                                              width: 413.w*0.84,
                                            );
                                          }
                                        }()),
                                        Padding(
                                            padding: EdgeInsets.only(
                                          left: 53.w*0.84,
                                        )),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [

                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      top: 5.h*0.9),
                                                 // width: 700.w*0.84,
                                                  height: 82.h*0.9,
                                                  child: controller.placeBookmark[index]
                                                      .name.length >
                                                      10
                                                      ? normalfont(
                                                      '${controller.placeBookmark[index].name.substring(0, 10)}...',
                                                      50,
                                                      Colors.black)
                                                      : normalfont(
                                                      controller
                                                          .placeBookmark[index].name,
                                                      50,
                                                      Colors.black),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Image.asset(
                                                  "./assets/listPage/star_color.png",
                                                  width: 30 * width.w*0.84,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 4.7 * width.w*0.84),
                                                ),
                                                normalfont(
                                                    "${controller.placeBookmark[index].total ?? 0.0} ",
                                                    46,
                                                    Color(0xff4d4d4d))
                                              ],
                                            ),
                                            Container(
                                              child: controller
                                                          .placeBookmark[index]
                                                          .address
                                                          .length >
                                                      14
                                                  ? normalfont(
                                                      '${controller.placeBookmark[index].address.substring(0, 14)}...',
                                                      46,
                                                      Color(0xffb0b0b0))
                                                  : normalfont(
                                                      controller
                                                          .placeBookmark[index]
                                                          .address,
                                                      46,
                                                      Color(0xffb0b0b0)),
                                            ),
                                            Container(
                                              margin:
                                                  EdgeInsets.only(top: 10.h*0.9),
                                              height: 120.h*0.9,
                                              width: 650.w*0.84,
                                              alignment: Alignment.bottomRight,
                                              child: Row(
                                                children: [
                                                  icon(
                                                    context,
                                                    controller
                                                        .placeBookmark[index]
                                                        .baby_menu,
                                                    controller
                                                        .placeBookmark[index]
                                                        .stroller,
                                                    controller
                                                        .placeBookmark[index]
                                                        .baby_bed,
                                                    controller
                                                        .placeBookmark[index]
                                                        .baby_tableware,
                                                    controller
                                                        .placeBookmark[index]
                                                        .nursing_room,
                                                    controller
                                                        .placeBookmark[index]
                                                        .meeting_room,
                                                    controller
                                                        .placeBookmark[index]
                                                        .diaper_change,
                                                    controller
                                                        .placeBookmark[index]
                                                        .play_room,
                                                    controller
                                                        .placeBookmark[index]
                                                        .baby_chair,
                                                    // PlaceController
                                                    //     .to.place[index].parking
                                                    //     .toString())
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Obx(
                                  () => Container(
                                    margin:
                                        EdgeInsets.only(left: 8.w*0.84, top: 40.h*0.9),
                                    child: InkWell(
                                      child: Container(
                                        padding: EdgeInsets.only(
                                            left: 30.w*0.84,
                                            right: 30.w*0.84,
                                            bottom: 10.h*0.9),
                                        child: Image.asset(
                                          controller.placeBookmark[index]
                                                      .bookmark ==
                                                  0
                                              ? "./assets/listPage/love_grey.png"
                                              : "./assets/listPage/love_color.png",
                                          height: 46.h*0.9,
                                        ),
                                      ),
                                      onTap: () async {
                                        await bookmark.bookmarkToogle(
                                            UserController.to.userId.value,
                                            controller.placeBookmark[index].id);
                                        controller.placeBookmark[index]
                                                    .bookmark ==
                                                0
                                            ? controller.setPlaceBookmarkOne(
                                                index, 1)
                                            : controller.setPlaceBookmarkOne(
                                                index, 0);

                                        // controller
                                        //     .starPlaceBookmarkrefresh(index);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      );
                    });
              }
            }())));
  }
}
