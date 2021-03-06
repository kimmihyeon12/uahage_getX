import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:get/get.dart';

import 'package:uahage/src/Controller/location.controller.dart';
import 'package:uahage/src/Controller/place.restaurant.bookmark.controller.dart';
import 'package:uahage/src/Controller/user.controller.dart';
import 'package:uahage/src/Service/places.restaurant.bookmarks.dart';
import 'package:uahage/src/Static/Widget/progress.dart';

import 'package:uahage/src/Static/url.dart';
import 'dart:async';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uahage/src/Static/Widget/popup.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String url = pageURL;
  WebViewController webview;
  Bookmark bookmark = new Bookmark();
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

  Future searchCategory() async {
    await webview.loadUrl(url +
        "/?userId=${UserController.to.userId}&lat=${LocationController.to.lat.value}&lon=${LocationController.to.lon.value}&babyMenu=${greyImage[0]}&babyBed=${greyImage[1]}&babyTableware=${greyImage[2]}&meetingRoom=${greyImage[3]}&diaperChange=${greyImage[4]}&playRoom=${greyImage[5]}&stroller=${greyImage[6]}&nursingRoom=${greyImage[7]}&babyChair=${greyImage[8]}");
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 1500, height: 2667);
    return Scaffold(
      body: Stack(
        children: [
          WebView(
            onWebResourceError: (e) {
              return progress();
            },
            key: key,
            onWebViewCreated: (WebViewController webViewController) async {
              webview = webViewController;

              await webview.loadUrl(url +
                  "/?lat=${LocationController.to.lat.value}&lon=${LocationController.to.lon.value}&userId=${UserController.to.userId}");
            },
            javascriptMode: JavascriptMode.unrestricted,
            javascriptChannels: Set.from([
              JavascriptChannel(
                  name: 'Print',
                  onMessageReceived: (JavascriptMessage message) async {
                    var messages = jsonDecode(message.message);
                    await placepopup(context, messages, "", 1);
                  })
            ]),
          ),
          GestureDetector(
            onTap: () async {
              setState(() {
                greyImage = [
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
              margin: EdgeInsets.fromLTRB(51.w, 161.h, 51.w, 0),
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
                    child: // ?????? ????????? ??????????????????
                        Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("?????? ????????? ?????????????????? ????",
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
          ),
        ],
      ),
    );
  }
}
