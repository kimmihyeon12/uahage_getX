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
import 'package:uahage/src/Static/Image/listImage.dart';
import 'package:uahage/src/Static/Widget/appbar.dart';
import 'package:uahage/src/Static/Widget/icon.dart';
import 'package:uahage/src/Static/url.dart';

class Star extends GetView<BookmarkController> {
  var listimage = [
    "./assets/listPage/clipGroup.png",
    "./assets/listPage/clipGroup1.png",
    "./assets/listPage/layer1.png",
    "./assets/listPage/layer2.png",
  ];
  String imgUrl = imgURL;
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
    ScreenUtil.init(context, width: 1500, height: 2667);
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
                      margin: EdgeInsets.only(top: 803.h),
                      child: Image.asset(
                        './assets/starPage/group.png',
                        height: 612.h,
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
                                    controller.setPlacetotal(index, result[1]);
                                  },
                                  child: Container(
                                    width: 1280.w,
                                    //     color:Colors.pink,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        (() {
                                          return Container(
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: NetworkImage(
                                                    (() {
                                                      if (!(controller
                                                              .placeBookmark[
                                                                  index]
                                                              .images ==
                                                          null)) {
                                                        return imgUrl +
                                                            controller
                                                                    .placeBookmark[
                                                                        index]
                                                                    .images[
                                                                "imagePath"];
                                                      } else {
                                                        if (index % 3 == 1)
                                                          return restaurantListImage[
                                                              0];
                                                        else if (index % 3 == 2)
                                                          return restaurantListImage[
                                                              1];
                                                        else
                                                          return restaurantListImage[
                                                              2];
                                                      }
                                                    }()),
                                                    scale: 0.1,
                                                  ),
                                                ),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10.0))),
                                            height: 413.w,
                                            width: 413.w,
                                          );
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
                                                padding:
                                                    EdgeInsets.only(top: 10.h)),
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
                                                        .placeBookmark[index]
                                                        .name,
                                                    style: TextStyle(
                                                      fontSize: 56.sp,
                                                      fontFamily:
                                                          'NotoSansCJKkr_Medium',
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Image.asset(
                                                  "./assets/listPage/star_color.png",
                                                  width: 30 * width.w,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 4.7 * width.w),
                                                ),
                                                normalfont(
                                                    "${controller.placeBookmark[index].reviewTotal ?? 0.0} ",
                                                    54,
                                                    Color(0xff4d4d4d))
                                              ],
                                            ),
                                            Container(
                                              child: controller
                                                          .placeBookmark[index]
                                                          .address
                                                          .length >
                                                      18
                                                  ? normalfont(
                                                      '${controller.placeBookmark[index].address.substring(0, 18)}...',
                                                      54,
                                                      Color(0xffb0b0b0))
                                                  : normalfont(
                                                      controller
                                                          .placeBookmark[index]
                                                          .address,
                                                      54,
                                                      Color(0xffb0b0b0)),
                                            ),
                                            Container(
                                              margin:
                                                  EdgeInsets.only(top: 10.h),
                                              height: 120.h,
                                              width: 650.w,
                                              alignment: Alignment.bottomRight,
                                              child: Row(
                                                children: [
                                                  controller
                                                              .placeBookmark[
                                                                  index]
                                                              .facility ==
                                                          null
                                                      ? Container()
                                                      : icon(
                                                          context,
                                                          controller
                                                                  .placeBookmark[
                                                                      index]
                                                                  .facility[
                                                              "babyMenu"],
                                                          controller
                                                                  .placeBookmark[
                                                                      index]
                                                                  .facility[
                                                              "stroller"],
                                                          controller
                                                                  .placeBookmark[
                                                                      index]
                                                                  .facility[
                                                              "babyBed"],
                                                          controller
                                                                  .placeBookmark[
                                                                      index]
                                                                  .facility[
                                                              "babyTableware"],
                                                          controller
                                                                  .placeBookmark[
                                                                      index]
                                                                  .facility[
                                                              "nursingRoom"],
                                                          controller
                                                                  .placeBookmark[
                                                                      index]
                                                                  .facility[
                                                              "meetingRoom"],
                                                          controller
                                                                  .placeBookmark[
                                                                      index]
                                                                  .facility[
                                                              "diaperChange"],
                                                          controller
                                                                  .placeBookmark[
                                                                      index]
                                                                  .facility[
                                                              "playRoom"],
                                                          controller
                                                                  .placeBookmark[
                                                                      index]
                                                                  .facility[
                                                              "babyChair"],
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
                                        EdgeInsets.only(left: 8.w, top: 25.h),
                                    child: InkWell(
                                      child: Container(
                                        padding: EdgeInsets.only(
                                            left: 30.w,
                                            right: 30.w,
                                            bottom: 10.h),
                                        child: Image.asset(
                                          !controller.placeBookmark[index]
                                                  .isBookmarked
                                              ? "./assets/listPage/love_grey.png"
                                              : "./assets/listPage/love_color.png",
                                          height: 55.h,
                                        ),
                                      ),
                                      onTap: () async {
                                        await bookmark.bookmarkToogle(
                                            UserController.to.userId.value,
                                            controller.placeBookmark[index].id);
                                        !controller.placeBookmark[index]
                                                .isBookmarked
                                            ? controller.setPlaceBookmarkOne(
                                                index, true)
                                            : controller.setPlaceBookmarkOne(
                                                index, false);

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
