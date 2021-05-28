import 'package:cached_network_image/cached_network_image.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/search.dart';
import 'package:uahage/src/Controller/place.controller.dart';
import 'package:uahage/src/Controller/place.restaurant.bookmark.controller.dart';
import 'package:uahage/src/Controller/user.controller.dart';
import 'package:uahage/src/Service/places.dart';

import 'package:uahage/src/Service/places.restaurant.bookmarks.dart';
import 'package:uahage/src/Static/Font/font.dart';
import 'package:uahage/src/Static/Widget/appbar.dart';
import 'package:uahage/src/Static/Widget/toast.dart';
import 'package:uahage/src/Static/url.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ListSub extends StatefulWidget {
  @override
  _ListSubState createState() => _ListSubState();
}

class _ListSubState extends State<ListSub> {
  ScrollController _scrollController = ScrollController();
  WebViewController _controller;
  String url = URL;
  int placeCode = Get.arguments['placeCode'];
  var data = Get.arguments['data'];
  int index = Get.arguments['index'];

  Bookmark bookmark = new Bookmark();
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

  @override
  Widget build(BuildContext context) {
    print("listsub");
    ScreenUtil.init(context, width: 1500, height: 2667);
    return WillPopScope(
      onWillPop: () {
        Get.back(result: data.bookmark);
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: appBar(
            context,
            data.name,
            data.bookmark,
          ),
          body: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 1500.w,
                    child: (() {
                      if (placeCode == 1) {
                        if (index % 3 == 1) {
                          return mainImage(restaurantListImage[0], 1500.w);
                        } else if (index % 3 == 2) {
                          return mainImage(restaurantListImage[1], 1500.w);
                        } else
                          return mainImage(restaurantListImage[2], 1500.w);
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
                          return mainImage(experienceListImage[0], 1500.w);
                        else if (index % 4 == 2)
                          return mainImage(experienceListImage[1], 1500.w);
                        else if (index % 4 == 3)
                          return mainImage(experienceListImage[2], 1500.w);
                        else
                          return mainImage(experienceListImage[3], 1500.w);
                      }
                    }()),
                  ),
                  Container(
                    child: Container(
                      padding:
                          EdgeInsets.only(left: 75.w, top: 45.h, bottom: 45.h),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 1250.w,
                                child: boldfont(data.name, 77, Colors.black),
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
                                        maxWidth: 170.w, maxHeight: 170.h),
                                    icon: Image.asset(
                                        data.bookmark == 0
                                            ? "./assets/listPage/love_grey.png"
                                            : "./assets/listPage/love_color.png",
                                        height: 60.h),
                                    onPressed: () async {
                                      if (data.bookmark == 0) {
                                        print("하트");
                                        await bookmark.bookmarkToogle(
                                            UserController.to.userId.value,
                                            data.id);
                                        setState(() {
                                          data.bookmark = 1;
                                        });
                                      } else {
                                        await bookmark.bookmarkToogle(
                                            UserController.to.userId.value,
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
                                child: normalfont(
                                    "${data.address}", 58, Color(0xff808080)),
                              ),
                              Padding(padding: EdgeInsets.only(left: 100.w)),
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
                                child: normalfont(
                                    "${data.phone}", 58, Color(0xff808080)),
                              ),
                              Padding(padding: EdgeInsets.only(left: 100.w)),
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
                          Padding(padding: EdgeInsets.only(top: 50.w)),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 26.h,
                    color: Color(0xfff7f7f7),
                  ),
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
                                child:
                                    normalfont("편의시설", 58, Color(0xff4d4d4d)),
                              ),
                              Padding(padding: EdgeInsets.only(top: 50.h)),
                              Row(
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                        padding: EdgeInsets.only(left: 67.w)),
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
                                        padding: EdgeInsets.only(left: 59.w)),
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
                                        padding: EdgeInsets.only(left: 59.w)),
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
                                        padding: EdgeInsets.only(left: 59.w)),
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
                                        padding: EdgeInsets.only(left: 59.w)),
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
                                        padding: EdgeInsets.only(left: 59.w)),
                                  ]),
                              Padding(padding: EdgeInsets.only(top: 50.h)),
                              Row(
                                children: [
                                  Padding(padding: EdgeInsets.only(left: 67.w)),
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
                                  Padding(padding: EdgeInsets.only(left: 59.w)),
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
                                  Padding(padding: EdgeInsets.only(left: 59.w)),
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
                                  Padding(padding: EdgeInsets.only(left: 59.w)),
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
                              Padding(padding: EdgeInsets.only(top: 10.h)),
                              normalfont("${data.examination_items}", 58,
                                  Color(0xff808080)),
                              Padding(padding: EdgeInsets.only(top: 50.h)),
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
                              normalfont("관람 / 체험료", 58, Color(0xff4d4d4d)),
                              Padding(padding: EdgeInsets.only(top: 10.h)),
                              normalfont("${data.admission_fee}", 58,
                                  Color(0xff808080)),
                              Padding(padding: EdgeInsets.only(top: 50.h)),
                            ],
                          ),
                        ),
                      );
                    }
                  }()),
                  Container(
                    height: 26.h,
                    color: Color(0xfff7f7f7),
                  ),
                  Container(
                      child: Container(
                    //  height: 1300 .h,
                    width: 1500.w,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                              left: 75.w,
                              top: 50.h,
                            ),
                            child: normalfont("위치", 58, Color(0xff4d4d4d)),
                          ),
                          Padding(padding: EdgeInsets.only(top: 30.h)),
                          Container(
                            height: 1100.h,
                            child: WebView(
                              // gestureNavigationEnabled: true,
                              onWebViewCreated:
                                  (WebViewController webViewController) {
                                _controller = webViewController;
                                _controller.loadUrl(url +
                                    '/maps/show-place-name?placeName=${data.name}&placeAddress=${data.address}');
                              },
                              javascriptMode: JavascriptMode.unrestricted,
                            ),
                          ),
                        ]),
                  )),
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
