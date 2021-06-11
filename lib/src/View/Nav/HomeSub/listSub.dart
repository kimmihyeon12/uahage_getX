import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:clipboard/clipboard.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/search.dart';
import 'package:uahage/src/Controller/connection.controller.dart';
import 'package:uahage/src/Controller/place.controller.dart';
import 'package:uahage/src/Controller/place.restaurant.bookmark.controller.dart';
import 'package:uahage/src/Controller/user.controller.dart';
import 'package:uahage/src/Model/review.dart';
import 'package:uahage/src/Service/connection.dart';
import 'package:uahage/src/Service/places.dart';
import 'package:http/http.dart' as http;
import 'package:uahage/src/Service/places.restaurant.bookmarks.dart';
import 'package:uahage/src/Service/review.dart';
import 'package:uahage/src/Static/Font/font.dart';
import 'package:uahage/src/Static/Widget/appbar.dart';
import 'package:uahage/src/Static/Widget/average.dart';
import 'package:uahage/src/Static/Widget/dialog.dart';
import 'package:uahage/src/Static/Widget/imageBig.dart';
import 'package:uahage/src/Static/Widget/popup.dart';
import 'package:uahage/src/Static/Widget/progress.dart';
import 'package:uahage/src/Static/Widget/toast.dart';
import 'package:uahage/src/Static/url.dart';
import 'package:uahage/src/View/Nav/HomeSub/review.dart';
import 'package:uahage/src/View/Nav/HomeSub/reviewImage.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ListSub extends StatefulWidget {
  @override
  _ListSubState createState() => _ListSubState();
}

class _ListSubState extends State<ListSub> {
  WebViewController _controller;
  String url = URL;
  int placeCode = Get.arguments['placeCode'];
  var data = Get.arguments['data'];
  int index = Get.arguments['index'];
  var width = 1500 / 720;
  var height = 2667 / 1280;
  Bookmark bookmark = new Bookmark();
  List<Review> reviewData = <Review>[];
  List prevImage = [];
  var imagecolor = [
    "./assets/searchPage/image1.png",
    "./assets/searchPage/image2.png",
    "./assets/searchPage/image3.png",
    "./assets/searchPage/image4.png",
    "./assets/searchPage/image5.png",
    "./assets/searchPage/image6.png",
    "./assets/searchPage/image7.png",
    "./assets/searchPage/image8.png",
    "./assets/searchPage/image9.png",
    "./assets/searchPage/image10.png"
  ];
  var imagegrey = [
    "./assets/searchPage/image1_grey.png",
    "./assets/searchPage/image2_grey.png",
    "./assets/searchPage/image3_grey.png",
    "./assets/searchPage/image4_grey.png",
    "./assets/searchPage/image5_grey.png",
    "./assets/searchPage/image6_grey.png",
    "./assets/searchPage/image7_grey.png",
    "./assets/searchPage/image8_grey.png",
    "./assets/searchPage/image9_grey.png",
    "./assets/searchPage/image10_grey.png"
  ];

  var mainimage = [
    "https://uahage.s3.ap-northeast-2.amazonaws.com/images_sublist/image1.png",
    "https://uahage.s3.ap-northeast-2.amazonaws.com/images_sublist/image2.png",
    "https://uahage.s3.ap-northeast-2.amazonaws.com/images_sublist/image3.png"
  ];

  var restaurantListImage = [
    "https://uahage.s3.ap-northeast-2.amazonaws.com/images_sublist/image1.png",
    "https://uahage.s3.ap-northeast-2.amazonaws.com/images_sublist/image2.png",
    "https://uahage.s3.ap-northeast-2.amazonaws.com/images_sublist/image3.png"
  ];
  var hospitalListImage = [
    "https://uahage.s3.ap-northeast-2.amazonaws.com/images_exam_sublist_/image2.png",
    "https://uahage.s3.ap-northeast-2.amazonaws.com/images_exam_sublist_/image1.png",
  ];
  var kidsCafeListImage = [
    "https://uahage.s3.ap-northeast-2.amazonaws.com/images_kidscafe_sublist/image1.png",
    "https://uahage.s3.ap-northeast-2.amazonaws.com/images_kidscafe_sublist/image2.png",
  ];
  var experienceListImage = [
    "https://uahage.s3.ap-northeast-2.amazonaws.com/images_experience_sublist/image1.png",
    "https://uahage.s3.ap-northeast-2.amazonaws.com/images_experience_sublist/image2.png",
    "https://uahage.s3.ap-northeast-2.amazonaws.com/images_experience_sublist/image3.png",
    "https://uahage.s3.ap-northeast-2.amazonaws.com/images_experience_sublist/image4.png",
  ];
  mainImage(image, screenWidth) {
    return CachedNetworkImage(
      imageUrl: image,
      fit: BoxFit.fitWidth,
    );
  }

  var option = "DATE";
  List imageList = [];
  double aver = 0;
  double averStar = 0;
  select(option) async {
    reviewData = [];
    imageList = [];
    var responseJson = await reviewSelect(data.id, option);

    var currentData;
    print(responseJson);

    var i = 0;
    for (var data in responseJson["data"]) {
      currentData = Review.fromJson(data);

      reviewData.add(currentData);
      reviewData[i].image_path != null
          ? imageList.add(reviewData[i].image_path.split(','))
          : imageList.add(null);

      i++;
    }
    setState(() {
      aver = responseJson["average"] ?? 0;
      averStar = ((aver * 2).ceil()) / 2;
      print(averStar);
    });
  }

  delete(reviewId) async {
    await reviewDelete(reviewId);
  }

  @override
  void initState() {
    super.initState();
    select("DATE");
  }

  int count = 0;
  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < imageList.length; i++) {
      if (imageList[i] != null) {
        for (int j = 0; j < imageList[i].length; j++) {
          if (count < 4 && imageList[i] != null) {
            prevImage.add(imageList[i][j]);
            count++;
          }
        }
      }
    }
    print("listsub");
    connection();
    print(imageList);

    ScreenUtil.init(context, width: 1500, height: 2667);
    return WillPopScope(
      onWillPop: () {
        if (placeCode == 1)
          Get.back(result: data.bookmark);
        else
          Get.back(result: "");
      },
      child: SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: (() {
              if (placeCode == 1)
                return appBar(
                  context,
                  data.name,
                  data.bookmark,
                );
              else
                return appBar(context, data.name, "");
            }()),
            body: ListView(
              children: [
                Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 1500.w,
                          child: (() {
                            if (placeCode == 1) {
                              if (index % 3 == 1) {
                                return mainImage(
                                    restaurantListImage[0], 1500.w);
                              } else if (index % 3 == 2) {
                                return mainImage(
                                    restaurantListImage[1], 1500.w);
                              } else
                                return mainImage(
                                    restaurantListImage[2], 1500.w);
                            } else if (placeCode == 2) {
                              if (index % 2 == 1)
                                return mainImage(hospitalListImage[0], 1500.w);
                              else
                                return mainImage(hospitalListImage[1], 1500.w);
                            } else if (placeCode == 5) {
                              if (index % 2 == 1)
                                return mainImage(kidsCafeListImage[0], 1500.w);
                              else
                                return mainImage(kidsCafeListImage[1], 1500.w);
                            } else {
                              if (index % 4 == 1)
                                return mainImage(
                                    experienceListImage[0], 1500.w);
                              else if (index % 4 == 2)
                                return mainImage(
                                    experienceListImage[1], 1500.w);
                              else if (index % 4 == 3)
                                return mainImage(
                                    experienceListImage[2], 1500.w);
                              else
                                return mainImage(
                                    experienceListImage[3], 1500.w);
                            }
                          }()),
                        ),
                        Container(
                          child: Container(
                            padding: EdgeInsets.only(
                                left: 75.w, top: 45.h, bottom: 45.h),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 1250.w,
                                      child:
                                          boldfont(data.name, 77, Colors.black),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: 20.w,
                                      ),
                                    ),
                                    (() {
                                      if (placeCode == 1) {
                                        return IconButton(
                                          padding: EdgeInsets.all(0),
                                          constraints: BoxConstraints(
                                              maxWidth: 170.w,
                                              maxHeight: 170.h),
                                          icon: Image.asset(
                                              data.bookmark == 0
                                                  ? "./assets/listPage/love_grey.png"
                                                  : "./assets/listPage/love_color.png",
                                              height: 60.h),
                                          onPressed: () async {
                                            if (data.bookmark == 0) {
                                              await bookmark.bookmarkToogle(
                                                  UserController
                                                      .to.userId.value,
                                                  data.id);
                                              setState(() {
                                                data.bookmark = 1;
                                              });
                                            } else {
                                              await bookmark.bookmarkToogle(
                                                  UserController
                                                      .to.userId.value,
                                                  data.id);
                                              setState(() {
                                                data.bookmark = 0;
                                              });
                                            }
                                          },
                                        );
                                      } else
                                        return Container();
                                    }())
                                  ],
                                ),
                                Padding(
                                    padding: EdgeInsets.only(
                                  top: 3.3 * height.h,
                                )),
                                placeCode == 1
                                    ? Row(
                                        children: [
                                          for (int i = 0;
                                              i < averStar.toInt();
                                              i++)
                                            Container(
                                              margin: EdgeInsets.only(
                                                  right: 12 * width.w),
                                              child: Image.asset(
                                                "./assets/listPage/star_color.png",
                                                width: 38 * width.w,
                                              ),
                                            ),
                                          (averStar - averStar.toInt() == 0.5)
                                              ? Container(
                                                  margin: EdgeInsets.only(
                                                      right: 12 * width.w),
                                                  child: Image.asset(
                                                    "./assets/listPage/star_half.png",
                                                    width: 38 * width.w,
                                                  ),
                                                )
                                              : Container(
                                                  margin: EdgeInsets.only(
                                                      right: 12 * width.w),
                                                  child: Image.asset(
                                                    "./assets/listPage/star_color.png",
                                                    width: 38 * width.w,
                                                  ),
                                                ),
                                          for (int i = 0;
                                              i < 5 - averStar.toInt() - 1;
                                              i++)
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: 12 * width.w),
                                              child: Image.asset(
                                                "./assets/listPage/star_grey.png",
                                                width: 38 * width.w,
                                              ),
                                            ),
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  left: 12 * width.w)),
                                          Text('${aver}',
                                              style: TextStyle(
                                                color: Color(0xff4d4d4d),
                                                fontSize: 30 * width.sp,
                                                fontFamily:
                                                    "NotoSansCJKkr_Medium",
                                              )),
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  left: 12 * width.w)),
                                          Text(
                                              '${reviewData.length}명이 평가에 참여했습니다',
                                              style: TextStyle(
                                                color: Color(0xffc6c6c6),
                                                fontSize: 25 * width.sp,
                                                fontFamily:
                                                    "NotoSansCJKkr_Medium",
                                              ))
                                        ],
                                      )
                                    : Container()
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 2.h,
                          color: Color(0xfff7f7f7),
                        ),
                        Container(
                          child: Container(
                            padding: EdgeInsets.only(
                              left: 75.w,
                            ),
                            width: MediaQuery.of(context).size.width,
                            // alignment: Alignment.center,
                            //  height: 520 .h,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                    padding: EdgeInsets.only(
                                  top: 50.w,
                                )),
                                normalfont("주소", 58, Color(0xff4d4d4d)),
                                Padding(padding: EdgeInsets.only(top: 10.w)),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 965.w,
                                      child: normalfont("${data.address}", 58,
                                          Color(0xff808080)),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(left: 100.w)),
                                    GestureDetector(
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            "./assets/sublistPage/copy.png",
                                            width: 250.w,
                                            height: 56.h,
                                          ),
                                        ],
                                      ),
                                      onTap: () {
                                        FlutterClipboard.copy(data.address);
                                        toast(context, "주소가 복사되었습니다");
                                      },
                                    )
                                  ],
                                ),
                                Padding(padding: EdgeInsets.only(top: 30.w)),
                                normalfont("연락처", 58, Color(0xff4d4d4d)),
                                Padding(
                                    padding: EdgeInsets.only(
                                  top: 10.w,
                                )),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 955.w,
                                      child: normalfont("${data.phone}", 58,
                                          Color(0xff808080)),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(left: 100.w)),
                                    GestureDetector(
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            "./assets/sublistPage/call.png",
                                            width: 250.w,
                                            height: 76.h,
                                          ),
                                        ],
                                      ),
                                      onTap: () {
                                        FlutterClipboard.copy(data.address);
                                        toast(context, "번호가 복사되었습니다");
                                      },
                                    )
                                  ],
                                ),
                                placeCode == 1
                                    ? Padding(
                                        padding: EdgeInsets.only(top: 30.w))
                                    : Padding(
                                        padding: EdgeInsets.only(top: 0.w)),
                                placeCode == 1
                                    ? normalfont("영업시간", 58, Color(0xff4d4d4d))
                                    : Container(),
                                placeCode == 1
                                    ? Padding(
                                        padding: EdgeInsets.only(top: 10.w))
                                    : Padding(
                                        padding: EdgeInsets.only(top: 0.w)),
                                placeCode == 1
                                    ? Container(
                                        width: 500 * width.w,
                                        child: normalfont(
                                            "오전 11:30 ~ 21:00(샐러드바 마감 20:30) 브레이크타임 15:00~17:00",
                                            58,
                                            Color(0xff808080)),
                                      )
                                    : Container(),
                                Padding(padding: EdgeInsets.only(top: 30.w))
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 26 * height.h,
                          color: Color(0xfff7f7f7),
                        ),
                        placeCode == 1
                            ? Container(
                                child: Container(
                                  padding: EdgeInsets.only(
                                    left: 75.w,
                                  ),
                                  width: MediaQuery.of(context).size.width,
                                  // alignment: Alignment.center,
                                  //  height: 520 .h,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                          padding: EdgeInsets.only(top: 30.h)),
                                      normalfont("매장정보", 58, Color(0xff4d4d4d)),
                                      Padding(
                                          padding: EdgeInsets.only(top: 6.h)),
                                      Row(
                                        children: [
                                          Container(
                                            width: 530.w,
                                            child: normalfont("OO 평일런치", 58,
                                                Color(0xff808080)),
                                          ),
                                          Container(
                                            child: normalfont("15,900원", 58,
                                                Color(0xffc6c6c6)),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(top: 6.h)),
                                      Row(
                                        children: [
                                          Container(
                                            width: 530.w,
                                            child: normalfont("OO 평일디너", 58,
                                                Color(0xff808080)),
                                          ),
                                          Container(
                                            child: normalfont("22,900원", 58,
                                                Color(0xffc6c6c6)),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(top: 6.h)),
                                      Row(
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                width: 530.w,
                                                child: normalfont("OO 주말/공휴일",
                                                    58, Color(0xff808080)),
                                              ),
                                              Container(
                                                child: normalfont("25,900원", 58,
                                                    Color(0xffc6c6c6)),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(top: 30.h)),
                                    ],
                                  ),
                                ),
                              )
                            : Container(),
                        placeCode == 1
                            ? Container(
                                height: 26 * height.h, color: Color(0xfff7f7f7))
                            : Container(),
                        (() {
                          if (placeCode == 1) {
                            return Container(
                              child: Container(
                                height: 928.h,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                        left: 75.w,
                                        top: 50.h,
                                      ),
                                      child: normalfont(
                                          "편의시설", 58, Color(0xff4d4d4d)),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(top: 50.h)),
                                    Row(
                                        // crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                              padding:
                                                  EdgeInsets.only(left: 67.w)),
                                          data.baby_menu == true
                                              ? Image.asset(
                                                  imagecolor[0],
                                                  width: 218.w,
                                                  height: 292.h,
                                                )
                                              : Image.asset(
                                                  imagegrey[0],
                                                  width: 218.w,
                                                  height: 292.h,
                                                ),
                                          Padding(
                                              padding:
                                                  EdgeInsets.only(left: 59.w)),
                                          data.baby_bed == true
                                              ? Image.asset(
                                                  imagecolor[1],
                                                  width: 218.w,
                                                  height: 292.h,
                                                )
                                              : Image.asset(
                                                  imagegrey[1],
                                                  width: 218.w,
                                                  height: 292.h,
                                                ),
                                          Padding(
                                              padding:
                                                  EdgeInsets.only(left: 59.w)),
                                          data.baby_tableware == true
                                              ? Image.asset(
                                                  imagecolor[2],
                                                  width: 218.w,
                                                  height: 292.h,
                                                )
                                              : Image.asset(
                                                  imagegrey[2],
                                                  width: 218.w,
                                                  height: 292.h,
                                                ),
                                          Padding(
                                              padding:
                                                  EdgeInsets.only(left: 59.w)),
                                          data.meeting_room == true
                                              ? Image.asset(
                                                  imagecolor[3],
                                                  width: 218.w,
                                                  height: 292.h,
                                                )
                                              : Image.asset(
                                                  imagegrey[3],
                                                  width: 218.w,
                                                  height: 292.h,
                                                ),
                                          Padding(
                                              padding:
                                                  EdgeInsets.only(left: 59.w)),
                                          data.diaper_change == true
                                              ? Image.asset(
                                                  imagecolor[4],
                                                  width: 231.w,
                                                  height: 284.h,
                                                )
                                              : Image.asset(
                                                  imagegrey[4],
                                                  width: 231.w,
                                                  height: 284.h,
                                                ),
                                          Padding(
                                              padding:
                                                  EdgeInsets.only(left: 59.w)),
                                        ]),
                                    Padding(
                                        padding: EdgeInsets.only(top: 50.h)),
                                    Row(
                                      children: [
                                        Padding(
                                            padding:
                                                EdgeInsets.only(left: 67.w)),
                                        data.play_room == true
                                            ? Image.asset(
                                                imagecolor[5],
                                                width: 218.w,
                                                height: 292.h,
                                              )
                                            : Image.asset(
                                                imagegrey[5],
                                                width: 218.w,
                                                height: 292.h,
                                              ),
                                        Padding(
                                            padding:
                                                EdgeInsets.only(left: 59.w)),
                                        data.stroller == true
                                            ? Image.asset(
                                                imagecolor[6],
                                                width: 218.w,
                                                height: 292.h,
                                              )
                                            : Image.asset(
                                                imagegrey[6],
                                                width: 218.w,
                                                height: 292.h,
                                              ),
                                        Padding(
                                            padding:
                                                EdgeInsets.only(left: 59.w)),
                                        data.nursing_room == true
                                            ? Image.asset(
                                                imagecolor[7],
                                                width: 218.w,
                                                height: 292.h,
                                              )
                                            : Image.asset(
                                                imagegrey[7],
                                                width: 218.w,
                                                height: 292.h,
                                              ),
                                        Padding(
                                            padding:
                                                EdgeInsets.only(left: 59.w)),
                                        data.baby_chair == true
                                            ? Image.asset(
                                                imagecolor[8],
                                                width: 218.w,
                                                height: 292.h,
                                              )
                                            : Image.asset(
                                                imagegrey[8],
                                                width: 218.w,
                                                height: 292.h,
                                              )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else if (placeCode == 2) {
                            return Container(
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.only(
                                  left: 75.w,
                                  top: 50.h,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    normalfont("검진항복", 58, Color(0xff4d4d4d)),
                                    Padding(
                                        padding: EdgeInsets.only(top: 10.h)),
                                    normalfont("${data.examination_items}", 58,
                                        Color(0xff808080)),
                                    Padding(
                                        padding: EdgeInsets.only(top: 50.h)),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return Container(
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.only(
                                  left: 75.w,
                                  top: 50.h,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    normalfont(
                                        "관람 / 체험료", 58, Color(0xff4d4d4d)),
                                    Padding(
                                        padding: EdgeInsets.only(top: 10.h)),
                                    normalfont("${data.admission_fee}", 58,
                                        Color(0xff808080)),
                                    Padding(
                                        padding: EdgeInsets.only(top: 50.h)),
                                  ],
                                ),
                              ),
                            );
                          }
                        }()),
                        Container(
                          height: 26 * height.h,
                          color: Color(0xfff7f7f7),
                        ),
                        ConnectionController.to.connectionstauts !=
                                "ConnectivityResult.none"
                            ? Container(
                                child: Container(
                                //  height: 1300 .h,
                                width: 1500.w,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(
                                          left: 75.w,
                                          top: 50.h,
                                        ),
                                        child: normalfont(
                                            "위치", 58, Color(0xff4d4d4d)),
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(top: 30.h)),
                                      Container(
                                        height: 1100.h,
                                        child: WebView(
                                          // gestureNavigationEnabled: true,
                                          onWebViewCreated: (WebViewController
                                              webViewController) {
                                            _controller = webViewController;
                                            _controller.loadUrl(url +
                                                '/maps/show-place-name?placeName=${data.name}&placeAddress=${data.address}');
                                          },
                                          javascriptMode:
                                              JavascriptMode.unrestricted,
                                        ),
                                      ),
                                    ]),
                              ))
                            : progress(),
                        Container(
                          child: Container(
                            height: 170.h,
                            child: Center(
                              child: Image.asset(
                                "./assets/sublistPage/modify.png",
                                height: 80.h,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 26 * height.h,
                          color: Color(0xfff7f7f7),
                        ),
                        Container(
                            margin: EdgeInsets.only(
                              left: 87 * width.w,
                              top: 36 * height.h,
                            ),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        width: 210 * height.h,
                                        child: Column(
                                          children: [
                                            normalfont("${data.name}", 58,
                                                Colors.black),
                                            normalfont("다녀오셨나요?", 58,
                                                Color(0xff939393)),
                                          ],
                                        )),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: 44 * width.w,
                                      ),
                                    ),
                                    InkWell(
                                      child: Image.asset(
                                        "./assets/sublistPage/reviewbutton.png",
                                        height: 54 * height.h,
                                      ),
                                      onTap: () async {
                                        var result = await Get.to(ReviewPage(
                                            reviewData: reviewData[index],
                                            data: data));

                                        if (result == "ok") {
                                          await select(option);
                                          setState(() {});
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            )),
                        Container(
                          margin: EdgeInsets.only(
                              left: 36 * width.w, top: 36 * width.h),
                          child: Stack(
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.4),
                                          offset: Offset(0.0, 0.1), //(x,y)
                                          blurRadius: 7.0,
                                          spreadRadius: 1,
                                        ),
                                      ],
                                      border: Border.all(
                                        color: Colors.white,
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  height: 193 * height.h,
                                  width: 648 * width.w),
                              Row(
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 22 * height.h),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding:
                                            EdgeInsets.only(top: 22 * height.h),
                                      ),
                                      normalfont("고객만족도", 24 * width,
                                          Color(0xff939393)),
                                      boldfont('${aver}', 55 * width,
                                          Color(0xff3a3939)),
                                      Row(
                                        children: [
                                          for (int i = 0;
                                              i < averStar.toInt();
                                              i++)
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: 12 * width.w),
                                              child: Image.asset(
                                                "./assets/listPage/star_color.png",
                                                width: 38 * width.w,
                                              ),
                                            ),
                                          (averStar - averStar.toInt() == 0.5)
                                              ? Container(
                                                  margin: EdgeInsets.only(
                                                      left: 12 * width.w),
                                                  child: Image.asset(
                                                    "./assets/listPage/star_half.png",
                                                    width: 38 * width.w,
                                                  ),
                                                )
                                              : Container(
                                                  margin: EdgeInsets.only(
                                                      left: 12 * width.w),
                                                  child: Image.asset(
                                                    "./assets/listPage/star_color.png",
                                                    width: 38 * width.w,
                                                  ),
                                                ),
                                          for (int i = 0;
                                              i < 5 - averStar.toInt() - 1;
                                              i++)
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: 12 * width.w),
                                              child: Image.asset(
                                                "./assets/listPage/star_grey.png",
                                                width: 38 * width.w,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(top: 36 * width.w)),

                        // 4 images

                        Row(
                          children: [
                            Padding(padding: EdgeInsets.only(left: 36.w)),
                            for (int i = 0; i < prevImage.length; i++)
                              i < 3
                                  ? Container(
                                      margin:
                                          EdgeInsets.only(left: 18 * width.w),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        child: SizedBox(
                                          width: 148 * width.w,
                                          height: 148 * height.w,
                                          child: Image.network(
                                            prevImage[i],
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    )
                                  : InkWell(
                                      onTap: () {
                                        Get.to(ReviewImage(data: data));
                                      },
                                      child: Container(
                                        margin:
                                            EdgeInsets.only(left: 18 * width.w),
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            child: Stack(
                                              children: [
                                                SizedBox(
                                                  width: 148 * width.w,
                                                  height: 148 * height.w,
                                                  child: Image.network(
                                                    prevImage[i],
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                Container(
                                                  width: 148 * width.w,
                                                  height: 148 * height.w,
                                                  color: Colors.black
                                                      .withOpacity(0.5),
                                                ),
                                                Container(
                                                  width: 148 * width.w,
                                                  height: 148 * width.w,
                                                  child: Center(
                                                    child: Image.asset(
                                                      "./assets/reviewPage/plus.png",
                                                      color: Colors.white,
                                                      width: 38 * width.w,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            )),
                                      ),
                                    ),
                          ],
                        ),

                        Padding(padding: EdgeInsets.only(top: 36 * width.w)),
                        Container(
                          height: 26 * height.h,
                          color: Color(0xfff7f7f7),
                        ),

                        //Sorting condition
                        Container(
                          // height: 20.h,
                          width: double.infinity,
                          child: Row(
                            children: [
                              Padding(
                                  padding: EdgeInsets.only(
                                      top: 80 * height.h, left: 35 * width.w)),
                              normalfont("리뷰 ", 30 * width, Color(0xff4d4d4d)),
                              normalfont(reviewData.length.toString(),
                                  30 * width, Color(0xffe9718d)),
                              Spacer(),
                              Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        option = "DATE";
                                        select(option);
                                      },
                                      child: normalfont(
                                          "최신순",
                                          26 * width,
                                          option == "DATE"
                                              ? Color(0xff4d4d4d)
                                              : Color(0xff939393)),
                                    ),
                                    normalfont(
                                        " | ", 26 * width, Color(0xffdddddd)),
                                    InkWell(
                                      onTap: () {
                                        option = "TOP";
                                        select(option);
                                      },
                                      child: normalfont(
                                          "평점높은순",
                                          26 * width,
                                          option == "TOP"
                                              ? Color(0xff4d4d4d)
                                              : Color(0xff939393)),
                                    ),
                                    normalfont(
                                        " | ", 26 * width, Color(0xffdddddd)),
                                    InkWell(
                                      onTap: () {
                                        option = "LOW";
                                        select(option);
                                      },
                                      child: normalfont(
                                          "평점낮은순",
                                          26 * width,
                                          option == "LOW"
                                              ? Color(0xff4d4d4d)
                                              : Color(0xff939393)),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(padding: EdgeInsets.only(right: 38.w)),
                            ],
                          ),
                        ),
                        (() {
                          return Container(
                            child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: reviewData.length,
                              itemBuilder: (context, index) {
                                if (reviewData.length == 0) {
                                  print("로딩중");
                                  return Container(
                                    child: Text(" 로딩중 "),
                                  );
                                }
                                return Container(
                                  width: double.infinity,
                                  color: Colors.white,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.fromLTRB(
                                            40 * width.w,
                                            30.h,
                                            40 * width.w,
                                            33.h),
                                        width: double.infinity,
                                        child: Column(
                                          children: [
                                            // first container
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                CircleAvatar(
                                                  radius: 40 * width.w,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      image: DecorationImage(
                                                          image: NetworkImage(
                                                              reviewData[index]
                                                                  .profile),
                                                          fit: BoxFit.cover),
                                                    ),
                                                  ),
                                                ),
                                                // Container after avatar image
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      left: 15 * width.w),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      // userName
                                                      Row(
                                                        children: [
                                                          boldfont(
                                                              "${reviewData[index].nickname} ",
                                                              58,
                                                              Colors.black),
                                                          Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 16 *
                                                                          width
                                                                              .w)),
                                                          normalfont(
                                                              "${reviewData[index].created_at} ",
                                                              58,
                                                              Color(
                                                                  0xff808080)),
                                                        ],
                                                      ),
                                                      // 3 Rating buttons
                                                      Row(
                                                        children: [
                                                          average(
                                                              110 * width.w,
                                                              '맛',
                                                              "${reviewData[index].taste_rating}"),
                                                          Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 8 *
                                                                          width
                                                                              .w)),
                                                          average(
                                                              115 * width.w,
                                                              '가격',
                                                              "${reviewData[index].cost_rating}"),
                                                          Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left:
                                                                          8.w)),
                                                          average(
                                                              140 * width.w,
                                                              '서비스',
                                                              "${reviewData[index].service_rating}"),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Spacer(),
                                                UserController.to.userId ==
                                                        reviewData[index]
                                                            .user_id
                                                            .toString()
                                                    ? Row(
                                                        children: [
                                                          InkWell(
                                                            onTap: () async {
                                                              var result = await Get
                                                                  .to(ReviewPage(
                                                                      reviewData:
                                                                          reviewData[
                                                                              index],
                                                                      data:
                                                                          data));
                                                              if (result ==
                                                                  "ok") {
                                                                await select(
                                                                    option);
                                                                setState(() {});
                                                              }
                                                            },
                                                            child: Text(
                                                              "수정",
                                                              style: TextStyle(
                                                                  fontSize: 24 *
                                                                      width.sp,
                                                                  fontFamily:
                                                                      "NotoSansCJKkr_Medium",
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          147,
                                                                          147,
                                                                          147,
                                                                          1.0)),
                                                            ),
                                                          ),
                                                          Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 20 *
                                                                          width
                                                                              .w)),
                                                          InkWell(
                                                            onTap: () {
                                                              return showDialog(
                                                                context:
                                                                    context,
                                                                barrierDismissible:
                                                                    false, // user must tap button!
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return AlertDialog(
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(20.0)),
                                                                    ),
                                                                    title: normalfont(
                                                                        "리뷰를 삭제하시겠습니까",
                                                                        62.5,
                                                                        Color(
                                                                            0xff4d4d4d)),
                                                                    actions: <
                                                                        Widget>[
                                                                      FlatButton(
                                                                        child: normalfont(
                                                                            "예",
                                                                            62.5,
                                                                            Color(0xffff7292)),
                                                                        onPressed:
                                                                            () async {
                                                                          Navigator.pop(
                                                                              context,
                                                                              "OK");
                                                                          await delete(
                                                                              reviewData[index].id);
                                                                          await select(
                                                                              option);
                                                                        },
                                                                      ),
                                                                      FlatButton(
                                                                        child: normalfont(
                                                                            "아니오",
                                                                            62.5,
                                                                            Color(0xffff7292)),
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context,
                                                                              "Cancel");
                                                                        },
                                                                      ),
                                                                    ],
                                                                  );
                                                                },
                                                              );
                                                            },
                                                            child: Text(
                                                              "삭제",
                                                              style: TextStyle(
                                                                  fontSize: 24 *
                                                                      width.sp,
                                                                  fontFamily:
                                                                      "NotoSansCJKkr_Medium",
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          147,
                                                                          147,
                                                                          147,
                                                                          1.0)),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    : InkWell(
                                                        onTap: () {
                                                          report(
                                                              context,
                                                              reviewData[index]
                                                                  .id);
                                                        },
                                                        child: Text(
                                                          "신고",
                                                          style: TextStyle(
                                                              fontSize:
                                                                  24 * width.sp,
                                                              fontFamily:
                                                                  "NotoSansCJKkr_Medium",
                                                              color: Color
                                                                  .fromRGBO(
                                                                      147,
                                                                      147,
                                                                      147,
                                                                      1.0)),
                                                        ),
                                                      ),
                                              ],
                                            ),
                                            //text message
                                            Container(
                                              width: double.infinity,
                                              margin: EdgeInsets.only(
                                                  top: 16 * width.w),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 13 * width.w,
                                                  vertical: 19 * width.w),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(10),
                                                ),
                                                color: Color.fromRGBO(
                                                    248, 248, 248, 1.0),
                                              ),
                                              child: Text(
                                                "${reviewData[index].description} ", //
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        0, 0, 0, 0.8),
                                                    fontSize: 58.sp,
                                                    fontFamily:
                                                        "NotoSansCJKkr_Medium"),
                                              ),
                                            ),
                                            //Images
                                            Stack(
                                              children: [
                                                imageList[index] == null
                                                    ? Container()
                                                    : Container(
                                                        height: 236 * height.h,
                                                        child: ListView(
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 16 *
                                                                      height.h),
                                                          children: <Widget>[
                                                            for (int i = 0;
                                                                i <
                                                                    imageList[
                                                                            index]
                                                                        .length;
                                                                i++)
                                                              InkWell(
                                                                child:
                                                                    Container(
                                                                  margin: EdgeInsets.only(
                                                                      right: 10 *
                                                                          width
                                                                              .w),
                                                                  width: 308 *
                                                                      width.w,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(10)),
                                                                    image: DecorationImage(
                                                                        image: NetworkImage(imageList[index]
                                                                            [
                                                                            i]),
                                                                        fit: BoxFit
                                                                            .fitWidth),
                                                                  ),
                                                                ),
                                                                onTap: () {
                                                                  Get.to(ImageBig(
                                                                      image: imageList[
                                                                              index]
                                                                          [i]));
                                                                },
                                                              ),
                                                          ],
                                                        ),
                                                      ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      Divider(
                                        color:
                                            Color.fromRGBO(212, 212, 212, 1.0),
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        }())
                      ],
                    ),
                  ],
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {},
              backgroundColor: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // SvgPicture.asset(
                  //   "assets/sublistPage/up-arrow.svg",
                  //   width: 21.w,
                  // ),
                  Text(
                    "TOP",
                    style: TextStyle(
                      color: Color(0xff4d4d4d),
                      fontSize: 24 * width.sp,
                      fontFamily: "NotoSansCJKkr_Medium",
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }
}
