import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

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
import 'package:uahage/src/Service/users.dart';
import 'package:uahage/src/Static/Font/font.dart';
import 'package:uahage/src/Static/Image/listsubImage.dart';
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
import 'package:uahage/src/View/Nav/HomeSub/reviseSuggest.dart';
import 'package:url_launcher/url_launcher.dart';
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

  mainImage(image, screenWidth) {
    return CachedNetworkImage(
      imageUrl: image,
      fit: BoxFit.fitWidth,
    );
  }

  var option = "DATE";
  List imageList = [];

  double aver = 0;
  List score = [];
  double averStar = 0;
  int maxScoreNumber;
  int maxScore = 0;
  bool isMyId = false;
  var datas;
  int count = 0;
  var _isnickname;
  //리뷰 전체보기
  select(option) async {
    reviewData = [];
    imageList = [];
    var responseJson = await reviewSelect(data.id, option);

    var currentData;

    var i = 0;
    for (var data in responseJson["data"]) {
      currentData = Review.fromJson(data);

      if (data["user_id"].toString() == UserController.to.userId.toString()) {
        setState(() {
          isMyId = true;
          datas = Review.fromJson(data);
        });
      }
      reviewData.add(currentData);
      reviewData[i].image_path != null
          ? imageList.add(reviewData[i].image_path.split(','))
          : imageList.add(null);

      i++;
    }
    setState(() {
      responseJson["average"].toString() == "null"
          ? aver = 0
          : aver = double.parse(responseJson["average"].toString());

      score = [];
      score.add(responseJson['totalDetailObj']["onePointTotal"]);
      score.add(responseJson['totalDetailObj']["twoPointTotal"]);
      score.add(responseJson['totalDetailObj']["threePointTotal"]);
      score.add(responseJson['totalDetailObj']["fourPointTotal"]);
      score.add(responseJson['totalDetailObj']["fivePointTotal"]);
      for (int i = 0; i < score.length; i++) {
        if (maxScore < score[i]) {
          maxScore = score[i];
        }
      }
      averStar = ((aver * 2).ceil()) / 2;
    });
  }

//리뷰삭제하기
  delete(reviewId) async {
    await reviewDelete(reviewId);
  }

  checkNick() async {
    _isnickname = await isNicknameCheck();
  }

  @override
  void initState() {
    super.initState();

    select("DATE");
  }

  final ScrollController _scrollController = ScrollController();
  PageController _pagecontroller = PageController(initialPage: 500);

  @override
  Widget build(BuildContext context) {
    checkNick();

    count = 0;
    prevImage = [];
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
    connection();

    ScreenUtil.init(context, width: 1125, height: 2436);
    return WillPopScope(
      onWillPop: () {
        if (placeCode == 1)
          Get.back(result: [data.bookmark, aver]);
        else
          Get.back(result: "");
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: (() {
          if (placeCode == 1)
            return appBar(
              context,
              data.name,
              [data.bookmark, aver],
            );
          else
            return appBar(context, data.name, "");
        }()),
        body: Stack(
          children: [
            ListView(
              controller: _scrollController,
              children: [
                Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Container(
                              width: 1500.w*0.75,
                              child: (() {
                                if (placeCode == 1) {
                                  if (index % 3 == 1) {
                                    return mainImage(
                                        restaurantListImage[0], 1500.w*0.75);
                                  } else if (index % 3 == 2) {
                                    return mainImage(
                                        restaurantListImage[1], 1500.w*0.75);
                                  } else
                                    return mainImage(
                                        restaurantListImage[2], 1500.w*0.75);
                                } else if (placeCode == 2) {
                                  if (index % 2 == 1)
                                    return mainImage(
                                        hospitalListImage[0], 1500.w*0.75);
                                  else
                                    return mainImage(
                                        hospitalListImage[1], 1500.w*0.75);
                                } else if (placeCode == 5) {
                                  if (index % 2 == 1)
                                    return mainImage(
                                        kidsCafeListImage[0], 1500.w*0.75);
                                  else
                                    return mainImage(
                                        kidsCafeListImage[1], 1500.w*0.75);
                                } else if (placeCode == 8) {
                                  if (data.image_path == null) {
                                    return mainImage(
                                        experienceListImage[0], 1500.w*0.75);
                                  } else {
                                    return Container(
                                      color: Colors.black,
                                      child: SizedBox(
                                        height: 870.w*0.75,
                                        child: PageView.builder(
                                          itemCount: data.image_path.length,
                                          itemBuilder: (context, index) {
                                            return Image.network(
                                                data.image_path[index],
                                                fit: BoxFit.cover);
                                          },
                                        ),
                                      ),
                                    );
                                  }
                                } else {
                                  if (index % 4 == 1)
                                    return mainImage(
                                        experienceListImage[0], 1500.w*0.75);
                                  else if (index % 4 == 2)
                                    return mainImage(
                                        experienceListImage[1], 1500.w*0.75);
                                  else if (index % 4 == 3)
                                    return mainImage(
                                        experienceListImage[2], 1500.w*0.75);
                                  else
                                    return mainImage(
                                        experienceListImage[3], 1500.w*0.75);
                                }
                              }()),
                            ),
                          ],
                        ),
                        Container(
                          child: Container(
                            padding: EdgeInsets.only(
                                left: 75.w*0.75, top: 45.h*0.779, bottom: 45.h*0.779),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 1250.w*0.75,
                                      child: boldfont(
                                          data.name, 60, Colors.black),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: 20.w*0.75,
                                      ),
                                    ),
                                    (() {
                                      if (placeCode == 1) {
                                        return IconButton(
                                          padding: EdgeInsets.all(0),
                                          constraints: BoxConstraints(
                                              maxWidth: 170.w*0.75,
                                              maxHeight: 170.h*0.779),
                                          icon: Image.asset(
                                              data.bookmark == 0
                                                  ? "./assets/listPage/love_grey.png"
                                                  : "./assets/listPage/love_color.png",
                                              height: 60.h*0.779),
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
                                  top: 3.3 * height.h*0.779,
                                )),
                                placeCode == 1
                                    ? Row(
                                        children: [
                                          for (int i = 0;
                                              i < averStar.toInt();
                                              i++)
                                            Container(
                                              margin: EdgeInsets.only(
                                                  right: 12 * width.w*0.75),
                                              child: Image.asset(
                                                "./assets/listPage/star_color.png",
                                                width: 38 * width.w*0.75,
                                              ),
                                            ),
                                          (averStar - averStar.toInt() == 0.5)
                                              ? Container(
                                                  margin: EdgeInsets.only(
                                                      right: 12 * width.w*0.75),
                                                  child: Image.asset(
                                                    "./assets/listPage/star_half.png",
                                                    width: 38 * width.w*0.75,
                                                  ),
                                                )
                                              : Container(),
                                          for (int i = 0;
                                              i < 5 - averStar.ceil().toInt();
                                              i++)
                                            Container(
                                              child: Image.asset(
                                                "./assets/listPage/star_grey.png",
                                                width: 38 * width.w*0.75,
                                              ),
                                              margin: EdgeInsets.only(
                                                  right: 12 * width.w*0.75),
                                            ),
                                          // Padding(
                                          //     padding: EdgeInsets.only(
                                          //         left: 12 * width.w*0.75)),
                                          Text('${aver}',
                                              style: TextStyle(
                                                color: Color(0xff4d4d4d),
                                                fontSize: 55.sp,
                                                fontFamily:
                                                    "NotoSansCJKkr_Medium",
                                              )),
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  left: 12 * width.w*0.75)),
                                          Text(
                                              '${reviewData.length}명이 평가에 참여했습니다',
                                              style: TextStyle(
                                                color: Color(0xffc6c6c6),
                                                fontSize: 46.sp,
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
                          height: 2.h*0.779,
                          color: Color(0xfff7f7f7),
                        ),
                        Container(
                          child: Container(
                            padding: EdgeInsets.only(
                              left: 75.w*0.75,
                            ),
                            width: MediaQuery.of(context).size.width,
                            // alignment: Alignment.center,
                            //  height: 520 .h*0.779,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                    padding: EdgeInsets.only(
                                  top: 50.w*0.75,
                                )),
                                normalfont("주소", 46, Color(0xff4d4d4d)),
                                Padding(padding: EdgeInsets.only(top: 10.w*0.75)),
                                Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 965.w*0.75,
                                      child: normalfont("${data.address}", 46,
                                          Color(0xff808080)),
                                    ),
                                    Padding(
                                        padding:
                                            EdgeInsets.only(left: 100.w*0.75)),
                                    GestureDetector(
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            "./assets/sublistPage/copy.png",
                                            width: 250.w*0.75,
                                            height: 56.h*0.779,
                                          ),
                                        ],
                                      ),
                                      onTap: () {
                                        FlutterClipboard.copy(data.address);
                                        toast(
                                            context, "주소가 복사되었습니다", "bottom");
                                      },
                                    )
                                  ],
                                ),
                                Padding(padding: EdgeInsets.only(top: 30.w*0.75)),
                                normalfont("연락처", 46, Color(0xff4d4d4d)),
                                Padding(
                                    padding: EdgeInsets.only(
                                  top: 10.w*0.75,
                                )),
                                Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 955.w*0.75,
                                      child: normalfont("${data.phone}", 46,
                                          Color(0xff808080)),
                                    ),
                                    Padding(
                                        padding:
                                            EdgeInsets.only(left: 100.w*0.75)),
                                    GestureDetector(
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            "./assets/sublistPage/call.png",
                                            width: 250.w*0.75,
                                            height: 76.h*0.779,
                                          ),
                                        ],
                                      ),
                                      onTap: () async {
                                        // FlutterClipboard.copy(data.phone);

                                        if (await canLaunch(
                                            'tel:${data.phone}')) {
                                          await launch('tel:${data.phone}');
                                        } else {
                                          throw 'error call';
                                        }
                                        //       toast(
                                        //          context, "번호가 복사되었습니다", "bottom");
                                      },
                                    )
                                  ],
                                ),
                                placeCode == 8
                                    ? Container(
                                        child: Container(
                                          width: MediaQuery.of(context)
                                              .size
                                              .width,
                                          padding: EdgeInsets.only(
                                            top: 30.h*0.779,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              normalfont("영업시간", 46,
                                                  Color(0xff4d4d4d)),
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 10.h*0.779)),
                                              normalfont(
                                                  data.worked_at ==
                                                          "undefined"
                                                      ? '문의'
                                                      : '${data.worked_at}',
                                                  46,
                                                  Color(0xff808080)),
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 50.h*0.779)),
                                            ],
                                          ),
                                        ),
                                      )
                                    : Container(),
                                // placeCode == 1
                                //     ? Padding(
                                //         padding: EdgeInsets.only(top: 30.w*0.75))
                                //     : Padding(
                                //         padding: EdgeInsets.only(top: 0.w*0.75)),
                                // placeCode == 1
                                //     ? normalfont("영업시간", 46, Color(0xff4d4d4d))
                                //     : Container(),
                                // placeCode == 1
                                //     ? Padding(
                                //         padding: EdgeInsets.only(top: 10.w*0.75))
                                //     : Padding(
                                //         padding: EdgeInsets.only(top: 0.w*0.75)),
                                // placeCode == 1
                                //     ? Container(
                                //         width: 500 * width.w*0.75,
                                //         child: normalfont(
                                //             "오전 11:30 ~ 21:00(샐러드바 마감 20:30) 브레이크타임 15:00~17:00",
                                //             46,
                                //             Color(0xff808080)),
                                //       )
                                //     : Container(),
                                Padding(padding: EdgeInsets.only(top: 30.w*0.75))
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 26 * height.h*0.779,
                          color: Color(0xfff7f7f7),
                        ),
                        // placeCode == 1
                        //     ? Container(
                        //         child: Container(
                        //           padding: EdgeInsets.only(
                        //             left: 75.w*0.75,
                        //           ),
                        //           width: MediaQuery.of(context).size.width,
                        //           // alignment: Alignment.center,
                        //           //  height: 520 .h*0.779,
                        //           child: Column(
                        //             crossAxisAlignment:
                        //                 CrossAxisAlignment.start,
                        //             children: [
                        //               Padding(
                        //                   padding: EdgeInsets.only(top: 30.h*0.779)),
                        //               normalfont("매장정보", 46, Color(0xff4d4d4d)),
                        //               Padding(
                        //                   padding: EdgeInsets.only(top: 6.h*0.779)),
                        //               Row(
                        //                 children: [
                        //                   Container(
                        //                     width: 530.w*0.75,
                        //                     child: normalfont("OO 평일런치", 46,
                        //                         Color(0xff808080)),
                        //                   ),
                        //                   Container(
                        //                     child: normalfont("15,900원", 46,
                        //                         Color(0xffc6c6c6)),
                        //                   ),
                        //                 ],
                        //               ),
                        //               Padding(
                        //                   padding: EdgeInsets.only(top: 6.h*0.779)),
                        //               Row(
                        //                 children: [
                        //                   Container(
                        //                     width: 530.w*0.75,
                        //                     child: normalfont("OO 평일디너", 46,
                        //                         Color(0xff808080)),
                        //                   ),
                        //                   Container(
                        //                     child: normalfont("22,900원", 46,
                        //                         Color(0xffc6c6c6)),
                        //                   ),
                        //                 ],
                        //               ),
                        //               Padding(
                        //                   padding: EdgeInsets.only(top: 6.h*0.779)),
                        //               Row(
                        //                 children: [
                        //                   Row(
                        //                     children: [
                        //                       Container(
                        //                         width: 530.w*0.75,
                        //                         child: normalfont("OO 주말/공휴일",
                        //                             46, Color(0xff808080)),
                        //                       ),
                        //                       Container(
                        //                         child: normalfont("25,900원", 46,
                        //                             Color(0xffc6c6c6)),
                        //                       ),
                        //                     ],
                        //                   ),
                        //                 ],
                        //               ),
                        //               Padding(
                        //                   padding: EdgeInsets.only(top: 30.h*0.779)),
                        //             ],
                        //           ),
                        //         ),
                        //       )
                        //     : Container(),

                        (() {
                          if (placeCode == 1) {
                            return Container(
                              child: Container(
                                height: 928.h*0.779,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                        left: 75.w*0.75,
                                        top: 50.h*0.779,
                                      ),
                                      child: normalfont(
                                          "편의시설", 46, Color(0xff4d4d4d)),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(top: 50.h*0.779)),
                                    Row(
                                        // crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  left: 67.w*0.75)),
                                          data.baby_menu == true
                                              ? Image.asset(
                                                  imagecolor[0],
                                                  width: 218.w*0.75,
                                                  height: 292.h*0.779,
                                                )
                                              : Image.asset(
                                                  imagegrey[0],
                                                  width: 218.w*0.75,
                                                  height: 292.h*0.779,
                                                ),
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  left: 59.w*0.75)),
                                          data.baby_bed == true
                                              ? Image.asset(
                                                  imagecolor[1],
                                                  width: 218.w*0.75,
                                                  height: 292.h*0.779,
                                                )
                                              : Image.asset(
                                                  imagegrey[1],
                                                  width: 218.w*0.75,
                                                  height: 292.h*0.779,
                                                ),
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  left: 59.w*0.75)),
                                          data.baby_tableware == true
                                              ? Image.asset(
                                                  imagecolor[2],
                                                  width: 218.w*0.75,
                                                  height: 292.h*0.779,
                                                )
                                              : Image.asset(
                                                  imagegrey[2],
                                                  width: 218.w*0.75,
                                                  height: 292.h*0.779,
                                                ),
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  left: 59.w*0.75)),
                                          data.meeting_room == true
                                              ? Image.asset(
                                                  imagecolor[3],
                                                  width: 218.w*0.75,
                                                  height: 292.h*0.779,
                                                )
                                              : Image.asset(
                                                  imagegrey[3],
                                                  width: 218.w*0.75,
                                                  height: 292.h*0.779,
                                                ),
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  left: 59.w*0.75)),
                                          data.diaper_change == true
                                              ? Image.asset(
                                                  imagecolor[4],
                                                  width: 231.w*0.75,
                                                  height: 284.h*0.779,
                                                )
                                              : Image.asset(
                                                  imagegrey[4],
                                                  width: 231.w*0.75,
                                                  height: 284.h*0.779,
                                                ),
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  left: 59.w*0.75)),
                                        ]),
                                    Padding(
                                        padding: EdgeInsets.only(top: 50.h*0.779)),
                                    Row(
                                      children: [
                                        Padding(
                                            padding:
                                                EdgeInsets.only(left: 67.w*0.75)),
                                        data.play_room == true
                                            ? Image.asset(
                                                imagecolor[5],
                                                width: 218.w*0.75,
                                                height: 292.h*0.779,
                                              )
                                            : Image.asset(
                                                imagegrey[5],
                                                width: 218.w*0.75,
                                                height: 292.h*0.779,
                                              ),
                                        Padding(
                                            padding:
                                                EdgeInsets.only(left: 59.w*0.75)),
                                        data.stroller == true
                                            ? Image.asset(
                                                imagecolor[6],
                                                width: 218.w*0.75,
                                                height: 292.h*0.779,
                                              )
                                            : Image.asset(
                                                imagegrey[6],
                                                width: 218.w*0.75,
                                                height: 292.h*0.779,
                                              ),
                                        Padding(
                                            padding:
                                                EdgeInsets.only(left: 59.w*0.75)),
                                        data.nursing_room == true
                                            ? Image.asset(
                                                imagecolor[7],
                                                width: 218.w*0.75,
                                                height: 292.h*0.779,
                                              )
                                            : Image.asset(
                                                imagegrey[7],
                                                width: 218.w*0.75,
                                                height: 292.h*0.779,
                                              ),
                                        Padding(
                                            padding:
                                                EdgeInsets.only(left: 59.w*0.75)),
                                        data.baby_chair == true
                                            ? Image.asset(
                                                imagecolor[8],
                                                width: 218.w*0.75,
                                                height: 292.h*0.779,
                                              )
                                            : Image.asset(
                                                imagegrey[8],
                                                width: 218.w*0.75,
                                                height: 292.h*0.779,
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
                                  left: 75.w*0.75,
                                  top: 50.h*0.779,
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    normalfont("검진항목", 46, Color(0xff4d4d4d)),
                                    Padding(
                                        padding: EdgeInsets.only(top: 10.h*0.779)),
                                    normalfont("${data.examination_items}",
                                        46, Color(0xff808080)),
                                    Padding(
                                        padding: EdgeInsets.only(top: 50.h*0.779)),
                                  ],
                                ),
                              ),
                            );
                          } else if (placeCode == 3) {
                            return Container(
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.only(
                                  left: 75.w*0.75,
                                  top: 50.h*0.779,
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    normalfont("정보", 46, Color(0xff4d4d4d)),
                                    Padding(
                                        padding: EdgeInsets.only(top: 10.h*0.779)),
                                    normalfont(
                                        data.use_bus == true
                                            ? "버스 : 운행"
                                            : "버스 : 미운행",
                                        46,
                                        Color(0xff808080)),
                                    Padding(
                                        padding: EdgeInsets.only(top: 50.h*0.779)),
                                  ],
                                ),
                              ),
                            );
                          } else if (placeCode == 8) {
                            return Container(
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.only(
                                  left: 75.w*0.75,
                                  top: 50.h*0.779,
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    normalfont("매장정보", 46, Color(0xff4d4d4d)),
                                    Padding(
                                        padding: EdgeInsets.only(top: 10.h*0.779)),
                                    normalfont(
                                        data.store_info == "undefined"
                                            ? '준비 중입니다.'
                                            : "${data.store_info}",
                                        46,
                                        Color(0xff808080)),
                                    Padding(
                                        padding: EdgeInsets.only(top: 30.h*0.779)),
                                    normalfont("홈페이지", 46, Color(0xff4d4d4d)),
                                    Padding(
                                        padding: EdgeInsets.only(top: 10.h*0.779)),
                                    InkWell(
                                      child: normalfont(
                                          data.url == "undefined"
                                              ? '준비 중입니다.'
                                              : "${data.url}",
                                          46,
                                          Color(0xff808080)),
                                      onTap: () async {
                                        if (await canLaunch(data.url)) {
                                          await launch(data.url);
                                        } else {
                                          throw 'Could not launch $url';
                                        }
                                      },
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(top: 50.h*0.779)),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return Container(
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.only(
                                  left: 75.w*0.75,
                                  top: 50.h*0.779,
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    normalfont(
                                        "관람 / 체험료", 46, Color(0xff4d4d4d)),
                                    Padding(
                                        padding: EdgeInsets.only(top: 10.h*0.779)),
                                    normalfont("${data.admission_fee}", 46,
                                        Color(0xff808080)),
                                    Padding(
                                        padding: EdgeInsets.only(top: 50.h*0.779)),
                                  ],
                                ),
                              ),
                            );
                          }
                        }()),
                        Container(
                          height: 26 * height.h*0.779,
                          color: Color(0xfff7f7f7),
                        ),
                        ConnectionController.to.connectionstauts !=
                                "ConnectivityResult.none"
                            ? Container(
                                child: Container(
                                //  height: 1300 .h*0.779,
                                width: 1500.w*0.75,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(
                                          left: 75.w*0.75,
                                          top: 50.h*0.779,
                                        ),
                                        child: normalfont(
                                            "위치", 46, Color(0xff4d4d4d)),
                                      ),
                                      Padding(
                                          padding:
                                              EdgeInsets.only(top: 30.h*0.779)),
                                      GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                          height: 1100.h*0.779,
                                          child: WebView(
                                            gestureRecognizers: Set()
                                              ..add(
                                                Factory<
                                                    VerticalDragGestureRecognizer>(
                                                  () =>
                                                      VerticalDragGestureRecognizer(),
                                                ),
                                              ),
                                            onWebViewCreated:
                                                (WebViewController
                                                    webViewController) {
                                              _controller = webViewController;
                                              _controller.loadUrl(url +
                                                  '/maps/show-place-name?placeName=${data.name}&placeAddress=${data.address}');
                                            },
                                            javascriptMode:
                                                JavascriptMode.unrestricted,
                                          ),
                                        ),
                                      ),
                                    ]),
                              ))
                            : progress(),
                        InkWell(
                          onTap: () {
                            Get.to(ReviseSuggest(
                                placeId: data.id,
                                placeCategoryId: placeCode));
                          },
                          child: Container(
                            child: Container(
                              height: 170.h*0.779,
                              child: Center(
                                child: Image.asset(
                                  "./assets/sublistPage/modify.png",
                                  height: 80.h*0.779,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 26 * height.h*0.779,
                          color: Color(0xfff7f7f7),
                        ),
                        placeCode == 2
                            ? Container(
                                margin: EdgeInsets.only(
                                    top: 36 * height.h*0.779,
                                    left: 35 * width.w*0.75,
                                    right: 35 * width.w*0.75,
                                    bottom: 253 * height.h*0.779),
                                padding: EdgeInsets.all(18 * width.w*0.75),
                                decoration: BoxDecoration(
                                    color: Color.fromRGBO(255, 114, 142, 0.1),
                                    border: Border.all(
                                      color:
                                          Color.fromRGBO(255, 114, 142, 0.7),
                                    ),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10))),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        boldfont(
                                            "특정의료기관에 대한 리뷰",
                                            46,
                                            Color.fromRGBO(
                                                255, 114, 142, 0.7)),
                                        normalfont(
                                            "는 의료법에 따라 치료 효과로",
                                            46,
                                            Color.fromRGBO(
                                                255, 114, 142, 0.7))
                                      ],
                                    ),
                                    normalfont(
                                        "오인하게 할 우려가 있고, 환자 유인행위의 소지가 있어 리뷰를 작성할 수 없습니다.",
                                        46,
                                        Color.fromRGBO(255, 114, 142, 0.7))
                                  ],
                                ))
                            : Container(),

                        placeCode == 1
                            ? Container(
                                margin: EdgeInsets.only(
                                  left: 87 * width.w*0.75,
                                  top: 36 * height.h*0.779,
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                            width: 210 * height.h*0.779,
                                            child: RichText(
                                              textAlign: TextAlign.center,
                                              text: TextSpan(
                                                style: TextStyle(
                                                    color: Color(0xff939393),
                                                    fontWeight:
                                                        FontWeight.w500,
                                                    fontFamily:
                                                        "NotoSansCJKkr_Medium",
                                                    fontStyle:
                                                        FontStyle.normal,
                                                    fontSize: 46.sp),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                      text: '${data.name}',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily:
                                                              "NotoSansCJKkr_Bold",
                                                          fontStyle: FontStyle
                                                              .normal,
                                                          fontSize: 46.sp)),
                                                  TextSpan(text: '에'),
                                                  data.name.length < 5
                                                      ? TextSpan(text: '\n')
                                                      : TextSpan(text: ''),
                                                  TextSpan(text: ' 다녀오셨나요?'),
                                                ],
                                              ),
                                            )
                                            // child: Column(
                                            //   children: [
                                            //     Row(
                                            //       children: [
                                            //         normalfont("${data.name}",
                                            //             46, Colors.black),
                                            //         normalfont("에", 46,
                                            //             Color(0xff939393)),
                                            //         normalfont("다녀오셨나요?", 46,
                                            //             Color(0xff939393)),
                                            //       ],
                                            //     ),
                                            //   ],
                                            // )
                                            ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                            left: 44 * width.w*0.75,
                                          ),
                                        ),
                                        isMyId
                                            ? InkWell(
                                                child: Image.asset(
                                                  "./assets/sublistPage/reviewrevisebutton.png",
                                                  height: 54 * height.h*0.779,
                                                ),
                                                onTap: () async {
                                                  if (_isnickname == true) {
                                                    var result = await Get.to(
                                                        ReviewPage(
                                                            reviewData: datas,
                                                            data: data));

                                                    if (result == "ok") {
                                                      await select(option);
                                                      setState(() {});
                                                    }
                                                  } else {
                                                    dialog(context,
                                                        "회원정보 수정해주세요");
                                                  }
                                                },
                                              )
                                            : InkWell(
                                                child: Image.asset(
                                                  "./assets/sublistPage/reviewbutton.png",
                                                  height: 54 * height.h*0.779,
                                                ),
                                                onTap: () async {
                                                  if (_isnickname == true) {
                                                    var result = await Get.to(
                                                        ReviewPage(
                                                            reviewData: null,
                                                            data: data));

                                                    if (result == "ok") {
                                                      await select(option);
                                                      setState(() {});
                                                    }
                                                  } else {
                                                    dialog(context,
                                                        "회원정보 수정해주세요");
                                                  }
                                                },
                                              ),
                                      ],
                                    ),
                                  ],
                                ))
                            : Container(),

                        placeCode == 1
                            ? Container(
                                margin: EdgeInsets.only(
                                    left: 36 * width.w*0.75, top: 36 * width.h*0.779),
                                child: Stack(
                                  children: [
                                    Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.4),
                                                offset:
                                                    Offset(2.0, 4.0), //(x,y)
                                                blurRadius: 7.0,
                                                spreadRadius: 1,
                                              ),
                                            ],
                                            border: Border.all(
                                              color: Colors.white,
                                            ),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                        height: 193 * height.h*0.779,
                                        width: 648 * width.w*0.75),
                                    score.length > 0
                                        ? Container(
                                            margin:
                                                EdgeInsets.only(top: 35.h*0.779),
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 22 * height.h*0.779),
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .center,
                                                  children: [
                                                    normalfont(
                                                        "고객만족도",
                                                        46,
                                                        Color(0xff939393)),
                                                    boldfont(
                                                        '${aver}',
                                                        70,
                                                        Color(0xff3a3939)),
                                                    Row(
                                                      children: [
                                                        for (int i = 0;
                                                            i <
                                                                averStar
                                                                    .toInt();
                                                            i++)
                                                          Container(
                                                            margin: EdgeInsets
                                                                .only(
                                                                    right: 12 *
                                                                        width
                                                                            .w*0.75),
                                                            child:
                                                                Image.asset(
                                                              "./assets/listPage/star_color.png",
                                                              width: 38 *
                                                                  width.w*0.75,
                                                            ),
                                                          ),
                                                        (averStar -
                                                                    averStar
                                                                        .toInt() ==
                                                                0.5)
                                                            ? Container(
                                                                margin: EdgeInsets.only(
                                                                    right: 12 *
                                                                        width
                                                                            .w*0.75),
                                                                child: Image
                                                                    .asset(
                                                                  "./assets/listPage/star_half.png",
                                                                  width: 38 *
                                                                      width.w*0.75,
                                                                ),
                                                              )
                                                            : Container(),
                                                        for (int i = 0;
                                                            i <
                                                                5 -
                                                                    averStar
                                                                        .ceil()
                                                                        .toInt();
                                                            i++)
                                                          Container(
                                                            child:
                                                                Image.asset(
                                                              "./assets/listPage/star_grey.png",
                                                              width: 38 *
                                                                  width.w*0.75,
                                                            ),
                                                            margin: EdgeInsets
                                                                .only(
                                                                    right: 12 *
                                                                        width
                                                                            .w*0.75),
                                                          ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 30 * width.w*0.75)),
                                                Column(
                                                  children: [
                                                    Image.asset(
                                                      "./assets/sublistPage/line.png",
                                                      height: 146 * height.h*0.779,
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 35 * width.w*0.75)),
                                                Column(
                                                  children: [
                                                    normalfont(
                                                        '${score[4]}',
                                                        40,
                                                        Color(0xffa9a9a9)),
                                                    scoreImage(4),
                                                    normalfont("5점", 40,
                                                        Color(0xffa9a9a9)),
                                                  ],
                                                ),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 21 * width.w*0.75)),
                                                Column(
                                                  children: [
                                                    normalfont(
                                                        '${score[3]}',
                                                        40,
                                                        Color(0xffa9a9a9)),
                                                    scoreImage(3),
                                                    normalfont("4점", 40,
                                                        Color(0xffa9a9a9)),
                                                  ],
                                                ),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 21 * width.w*0.75)),
                                                Column(
                                                  children: [
                                                    normalfont(
                                                        '${score[2]}',
                                                        40,
                                                        Color(0xffa9a9a9)),
                                                    scoreImage(2),
                                                    normalfont("3점", 40,
                                                        Color(0xffa9a9a9)),
                                                  ],
                                                ),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 21 * width.w*0.75)),
                                                Column(
                                                  children: [
                                                    normalfont(
                                                        '${score[1]}',
                                                        40,
                                                        Color(0xffa9a9a9)),
                                                    scoreImage(1),
                                                    normalfont("2점", 40,
                                                        Color(0xffa9a9a9)),
                                                  ],
                                                ),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 21 * width.w*0.75)),
                                                Column(
                                                  children: [
                                                    normalfont(
                                                        '${score[0]}',
                                                        40,
                                                        Color(0xffa9a9a9)),
                                                    scoreImage(0),
                                                    normalfont("1점", 40,
                                                        Color(0xffa9a9a9)),
                                                  ],
                                                ),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 21 * width.w*0.75)),
                                              ],
                                            ),
                                          )
                                        : Container()
                                  ],
                                ),
                              )
                            : Container(),

                        placeCode == 1
                            ? Padding(
                                padding: EdgeInsets.only(top: 36 * width.w*0.75))
                            : Padding(
                                padding: EdgeInsets.only(top: 0 * width.w*0.75)),

                        // 4 images

                        placeCode == 1
                            ? Row(
                                children: [
                                  Padding(
                                      padding: EdgeInsets.only(left: 36.w*0.75)),
                                  for (int i = 0; i < prevImage.length; i++)
                                    i < 3
                                        ? Container(
                                            margin: EdgeInsets.only(
                                                left: 18 * width.w*0.75),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              child: SizedBox(
                                                width: 148 * width.w*0.75,
                                                height: 148 * height.w*0.75,
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
                                              margin: EdgeInsets.only(
                                                  left: 18 * width.w*0.75),
                                              child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  child: Stack(
                                                    children: [
                                                      SizedBox(
                                                        width: 148 * width.w*0.75,
                                                        height:
                                                            148 * height.w*0.75,
                                                        child: Image.network(
                                                          prevImage[i],
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                      Container(
                                                        width: 148 * width.w*0.75,
                                                        height:
                                                            148 * height.w*0.75,
                                                        color: Colors.black
                                                            .withOpacity(0.5),
                                                      ),
                                                      Container(
                                                        width: 148 * width.w*0.75,
                                                        height: 148 * width.w*0.75,
                                                        child: Center(
                                                          child: Image.asset(
                                                            "./assets/reviewPage/plus.png",
                                                            color:
                                                                Colors.white,
                                                            width:
                                                                38 * width.w*0.75,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  )),
                                            ),
                                          ),
                                ],
                              )
                            : Container(),
                        placeCode == 1
                            ? Padding(
                                padding: EdgeInsets.only(top: 36 * width.w*0.75))
                            : Padding(
                                padding: EdgeInsets.only(top: 0 * width.w*0.75)),
                        placeCode == 1
                            ? Container(
                                height: 26 * height.h*0.779,
                                color: Color(0xfff7f7f7),
                              )
                            : Container(),

                        //Sorting condition
                        placeCode == 1
                            ? Container(
                                // height: 20.h*0.779,
                                width: double.infinity,
                                child: Row(
                                  children: [
                                    Padding(
                                        padding: EdgeInsets.only(
                                            top: 80 * height.h*0.779,
                                            left: 35 * width.w*0.75)),
                                    normalfont(
                                        "리뷰 ",46, Color(0xff4d4d4d)),
                                    normalfont(reviewData.length.toString(),
                                       46, Color(0xffe9718d)),
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
                                                46,
                                                option == "DATE"
                                                    ? Color(0xff4d4d4d)
                                                    : Color(0xff939393)),
                                          ),
                                          normalfont(" | ", 26 * width,
                                              Color(0xffdddddd)),
                                          InkWell(
                                            onTap: () {
                                              option = "TOP";
                                              select(option);
                                            },
                                            child: normalfont(
                                                "평점높은순",
                                                46,
                                                option == "TOP"
                                                    ? Color(0xff4d4d4d)
                                                    : Color(0xff939393)),
                                          ),
                                          normalfont(" | ", 26 * width,
                                              Color(0xffdddddd)),
                                          InkWell(
                                            onTap: () {
                                              option = "LOW";
                                              select(option);
                                            },
                                            child: normalfont(
                                                "평점낮은순",
                                                46,
                                                option == "LOW"
                                                    ? Color(0xff4d4d4d)
                                                    : Color(0xff939393)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                        padding:
                                            EdgeInsets.only(right: 38.w*0.75)),
                                  ],
                                ),
                              )
                            : Container(),
                        (() {
                          return Container(
                            child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: reviewData.length,
                              itemBuilder: (context, index) {
                                if (reviewData.length == 0) {
                                  return Container(
                                    child: Text(" 로딩중 "),
                                  );
                                }
                                return Container(
                                  width: double.infinity,
                                  color: Colors.white,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.fromLTRB(
                                            40 * width.w*0.75,
                                            30.h*0.779,
                                            40 * width.w*0.75,
                                            33.h*0.779),
                                        width: double.infinity,
                                        child: Column(
                                          children: [
                                            // first container
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                reviewData[index].profile !=
                                                        null
                                                    ? CircleAvatar(
                                                        radius: 40 * width.w*0.75,
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            shape: BoxShape
                                                                .circle,
                                                            image: DecorationImage(
                                                                image: NetworkImage(
                                                                    reviewData[
                                                                            index]
                                                                        .profile),
                                                                fit: BoxFit
                                                                    .cover),
                                                          ),
                                                        ),
                                                      )
                                                    : CircleAvatar(
                                                        radius: 40 * width.w*0.75,
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            shape: BoxShape
                                                                .circle,
                                                            image: DecorationImage(
                                                                image: AssetImage(
                                                                    "./assets/myPage/avatar.png"),
                                                                fit: BoxFit
                                                                    .cover),
                                                          ),
                                                        ),
                                                      ),

                                                // Container after avatar image
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      left: 15 * width.w*0.75),
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
                                                              46,
                                                              Colors.black),
                                                          Padding(
                                                              padding: EdgeInsets.only(
                                                                  left: 5 *
                                                                      width
                                                                          .w*0.75)),
                                                          normalfont(
                                                              "${reviewData[index].created_at} ",
                                                              46,
                                                              Color(
                                                                  0xff808080)),
                                                        ],
                                                      ),
                                                      // 3 Rating buttons
                                                      Row(
                                                        children: [
                                                          average('맛',
                                                              "${reviewData[index].taste_rating}"),
                                                          Padding(
                                                              padding: EdgeInsets.only(
                                                                  left: 8 *
                                                                      width
                                                                          .w*0.75)),
                                                          average('가격',
                                                              "${reviewData[index].cost_rating}"),
                                                          Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 8
                                                                          .w*0.75)),
                                                          average('서비스',
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
                                                                          datas,
                                                                      data:
                                                                          data));
                                                              if (result ==
                                                                  "ok") {
                                                                await select(
                                                                    option);
                                                                setState(
                                                                    () {});
                                                              }
                                                            },
                                                            child: Text(
                                                              "수정",
                                                              style: TextStyle(
                                                                  fontSize: 46
                                                                          .sp,
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
                                                              padding: EdgeInsets.only(
                                                                  left: 20 *
                                                                      width
                                                                          .w*0.75)),
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
                                                                          BorderRadius.all(Radius.circular(20.0)),
                                                                    ),
                                                                    title: normalfont(
                                                                        "리뷰를 삭제하시겠습니까?",
                                                                        46,
                                                                        Color(
                                                                            0xff4d4d4d)),
                                                                    actions: <
                                                                        Widget>[
                                                                      FlatButton(
                                                                        child: normalfont(
                                                                            "예",
                                                                            46,
                                                                            Color(0xffff7292)),
                                                                        onPressed:
                                                                            () async {
                                                                          Navigator.pop(context,
                                                                              "OK");
                                                                          await delete(reviewData[index].id);
                                                                          datas =
                                                                              null;
                                                                          isMyId =
                                                                              false;
                                                                          await select(option);
                                                                        },
                                                                      ),
                                                                      FlatButton(
                                                                        child: normalfont(
                                                                            "아니오",
                                                                            46,
                                                                            Color(0xffff7292)),
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(context,
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
                                                                  fontSize: 46

                                                                          .sp,
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
                                                              reviewData[
                                                                      index]
                                                                  .id);
                                                        },
                                                        child: Text(
                                                          "신고",
                                                          style: TextStyle(
                                                              fontSize: 46.sp,
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
                                                  top: 16 * width.w*0.75),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 13 * width.w*0.75,
                                                  vertical: 19 * width.w*0.75),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.all(
                                                  Radius.circular(10),
                                                ),
                                                color: Color.fromRGBO(
                                                    248, 248, 248, 1.0),
                                              ),
                                              child: Text(
                                                "${reviewData[index].description} ", //
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        0, 0, 0, 0.77),
                                                    fontSize: 46.sp,
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
                                                        height:
                                                            236 * height.h*0.779,
                                                        child: ListView(
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 16 *
                                                                      height
                                                                          .h*0.779),
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
                                                                          width.w*0.75),
                                                                  width: 308 *
                                                                      width.w*0.75,
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
                                                                  Get.to(
                                                                      ImageBig(),
                                                                      arguments: {
                                                                        "page":
                                                                            "listsub",
                                                                        "image":
                                                                            imageList[index],
                                                                        "index":
                                                                            i,
                                                                      });
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
                                        color: Color.fromRGBO(
                                            212, 212, 212, 1.0),
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        }()),
                        Container(
                          height: 300.h*0.779,
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(left: 1150.w*0.75, top: 2100.h*0.779),
              child: InkWell(
                onTap: () {
                  _scrollController.jumpTo(1);
                },
                child:
                    Image.asset("./assets/sublistPage/top.png", width: 350.w*0.75),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget scoreImage(i) {
    if (maxScore == score[i] && score[i] != 0) {
      return Image.asset(
        "./assets/sublistPage/bar6.png",
        height: 89 * height.h*0.779,
      );
    } else {
      if (score[i] == 0) {
        return Image.asset(
          "./assets/sublistPage/bar1.png",
          height: 89 * height.h*0.779,
        );
      } else if (0 <= score[i] || score[i] <= maxScore * (1 / 4).ceil()) {
        return Image.asset(
          "./assets/sublistPage/bar2.png",
          height: 89 * height.h*0.779,
        );
      } else if (maxScore * (1 / 4).ceil() < score[i] ||
          score[i] <= maxScore * (2 / 4).ceil()) {
        return Image.asset(
          "./assets/sublistPage/bar3.png",
          height: 89 * height.h*0.779,
        );
      } else if (maxScore * (2 / 4).ceil() < score[i] ||
          score[i] <= maxScore * (3 / 4).ceil()) {
        return Image.asset(
          "./assets/sublistPage/bar4.png",
          height: 89 * height.h*0.779,
        );
      } else {
        return Image.asset(
          "./assets/sublistPage/bar5.png",
          height: 89 * height.h*0.779,
        );
      }
    }
  }
}
