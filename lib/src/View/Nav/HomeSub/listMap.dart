import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uahage/src/Controller/location.controller.dart';
import 'package:uahage/src/Controller/place.controller.dart';
import 'package:uahage/src/Controller/place.restaurant.bookmark.controller.dart';
import 'package:uahage/src/Controller/user.controller.dart';

import 'package:uahage/src/Service/places.dart';
import 'package:uahage/src/Service/places.restaurant.bookmarks.dart';
import 'package:uahage/src/Static/Widget/popup.dart';
import 'package:uahage/src/Static/Widget/progress.dart';
import 'package:uahage/src/Static/url.dart';

import 'package:webview_flutter/webview_flutter.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'dart:async';

class ListMap extends StatefulWidget {
  int placeCode;
  ListMap({this.placeCode});
  @override
  _ListMapState createState() => _ListMapState();
}

class _ListMapState extends State<ListMap> {
  String url = pageURL;
  WebViewController webview;
  final key = UniqueKey();
  List<bool> greyImage = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];
  Bookmark bookmark = new Bookmark();
  String placeName;
  int placeCode;
  String test = "";
  Future searchCategory() async {
    await webview.loadUrl(url +
        "/?userId=${UserController.to.userId}&lat=${LocationController.to.lat.value}&lon=${LocationController.to.lon.value}&babyMenu=${greyImage[0]}&babyBed=${greyImage[1]}&babyTableware=${greyImage[2]}&meetingRoom=${greyImage[3]}&diaperChange=${greyImage[4]}&playRoom=${greyImage[5]}&stroller=${greyImage[6]}&nursingRoom=${greyImage[7]}&babyChair=${greyImage[8]}");
  }

  initState() {
    // 부모의 initState호출
    super.initState();
    placeCode = widget.placeCode;
    placeName = Place.getPlaceName(placeCode);
  }

  @override
  Widget build(BuildContext context) {
    Get.put(PlaceController());
    ScreenUtil.init(context, width: 1500, height: 2667);
    return Scaffold(
      body: SafeArea(
        child: Stack(children: [
          WebView(
            key: key,
            debuggingEnabled: true,
            onWebViewCreated: (WebViewController webViewController) async {
              webview = webViewController;
              if (placeCode == 1) {
                await webview.loadUrl(url +
                    "/?lat=${LocationController.to.lat.value}&lon=${LocationController.to.lon.value}&userId=${UserController.to.userId}");

                // '/maps/show-place?type=filter&userId=${UserController.to.userId}&lat=${LocationController.to.lat.value}&lon=${LocationController.to.lon.value}&babyBed=&babyChair=&babyMenu=&babyTableware=&stroller=&diaperChange=&meetingRoom=&nursingRoom=&playRoom=&parking=&isBookmarked=&placeName=${placeName}&token=${UserController.to.token.value}');
              } else {
                print("placeName");
                print(placeName);
                await webview.loadUrl(url +
                    '/places?name=${placeName}&lat=${LocationController.to.lat.value}&lon=${LocationController.to.lon.value}');
              }
            },
            javascriptMode: JavascriptMode.unrestricted,
            javascriptChannels: Set.from([
              JavascriptChannel(
                  name: 'Print',
                  onMessageReceived: (JavascriptMessage message) async {
                    var messages = jsonDecode(message.message);

                    print("messages $messages");

                    await placepopup(context, messages, "", placeCode);
                  }),
            ]),
          ),
          widget.placeCode == 1
              ? GestureDetector(
                  onTap: () async {
                    setState(() {
                      // greyImage = [
                      //   false,
                      //   false,
                      //   false,
                      //   false,
                      //   false,
                      //   false,
                      //   false,
                      //   false,
                      //   false
                      // ];
                    });

                    List okButton = await popup(context, greyImage);
                    if (okButton != null) {
                      greyImage = okButton;
                      await searchCategory();
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                    margin: EdgeInsets.fromLTRB(51.w, 100.h, 51.w, 0),
                    height: 196.h,
                    child: Row(
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 53.w),
                          child: Image.asset(
                            "./assets/searchPage/arrow.png",
                            height: 68.h,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 41.w),
                          width: 1200.w,
                          child: // 검색 조건을 설정해주세요
                              Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("검색 조건을 설정해주세요",
                                  style: TextStyle(
                                      color: const Color(0xffed7191),
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "NotoSansCJKkr_Medium",
                                      fontStyle: FontStyle.normal,
                                      fontSize: 65.sp),
                                  textAlign: TextAlign.left),
                              InkWell(
                                child: Image.asset(
                                  "./assets/searchPage/cat_btn.png",
                                  height: 158.h,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Container()
        ]),
      ),
    );
  }
}
