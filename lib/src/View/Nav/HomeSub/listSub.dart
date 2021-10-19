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
  String url = pageURL;
  String imgUrl = imgURL;
  int placeCode = Get.arguments['placeCode'];
  var data;
  var datas = Get.arguments['data'];
  int placeId = Get.arguments['placeId'];
  var placeName = Get.arguments['placeName'];
  int index = Get.arguments['index'];
  var width = 1500 / 720;
  var height = 2667 / 1280;
  Bookmark bookmark = new Bookmark();

  getList() async {
    Place place = new Place();
    data = await place.getPlaceDetailList(placeCode, placeId);
    setState(() {});
  }

  //리뷰
  List<Review> allReviewDatas = [];
  var myReviewData;

  double averageTotalRating = 0;
  List<int> totalRating = [0, 0, 0, 0, 0];
  var option = "date";
  int maxScore = 0;
  bool isMyId = false;

  List previewImagePath = [];
  var imageJson;

  mainImage(image, screenWidth) {
    return CachedNetworkImage(
      imageUrl: image,
      fit: BoxFit.fitWidth,
    );
  }

  selectImage() async {
    print("select!!");
    imageJson = await reviewSelectImage(placeId);
    previewImagePath = [];
    for (int i = 0; i < imageJson.length; i++) {
      if (i < 4) {
        setState(() {
          previewImagePath.add(imageJson[i]["previewImagePath"]);
        });
      }
    }
  }

  //리뷰 전체보기
  select(option) async {
    allReviewDatas = [];
    var responseJson = await reviewSelect(placeId, option);
    setState(() {
      averageTotalRating = responseJson["shared"]["allTotalRating"];
      totalRating[0] = responseJson["shared"]["onePointTotal"];
      totalRating[1] = responseJson["shared"]["twoPointTotal"];
      totalRating[2] = responseJson["shared"]["threePointTotal"];
      totalRating[3] = responseJson["shared"]["fourPointTotal"];
      totalRating[4] = responseJson["shared"]["fivePointTotal"];
      for (int i = 0; i < totalRating.length; i++) {
        if (maxScore < totalRating[i]) maxScore = totalRating[i];
      }
      for (var data in responseJson["reviews"]) {
        if (data["user"]["userId"].toString() ==
            UserController.to.userId.toString()) {
          //내리뷰
          isMyId = true;
          myReviewData = Review.fromJson(data);
        }
        allReviewDatas.add(Review.fromJson(data));
      }
    });
  }

//리뷰삭제하기
  delete(reviewId) async {
    await reviewDelete(reviewId);
  }

  @override
  void initState() {
    super.initState();
    getList();
    select("DATE");
    selectImage();
  }

  final ScrollController _scrollController = ScrollController();
  PageController _pagecontroller = PageController(initialPage: 500);

  @override
  @override
  Widget build(BuildContext context) {
    connection();
    ScreenUtil.init(context, width: 1500, height: 2667);
    return WillPopScope(
      onWillPop: () {
        if (placeCode == 1)
          Get.back(result: [
            data == null ? 0 : data.isBookmarked,
            averageTotalRating
          ]);
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
                datas.name,
                [data == null ? 0 : data.isBookmarked, averageTotalRating],
              );
            else
              return appBar(context, datas.name, "");
          }()),
          body: Stack(
            children: [
              ListView.builder(
                  controller: _scrollController,
                  itemCount: 1,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    if (data == null) {
                      return progress();
                    } else {
                      return Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Container(
                                    width: 1500.w,
                                    child: (() {
                                      if (placeCode == 1) {
                                        if (data.images.length == 0) {
                                          if (index % 3 == 1) {
                                            return mainImage(
                                                restaurantListImage[0], 1500.w);
                                          } else if (index % 3 == 2) {
                                            return mainImage(
                                                restaurantListImage[1], 1500.w);
                                          } else
                                            return mainImage(
                                                restaurantListImage[2], 1500.w);
                                        } else {
                                          return Container(
                                            color: Colors.black,
                                            child: SizedBox(
                                              height: 870.w,
                                              child: Image.network(
                                                  imgUrl +
                                                      data.images[0]
                                                          ["imagePath"],
                                                  fit: BoxFit.cover),
                                            ),
                                          );
                                        }
                                      } else if (placeCode == 2) {
                                        if (index % 2 == 1)
                                          return mainImage(
                                              hospitalListImage[0], 1500.w);
                                        else
                                          return mainImage(
                                              hospitalListImage[1], 1500.w);
                                      } else if (placeCode == 5) {
                                        if (index % 2 == 1)
                                          return mainImage(
                                              kidsCafeListImage[0], 1500.w);
                                        else
                                          return mainImage(
                                              kidsCafeListImage[1], 1500.w);
                                      } else if (placeCode == 8) {
                                        if (data.images.length == 0) {
                                          return mainImage(
                                              experienceListImage[0], 1500.w);
                                        } else {
                                          return Container(
                                            color: Colors.black,
                                            child: SizedBox(
                                              height: 870.w,
                                              child: PageView.builder(
                                                itemCount: data.images.length,
                                                itemBuilder: (context, index) {
                                                  return Image.network(
                                                      data.images[index]
                                                          ["imagePath"],
                                                      fit: BoxFit.cover);
                                                },
                                              ),
                                            ),
                                          );
                                        }
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
                                ],
                              ),
                              Container(
                                child: Container(
                                  padding: EdgeInsets.only(
                                      left: 75.w, top: 45.h, bottom: 45.h),
                                  child: Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 1250.w,
                                            child: boldfont(
                                                data.name, 77, Colors.black),
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
                                                    !data.isBookmarked
                                                        ? "./assets/listPage/love_grey.png"
                                                        : "./assets/listPage/love_color.png",
                                                    height: 60.h),
                                                onPressed: () async {
                                                  if (data.isBookmarked) {
                                                    await bookmark
                                                        .bookmarkToogle(
                                                            UserController.to
                                                                .userId.value,
                                                            data.id);
                                                    setState(() {
                                                      data.isBookmarked = false;
                                                    });
                                                  } else {
                                                    await bookmark
                                                        .bookmarkToogle(
                                                            UserController.to
                                                                .userId.value,
                                                            data.id);
                                                    setState(() {
                                                      data.isBookmarked = true;
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
                                                    i <
                                                        averageTotalRating
                                                            .toInt();
                                                    i++)
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        right: 12 * width.w),
                                                    child: Image.asset(
                                                      "./assets/listPage/star_color.png",
                                                      width: 38 * width.w,
                                                    ),
                                                  ),
                                                (averageTotalRating -
                                                            averageTotalRating
                                                                .toInt() >
                                                        0)
                                                    ? Container(
                                                        margin: EdgeInsets.only(
                                                            right:
                                                                12 * width.w),
                                                        child: Image.asset(
                                                          "./assets/listPage/star_half.png",
                                                          width: 38 * width.w,
                                                        ),
                                                      )
                                                    : Container(),
                                                for (int i = 0;
                                                    i <
                                                        5 -
                                                            averageTotalRating
                                                                .ceil()
                                                                .toInt();
                                                    i++)
                                                  Container(
                                                    child: Image.asset(
                                                      "./assets/listPage/star_grey.png",
                                                      width: 38 * width.w,
                                                    ),
                                                    margin: EdgeInsets.only(
                                                        right: 12 * width.w),
                                                  ),
                                                // Padding(
                                                //     padding: EdgeInsets.only(
                                                //         left: 12 * width.w)),
                                                Text('${averageTotalRating}',
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
                                                    '${allReviewDatas.length.toString()}명이 평가에 참여했습니다',
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
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                          padding: EdgeInsets.only(
                                        top: 50.w,
                                      )),
                                      normalfont("주소", 58, Color(0xff4d4d4d)),
                                      Padding(
                                          padding: EdgeInsets.only(top: 10.w)),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 965.w,
                                            child: normalfont("${data.address}",
                                                58, Color(0xff808080)),
                                          ),
                                          Padding(
                                              padding:
                                                  EdgeInsets.only(left: 100.w)),
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
                                              FlutterClipboard.copy(
                                                  data.address);
                                              toast(context, "주소가 복사되었습니다",
                                                  "bottom");
                                            },
                                          )
                                        ],
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(top: 30.w)),
                                      normalfont("연락처", 58, Color(0xff4d4d4d)),
                                      Padding(
                                          padding: EdgeInsets.only(
                                        top: 10.w,
                                      )),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 955.w,
                                            child: normalfont(
                                                "${data.phone == null ? "없음" : data.phone}",
                                                58,
                                                Color(0xff808080)),
                                          ),
                                          Padding(
                                              padding:
                                                  EdgeInsets.only(left: 100.w)),
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
                                            onTap: () async {
                                              // FlutterClipboard.copy(data.phone);

                                              if (await canLaunch(
                                                  'tel:${data.phone}')) {
                                                await launch(
                                                    'tel:${data.phone}');
                                              } else {
                                                throw 'error call';
                                              }
                                              //       toast(
                                              //          context, "번호가 복사되었습니다", "bottom");
                                            },
                                          )
                                        ],
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                          left: 75.w,
                                        ),
                                      ),
                                      (() {
                                        List<Widget> clist = new List<Widget>();

                                        if (data.info != null) {
                                          if (placeCode == 1) {
                                            clist.add(
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 30.h)),
                                            );
                                            clist.add(normalfont(
                                                "매장정보", 58, Color(0xff4d4d4d)));
                                            clist.add(
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 10.h)),
                                            );
                                            if (data.info["closeDay"] != "") {
                                              clist.add(normalfont(
                                                  "휴무일 : ${data.info["closeDay"]}요일",
                                                  58,
                                                  Color(0xff808080)));
                                            }
                                            if (data.info["memo"] != "") {
                                              clist.add(normalfont(
                                                  "메모 : ${data.info["memo"]}",
                                                  58,
                                                  Color(0xff808080)));
                                            }
                                            if (data.info["startTime"] != "") {
                                              clist.add(normalfont(
                                                  "영업시작시간 : ${(data.info["startTime"]).split(":")[0]}시 ${(data.info["startTime"]).split(":")[1]}분",
                                                  58,
                                                  Color(0xff808080)));
                                            }
                                            if (data.info["endTime"] != "") {
                                              clist.add(normalfont(
                                                  "영업종료시간 : ${(data.info["endTime"]).split(":")[0]}시 ${(data.info["endTime"]).split(":")[1]}분",
                                                  58,
                                                  Color(0xff808080)));
                                            }

                                            if (!(data.menu.length == 0)) {
                                              clist.add(
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 30.h)),
                                              );
                                              clist.add(normalfont(
                                                  "메뉴", 58, Color(0xff4d4d4d)));
                                              clist.add(
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 10.h)),
                                              );
                                              for (int i = 0;
                                                  i < data.menu.length;
                                                  i++) {
                                                clist.add(normalfont(
                                                    "${data.menu[i]["name"]} : ${data.menu[i]["price"]}원",
                                                    58,
                                                    Color(0xff808080)));
                                              }
                                              clist.add(Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 50.w)));

                                              return new Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: clist);
                                            }
                                          }
                                          if (placeCode == 2) {
                                            clist.add(
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 30.h)),
                                            );
                                            clist.add(normalfont(
                                                "검진항목", 58, Color(0xff4d4d4d)));

                                            clist.add(
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 10.h)),
                                            );
                                            if (data.info["examinationItems"] !=
                                                "") {
                                              clist.add(normalfont(
                                                  "${data.info["examinationItems"]}",
                                                  58,
                                                  Color(0xff808080)));
                                            }
                                          }
                                          if (placeCode == 3) {
                                            clist.add(
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 30.h)),
                                            );
                                            clist.add(normalfont(
                                                "정보", 58, Color(0xff4d4d4d)));

                                            clist.add(
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 10.h)),
                                            );
                                            if (data.info["use_bus"] != "") {
                                              clist.add(normalfont(
                                                  data.info["use_bus"] == true
                                                      ? "버스 : 운행"
                                                      : "버스 : 미운행",
                                                  58,
                                                  Color(0xff808080)));
                                            }
                                          }
                                          if (placeCode == 5 ||
                                              placeCode == 6) {
                                            clist.add(
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 30.h)),
                                            );
                                            clist.add(normalfont("관람 / 체험료", 58,
                                                Color(0xff4d4d4d)));

                                            clist.add(
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 10.h)),
                                            );
                                            if (data.info["admissionFee"] !=
                                                "") {
                                              clist.add(normalfont(
                                                  "${data.info["admissionFee"]}",
                                                  58,
                                                  Color(0xff808080)));
                                            }
                                          }
                                          if (placeCode == 8) {
                                            clist.add(
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 30.h)),
                                            );
                                            clist.add(normalfont(
                                                "영업시간", 58, Color(0xff4d4d4d)));
                                            clist.add(
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 10.h)),
                                            );
                                            clist.add(normalfont(
                                                data.info["workedAt"] ==
                                                            "undefined" ||
                                                        data.info["workedAt"] ==
                                                            null
                                                    ? '준비 중입니다.'
                                                    : "${data.info["workedAt"]}",
                                                58,
                                                Color(0xff808080)));
                                            clist.add(
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 30.h)),
                                            );
                                            clist.add(normalfont(
                                                "매장정보", 58, Color(0xff4d4d4d)));
                                            clist.add(
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 10.h)),
                                            );
                                            clist.add(normalfont(
                                                data.info["store_info"] ==
                                                            "undefined" ||
                                                        data.info[
                                                                "store_info"] ==
                                                            null
                                                    ? '준비 중입니다.'
                                                    : "${data.info["store_info"]}",
                                                58,
                                                Color(0xff808080)));
                                            clist.add(
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 30.h)),
                                            );
                                            clist.add(normalfont(
                                                "홈페이지", 58, Color(0xff4d4d4d)));
                                            clist.add(
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 10.h)),
                                            );
                                            clist.add(
                                              InkWell(
                                                child: normalfont(
                                                    data.info["url"] ==
                                                            "undefined"
                                                        ? '준비 중입니다.'
                                                        : "${data.info["url"]}",
                                                    58,
                                                    Color(0xff808080)),
                                                onTap: () async {
                                                  if (await canLaunch(
                                                      data.info["url"])) {
                                                    await launch(
                                                        data.info["url"]);
                                                  } else {
                                                    throw 'Could not launch ${data.info["url"]}';
                                                  }
                                                },
                                              ),
                                            );
                                          }

                                          clist.add(Padding(
                                              padding:
                                                  EdgeInsets.only(top: 50.w)));

                                          return new Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: clist);
                                        } else {
                                          return Container();
                                        }
                                      }()),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                height: 26 * height.h,
                                color: Color(0xfff7f7f7),
                              ),
                              (() {
                                if (placeCode == 1) {
                                  return Container(
                                    child: data.facility == null
                                        ? Container()
                                        : Container(
                                            height: 928.h,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.only(
                                                    left: 75.w,
                                                    top: 50.h,
                                                  ),
                                                  child: normalfont("편의시설", 58,
                                                      Color(0xff4d4d4d)),
                                                ),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 50.h)),
                                                Row(
                                                    // crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 67.w)),
                                                      data.facility[
                                                                  "babyMenu"] ==
                                                              true
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
                                                              EdgeInsets.only(
                                                                  left: 59.w)),
                                                      data.facility[
                                                                  "babyBed"] ==
                                                              true
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
                                                              EdgeInsets.only(
                                                                  left: 59.w)),
                                                      data.facility[
                                                                  "babyTableware"] ==
                                                              true
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
                                                              EdgeInsets.only(
                                                                  left: 59.w)),
                                                      data.facility[
                                                                  "meetingRoom"] ==
                                                              true
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
                                                              EdgeInsets.only(
                                                                  left: 59.w)),
                                                      data.facility[
                                                                  "diaperChange"] ==
                                                              true
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
                                                              EdgeInsets.only(
                                                                  left: 59.w)),
                                                    ]),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 50.h)),
                                                Row(
                                                  children: [
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 67.w)),
                                                    data.facility["playRoom"] ==
                                                            true
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
                                                            EdgeInsets.only(
                                                                left: 59.w)),
                                                    data.facility["stroller"] ==
                                                            true
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
                                                            EdgeInsets.only(
                                                                left: 59.w)),
                                                    data.facility[
                                                                "nursingRoom"] ==
                                                            true
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
                                                            EdgeInsets.only(
                                                                left: 59.w)),
                                                    data.facility[
                                                                "babyChair"] ==
                                                            true
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
                                } else {
                                  return Container();
                                }
                              }()),

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
                                                padding:
                                                    EdgeInsets.only(top: 30.h)),
                                            GestureDetector(
                                              onTap: () {},
                                              child: Container(
                                                height: 1100.h,
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
                                                    _controller =
                                                        webViewController;
                                                    _controller.loadUrl(url +
                                                        '/detail?name=${data.name}&address=${data.address}');
                                                  },
                                                  javascriptMode: JavascriptMode
                                                      .unrestricted,
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
                                    height: 170.h,
                                    child: Center(
                                      child: Image.asset(
                                        "./assets/sublistPage/modify.png",
                                        height: 80.h,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: 26 * height.h,
                                color: Color(0xfff7f7f7),
                              ),
                              placeCode == 2
                                  ? Container(
                                      margin: EdgeInsets.only(
                                          top: 36 * height.h,
                                          left: 35 * width.w,
                                          right: 35 * width.w,
                                          bottom: 253 * height.h),
                                      padding: EdgeInsets.all(18 * width.w),
                                      decoration: BoxDecoration(
                                          color: Color.fromRGBO(
                                              255, 114, 142, 0.1),
                                          border: Border.all(
                                            color: Color.fromRGBO(
                                                255, 114, 142, 0.7),
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              boldfont(
                                                  "특정의료기관에 대한 리뷰",
                                                  56,
                                                  Color.fromRGBO(
                                                      255, 114, 142, 0.7)),
                                              normalfont(
                                                  "는 의료법에 따라 치료 효과로",
                                                  56,
                                                  Color.fromRGBO(
                                                      255, 114, 142, 0.7))
                                            ],
                                          ),
                                          normalfont(
                                              "오인하게 할 우려가 있고, 환자 유인행위의 소지가 있어 리뷰를 작성할 수 없습니다.",
                                              56,
                                              Color.fromRGBO(
                                                  255, 114, 142, 0.7))
                                        ],
                                      ))
                                  : Container(),

                              placeCode == 1
                                  ? Container(
                                      margin: EdgeInsets.only(
                                        left: 87 * width.w,
                                        top: 36 * height.h,
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                  width: 210 * height.h,
                                                  child: RichText(
                                                    textAlign: TextAlign.center,
                                                    text: TextSpan(
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xff939393),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily:
                                                              "NotoSansCJKkr_Medium",
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontSize: 62.sp),
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                            text:
                                                                '${data.name}',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontFamily:
                                                                    "NotoSansCJKkr_Bold",
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal,
                                                                fontSize:
                                                                    62.sp)),
                                                        TextSpan(text: '에'),
                                                        data.name.length < 5
                                                            ? TextSpan(
                                                                text: '\n')
                                                            : TextSpan(
                                                                text: ''),
                                                        TextSpan(
                                                            text: ' 다녀오셨나요?'),
                                                      ],
                                                    ),
                                                  )
                                                  // child: Column(
                                                  //   children: [
                                                  //     Row(
                                                  //       children: [
                                                  //         normalfont("${data.name}",
                                                  //             58, Colors.black),
                                                  //         normalfont("에", 58,
                                                  //             Color(0xff939393)),
                                                  //         normalfont("다녀오셨나요?", 58,
                                                  //             Color(0xff939393)),
                                                  //       ],
                                                  //     ),
                                                  //   ],
                                                  // )
                                                  ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  left: 44 * width.w,
                                                ),
                                              ),
                                              isMyId
                                                  ? InkWell(
                                                      child: Image.asset(
                                                        "./assets/sublistPage/reviewrevisebutton.png",
                                                        height: 54 * height.h,
                                                      ),
                                                      onTap: () async {
                                                        var result = await Get
                                                            .to(ReviewPage(
                                                                reviewData:
                                                                    myReviewData,
                                                                data: data));

                                                        if (result == "ok") {
                                                          await select(option);
                                                          await selectImage();
                                                          setState(() {});
                                                        }
                                                      },
                                                    )
                                                  : InkWell(
                                                      child: Image.asset(
                                                        "./assets/sublistPage/reviewbutton.png",
                                                        height: 54 * height.h,
                                                      ),
                                                      onTap: () async {
                                                        var result =
                                                            await Get.to(
                                                                ReviewPage(
                                                                    reviewData:
                                                                        null,
                                                                    data:
                                                                        data));

                                                        if (result == "ok") {
                                                          await select(option);
                                                          await selectImage();
                                                          setState(() {});
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
                                          left: 36 * width.w,
                                          top: 36 * width.h),
                                      child: Stack(
                                        children: [
                                          Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.4),
                                                      offset: Offset(
                                                          2.0, 4.0), //(x,y)
                                                      blurRadius: 7.0,
                                                      spreadRadius: 1,
                                                    ),
                                                  ],
                                                  border: Border.all(
                                                    color: Colors.white,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(20))),
                                              height: 193 * height.h,
                                              width: 648 * width.w),
                                          Container(
                                            margin: EdgeInsets.only(top: 35.h),
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 22 * height.h),
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    normalfont(
                                                        "고객만족도",
                                                        24 * width,
                                                        Color(0xff939393)),
                                                    boldfont(
                                                        '${averageTotalRating}',
                                                        55 * width,
                                                        Color(0xff3a3939)),
                                                    Row(
                                                      children: [
                                                        for (int i = 0;
                                                            i <
                                                                averageTotalRating
                                                                    .toInt();
                                                            i++)
                                                          Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    right: 12 *
                                                                        width
                                                                            .w),
                                                            child: Image.asset(
                                                              "./assets/listPage/star_color.png",
                                                              width:
                                                                  38 * width.w,
                                                            ),
                                                          ),
                                                        (averageTotalRating -
                                                                    averageTotalRating
                                                                        .toInt() >
                                                                0)
                                                            ? Container(
                                                                margin: EdgeInsets.only(
                                                                    right: 12 *
                                                                        width
                                                                            .w),
                                                                child:
                                                                    Image.asset(
                                                                  "./assets/listPage/star_half.png",
                                                                  width: 38 *
                                                                      width.w,
                                                                ),
                                                              )
                                                            : Container(),
                                                        for (int i = 0;
                                                            i <
                                                                5 -
                                                                    averageTotalRating
                                                                        .ceil()
                                                                        .toInt();
                                                            i++)
                                                          Container(
                                                            child: Image.asset(
                                                              "./assets/listPage/star_grey.png",
                                                              width:
                                                                  38 * width.w,
                                                            ),
                                                            margin:
                                                                EdgeInsets.only(
                                                                    right: 12 *
                                                                        width
                                                                            .w),
                                                          ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 30 * width.w)),
                                                Column(
                                                  children: [
                                                    Image.asset(
                                                      "./assets/sublistPage/line.png",
                                                      height: 158 * height.h,
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 35 * width.w)),
                                                Column(
                                                  children: [
                                                    normalfont(
                                                        '${totalRating[4]}',
                                                        50,
                                                        Color(0xffa9a9a9)),
                                                    scoreImage(4),
                                                    normalfont("5점", 50,
                                                        Color(0xffa9a9a9)),
                                                  ],
                                                ),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 21 * width.w)),
                                                Column(
                                                  children: [
                                                    normalfont(
                                                        '${totalRating[3]}',
                                                        50,
                                                        Color(0xffa9a9a9)),
                                                    scoreImage(3),
                                                    normalfont("4점", 50,
                                                        Color(0xffa9a9a9)),
                                                  ],
                                                ),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 21 * width.w)),
                                                Column(
                                                  children: [
                                                    normalfont(
                                                        '${totalRating[2]}',
                                                        50,
                                                        Color(0xffa9a9a9)),
                                                    scoreImage(2),
                                                    normalfont("3점", 50,
                                                        Color(0xffa9a9a9)),
                                                  ],
                                                ),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 21 * width.w)),
                                                Column(
                                                  children: [
                                                    normalfont(
                                                        '${totalRating[1]}',
                                                        50,
                                                        Color(0xffa9a9a9)),
                                                    scoreImage(1),
                                                    normalfont("2점", 50,
                                                        Color(0xffa9a9a9)),
                                                  ],
                                                ),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 21 * width.w)),
                                                Column(
                                                  children: [
                                                    normalfont(
                                                        '${totalRating[0]}',
                                                        50,
                                                        Color(0xffa9a9a9)),
                                                    scoreImage(0),
                                                    normalfont("1점", 50,
                                                        Color(0xffa9a9a9)),
                                                  ],
                                                ),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 21 * width.w)),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  : Container(),

                              placeCode == 1
                                  ? Padding(
                                      padding:
                                          EdgeInsets.only(top: 36 * width.w))
                                  : Padding(
                                      padding:
                                          EdgeInsets.only(top: 0 * width.w)),

                              // 4 images

                              placeCode == 1
                                  ? Row(
                                      children: [
                                        Padding(
                                            padding:
                                                EdgeInsets.only(left: 36.w)),
                                        for (int i = 0;
                                            i < previewImagePath.length;
                                            i++)
                                          i < 3
                                              ? Container(
                                                  margin: EdgeInsets.only(
                                                      left: 18 * width.w),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                    child: SizedBox(
                                                      width: 148 * width.w,
                                                      height: 148 * height.w,
                                                      child: Image.network(
                                                        previewImagePath[i],
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : InkWell(
                                                  onTap: () {
                                                    Get.to(ReviewImage(
                                                        data: imageJson));
                                                  },
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                        left: 18 * width.w),
                                                    child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        child: Stack(
                                                          children: [
                                                            SizedBox(
                                                              width:
                                                                  148 * width.w,
                                                              height: 148 *
                                                                  height.w,
                                                              child:
                                                                  Image.network(
                                                                previewImagePath[
                                                                    i],
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                            Container(
                                                              width:
                                                                  148 * width.w,
                                                              height: 148 *
                                                                  height.w,
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.5),
                                                            ),
                                                            Container(
                                                              width:
                                                                  148 * width.w,
                                                              height:
                                                                  148 * width.w,
                                                              child: Center(
                                                                child:
                                                                    Image.asset(
                                                                  "./assets/reviewPage/plus.png",
                                                                  color: Colors
                                                                      .white,
                                                                  width: 38 *
                                                                      width.w,
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
                                      padding:
                                          EdgeInsets.only(top: 36 * width.w))
                                  : Padding(
                                      padding:
                                          EdgeInsets.only(top: 0 * width.w)),
                              placeCode == 1
                                  ? Container(
                                      height: 26 * height.h,
                                      color: Color(0xfff7f7f7),
                                    )
                                  : Container(),

                              //Sorting condition
                              placeCode == 1
                                  ? Container(
                                      height: 200.h,
                                      width: double.infinity,
                                      child: Row(
                                        children: [
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  top: 80 * height.h,
                                                  left: 35 * width.w)),
                                          normalfont("리뷰 ", 30 * width,
                                              Color(0xff4d4d4d)),
                                          normalfont(
                                              allReviewDatas.length.toString(),
                                              30 * width,
                                              Color(0xffe9718d)),
                                          Spacer(),
                                          Container(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                InkWell(
                                                  onTap: () async {
                                                    option = "date";
                                                    await select(option);
                                                  },
                                                  child: normalfont(
                                                      "최신순",
                                                      26 * width,
                                                      option == "date"
                                                          ? Color(0xff4d4d4d)
                                                          : Color(0xff939393)),
                                                ),
                                                normalfont(" | ", 26 * width,
                                                    Color(0xffdddddd)),
                                                InkWell(
                                                  onTap: () async {
                                                    option = "top";
                                                    await select(option);
                                                  },
                                                  child: normalfont(
                                                      "평점높은순",
                                                      26 * width,
                                                      option == "top"
                                                          ? Color(0xff4d4d4d)
                                                          : Color(0xff939393)),
                                                ),
                                                normalfont(" | ", 26 * width,
                                                    Color(0xffdddddd)),
                                                InkWell(
                                                  onTap: () {
                                                    option = "low";
                                                    select(option);
                                                  },
                                                  child: normalfont(
                                                      "평점낮은순",
                                                      26 * width,
                                                      option == "low"
                                                          ? Color(0xff4d4d4d)
                                                          : Color(0xff939393)),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                              padding: EdgeInsets.only(
                                            right: 38.w,
                                          )),
                                        ],
                                      ),
                                    )
                                  : Container(),
                              (() {
                                return Container(
                                  child: ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: allReviewDatas.length,
                                    itemBuilder: (context, index) {
                                      if (allReviewDatas.length == 0) {
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
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      allReviewDatas[index]
                                                                      .user[
                                                                  "profile"] !=
                                                              null
                                                          ? CircleAvatar(
                                                              radius:
                                                                  40 * width.w,
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  image: DecorationImage(
                                                                      image: NetworkImage(
                                                                          allReviewDatas[index].user[
                                                                              "profile"]),
                                                                      fit: BoxFit
                                                                          .cover),
                                                                ),
                                                              ),
                                                            )
                                                          : CircleAvatar(
                                                              radius:
                                                                  40 * width.w,
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
                                                                    "${allReviewDatas[index].user["nickname"]} ",
                                                                    58,
                                                                    Colors
                                                                        .black),
                                                                Padding(
                                                                    padding: EdgeInsets.only(
                                                                        left: 5 *
                                                                            width.w)),
                                                                normalfont(
                                                                    "${allReviewDatas[index].updatedAt} ",
                                                                    58,
                                                                    Color(
                                                                        0xff808080)),
                                                              ],
                                                            ),
                                                            // 3 Rating buttons
                                                            Row(
                                                              children: [
                                                                average('맛',
                                                                    "${allReviewDatas[index].tasteRating}"),
                                                                Padding(
                                                                    padding: EdgeInsets.only(
                                                                        left: 8 *
                                                                            width.w)),
                                                                average('가격',
                                                                    "${allReviewDatas[index].costRating}"),
                                                                Padding(
                                                                    padding: EdgeInsets.only(
                                                                        left: 8
                                                                            .w)),
                                                                average('서비스',
                                                                    "${allReviewDatas[index].serviceRating}"),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      UserController
                                                                  .to.userId ==
                                                              allReviewDatas[
                                                                      index]
                                                                  .user[
                                                                      "userId"]
                                                                  .toString()
                                                          ? Row(
                                                              children: [
                                                                InkWell(
                                                                  onTap:
                                                                      () async {
                                                                    var result = await Get.to(ReviewPage(
                                                                        reviewData:
                                                                            myReviewData,
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
                                                                        fontSize: 24 *
                                                                            width
                                                                                .sp,
                                                                        fontFamily:
                                                                            "NotoSansCJKkr_Medium",
                                                                        color: Color.fromRGBO(
                                                                            147,
                                                                            147,
                                                                            147,
                                                                            1.0)),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                    padding: EdgeInsets.only(
                                                                        left: 20 *
                                                                            width.w)),
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
                                                                              62.5,
                                                                              Color(0xff4d4d4d)),
                                                                          actions: <
                                                                              Widget>[
                                                                            FlatButton(
                                                                              child: normalfont("예", 62.5, Color(0xffff7292)),
                                                                              onPressed: () async {
                                                                                Navigator.pop(context, "OK");
                                                                                await delete(allReviewDatas[index].id);
                                                                                allReviewDatas = null;
                                                                                isMyId = false;
                                                                                await select(option);
                                                                              },
                                                                            ),
                                                                            FlatButton(
                                                                              child: normalfont("아니오", 62.5, Color(0xffff7292)),
                                                                              onPressed: () {
                                                                                Navigator.pop(context, "Cancel");
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
                                                                            width
                                                                                .sp,
                                                                        fontFamily:
                                                                            "NotoSansCJKkr_Medium",
                                                                        color: Color.fromRGBO(
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
                                                                    allReviewDatas[
                                                                            index]
                                                                        .id);
                                                              },
                                                              child: Text(
                                                                "신고",
                                                                style: TextStyle(
                                                                    fontSize: 24 *
                                                                        width
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
                                                  ),
                                                  //text message
                                                  Container(
                                                    width: double.infinity,
                                                    margin: EdgeInsets.only(
                                                        top: 16 * width.w),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                13 * width.w,
                                                            vertical:
                                                                19 * width.w),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(10),
                                                      ),
                                                      color: Color.fromRGBO(
                                                          248, 248, 248, 1.0),
                                                    ),
                                                    child: Text(
                                                      "${allReviewDatas[index].desc} ", //
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
                                                      allReviewDatas[index]
                                                                  .images
                                                                  .length ==
                                                              0
                                                          ? Container()
                                                          : Container(
                                                              height: 236 *
                                                                  height.h,
                                                              child: ListView(
                                                                scrollDirection:
                                                                    Axis.horizontal,
                                                                padding: EdgeInsets.only(
                                                                    top: 16 *
                                                                        height
                                                                            .h),
                                                                children: <
                                                                    Widget>[
                                                                  for (int i =
                                                                          0;
                                                                      i <
                                                                          allReviewDatas[index]
                                                                              .images
                                                                              .length;
                                                                      i++)
                                                                    InkWell(
                                                                      child:
                                                                          Container(
                                                                        margin: EdgeInsets.only(
                                                                            right:
                                                                                10 * width.w),
                                                                        width: 308 *
                                                                            width.w,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.all(Radius.circular(10)),
                                                                          image: DecorationImage(
                                                                              image: NetworkImage(allReviewDatas[index].images[i]["previewImagePath"]),
                                                                              fit: BoxFit.fitWidth),
                                                                        ),
                                                                      ),
                                                                      onTap:
                                                                          () {
                                                                        Get.to(
                                                                            ImageBig(),
                                                                            arguments: {
                                                                              "page": "listsub",
                                                                              "image": allReviewDatas[index].images,
                                                                              "index": i,
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
                                height: 300.h,
                              )
                            ],
                          ),
                        ],
                      );
                    }
                  }),
              Container(
                margin: EdgeInsets.only(left: 1150.w, top: 2100.h),
                child: InkWell(
                  onTap: () {
                    _scrollController.jumpTo(1);
                  },
                  child:
                      Image.asset("./assets/sublistPage/top.png", width: 350.w),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget scoreImage(i) {
    if (maxScore == totalRating[i] && totalRating[i] != 0) {
      return Image.asset(
        "./assets/sublistPage/bar6.png",
        height: 89 * height.h,
      );
    } else {
      if (totalRating[i] == 0) {
        return Image.asset(
          "./assets/sublistPage/bar1.png",
          height: 89 * height.h,
        );
      } else if (0 <= totalRating[i] ||
          totalRating[i] <= maxScore * (1 / 4).ceil()) {
        return Image.asset(
          "./assets/sublistPage/bar2.png",
          height: 89 * height.h,
        );
      } else if (maxScore * (1 / 4).ceil() < totalRating[i] ||
          totalRating[i] <= maxScore * (2 / 4).ceil()) {
        return Image.asset(
          "./assets/sublistPage/bar3.png",
          height: 89 * height.h,
        );
      } else if (maxScore * (2 / 4).ceil() < totalRating[i] ||
          totalRating[i] <= maxScore * (3 / 4).ceil()) {
        return Image.asset(
          "./assets/sublistPage/bar4.png",
          height: 89 * height.h,
        );
      } else {
        return Image.asset(
          "./assets/sublistPage/bar5.png",
          height: 89 * height.h,
        );
      }
    }
  }
}
