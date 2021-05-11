import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:uahage/src/Controller/place.controller.dart';
import 'package:uahage/src/Controller/user.controller.dart';
import 'package:uahage/src/Service/bookmark.dart';

import 'package:uahage/src/Service/places.dart';
import 'package:uahage/src/Static/Widget/icon.dart';
import 'package:uahage/src/View/Nav/HomeSub/listMap.dart';
import '../../../Static/url.dart';
import 'package:uahage/src/Static/Widget/appbar.dart';

class PlaceList extends GetView<PlaceController> {
  String url = URL;
  Bookmark bookmark = new Bookmark();
  int placeCode = Get.arguments;
  ScrollController scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  getList() async {
    Place place = new Place();
    await place.getPlaceList(placeCode);
  }

  var restaurantListImage = [
    "https://uahage.s3.ap-northeast-2.amazonaws.com/restaurant_image/image1.png",
    "https://uahage.s3.ap-northeast-2.amazonaws.com/restaurant_image/image2.png",
    "https://uahage.s3.ap-northeast-2.amazonaws.com/restaurant_image/image3.png",
  ];
  var hospitalListImage = [
    "https://uahage.s3.ap-northeast-2.amazonaws.com/hospital_image/image1.png",
    "https://uahage.s3.ap-northeast-2.amazonaws.com/hospital_image/image2.png",
  ];
  var kidsCafeListImage = [
    "https://uahage.s3.ap-northeast-2.amazonaws.com/kids_cafe/image1.png",
    "https://uahage.s3.ap-northeast-2.amazonaws.com/kids_cafe/image2.png",
  ];
  var experienceListImage = [
    "https://uahage.s3.ap-northeast-2.amazonaws.com/experience_/image1.png",
    "https://uahage.s3.ap-northeast-2.amazonaws.com/experience_/image2.png",
    "https://uahage.s3.ap-northeast-2.amazonaws.com/experience_/image3.png",
    "https://uahage.s3.ap-northeast-2.amazonaws.com/experience_/image4.png",
  ];

  Widget build(BuildContext context) {
    Get.put(PlaceController());

    controller.placeInit();
    getList();
    scrollController.addListener(() {
      double maxScroll = scrollController.position.maxScrollExtent;
      double currentScroll = scrollController.position.pixels;
      if (currentScroll == maxScroll) {
        getList();
      }
    });

    ScreenUtil.init(context, width: 1500, height: 2667);

    return SafeArea(
      child: Obx(
        () => Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.white,
            appBar: appBar(
              context,
              (() {
                if (placeCode == 1) {
                  return "식당·카페";
                } else if (placeCode == 2) {
                  return "병원";
                } else if (placeCode == 5) {
                  return "키즈카페";
                } else {
                  return "체험관";
                }
              }()),
            ),
            body: Stack(
              children: [
                IndexedStack(
                    index: controller.indexCount.value,
                    children: <Widget>[
                      ListViews(),
                      ListMap(placeCode: placeCode),
                    ]),
                Container(
                  margin: EdgeInsets.only(left: 1100.w, top: 2200.w),
                  child: controller.indexCount.value == 1
                      ? GestureDetector(
                          onTap: () {
                            controller.changeindexCount(0);
                          },
                          child: Image.asset(
                            './assets/on.png',
                            width: 284.w,
                            height: 133.h,
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            controller.changeindexCount(1);
                          },
                          child: Image.asset(
                            './assets/off.png',
                            width: 284.w,
                            height: 133.h,
                          ),
                        ),
                ),
              ],
            )),
      ),
    );
  }

  ListViews() {
    return ListView.builder(
        controller: scrollController,
        itemCount: controller.place.length,
        shrinkWrap: true,
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
                        await Get.toNamed("/listsub", arguments: {
                          "data": controller.place[index],
                          "placeCode": placeCode,
                          "index": index,
                        });
                      },
                      child: Container(
                        width: 1280.w,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      (() {
                                        if (placeCode == 1) {
                                          if (index % 3 == 1)
                                            return restaurantListImage[0];
                                          else if (index % 3 == 2)
                                            return restaurantListImage[1];
                                          else
                                            return restaurantListImage[2];
                                        } else if (placeCode == 2) {
                                          if (index % 2 == 1)
                                            return hospitalListImage[0];
                                          else
                                            return hospitalListImage[1];
                                        } else if (placeCode == 6) {
                                          if (index % 4 == 1)
                                            return experienceListImage[0];
                                          else if (index % 4 == 2)
                                            return experienceListImage[1];
                                          else if (index % 4 == 3)
                                            return experienceListImage[2];
                                          else
                                            return experienceListImage[3];
                                        } else {
                                          if (index % 2 == 1)
                                            return kidsCafeListImage[0];
                                          else
                                            return kidsCafeListImage[1];
                                        }
                                      }()),
                                    ),
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0))),
                              height: 414.h,
                              width: 413.w,
                            ),
                            Padding(
                                padding: EdgeInsets.only(
                              left: 53.w,
                            )),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(padding: EdgeInsets.only(top: 10.h)),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(top: 20.h),
                                      width: 700.w,
                                      height: 82.h,
                                      child: Text(
                                        controller.place[index].name,
                                        style: TextStyle(
                                          fontSize: 56.sp,
                                          fontFamily: 'NotoSansCJKkr_Medium',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  height: 135.h,
                                  width: 650.w,
                                  child: Text(
                                    controller.place[index].address,
                                    style: TextStyle(
                                      // fontFamily: 'NatoSans',
                                      color: Colors.grey,
                                      fontSize: 56.sp,
                                      fontFamily: 'NotoSansCJKkr_Medium',
                                      height: 1.3,
                                    ),
                                  ),
                                ),
                                placeCode == 1
                                    ? Container(
                                        margin: EdgeInsets.only(top: 15.h),
                                        height: 120.h,
                                        width: 650.w,
                                        alignment: Alignment.bottomRight,
                                        child: Row(
                                          children: [
                                            icon(
                                                context,
                                                PlaceController
                                                    .to.place[index].menu
                                                    .toString(),
                                                PlaceController
                                                    .to.place[index].carriage
                                                    .toString(),
                                                PlaceController
                                                    .to.place[index].bed
                                                    .toString(),
                                                PlaceController
                                                    .to.place[index].tableware
                                                    .toString(),
                                                PlaceController
                                                    .to.place[index].nursingroom
                                                    .toString(),
                                                PlaceController
                                                    .to.place[index].meetingroom
                                                    .toString(),
                                                PlaceController
                                                    .to.place[index].diapers
                                                    .toString(),
                                                PlaceController
                                                    .to.place[index].playroom
                                                    .toString(),
                                                PlaceController
                                                    .to.place[index].chair
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
                    Obx(
                      () => Container(
                        margin: EdgeInsets.only(left: 8.w, top: 25.h),
                        child: InkWell(
                          child: Container(
                            padding: EdgeInsets.only(
                                left: 30.w, right: 30.w, bottom: 10.h),
                            child: Image.asset(
                              controller.place[index].bookmark == 0
                                  ? "./assets/listPage/love_grey.png"
                                  : "./assets/listPage/love_color.png",
                              height: 55.h,
                            ),
                          ),
                          onTap: () async {
                            if (controller.place[index].bookmark == 0) {
                              await bookmark.bookmarkCreate(
                                  UserController.to.userId.value,
                                  controller.place[index].id);
                              controller.setPlaceBookmark(index, 1);
                              print(controller.place[index].bookmark);
                            } else {
                              await bookmark.bookmarkDelete(
                                  UserController.to.userId.value,
                                  controller.place[index].id);
                              controller.setPlaceBookmark(index, 0);
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                )),
          );
        });
  }
}
