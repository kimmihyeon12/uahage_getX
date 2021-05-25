import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:get/get.dart';

import 'package:uahage/src/Controller/location.controller.dart';
import 'package:uahage/src/Controller/user.controller.dart';

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
  String url = URL;
  WebViewController webview;
  final key = UniqueKey();
  List<int> greyImage = [0, 0, 0, 0, 0, 0, 0, 0, 0];

  Future searchCategory() async {
    await webview.loadUrl(url +
        "/maps/show-place?userId=${UserController.to.userId.value}&lat=${LocationController.to.lat.value}&lon=${LocationController.to.lon.value}&type=filter&babyMenu=${greyImage[0]}&babyBed=${greyImage[1]}&babyTableware=${greyImage[2]}&meetingRoom=${greyImage[3]}&diaperChange=${greyImage[4]}&playRoom=${greyImage[5]}&stroller=${greyImage[6]}&nursingRoom=${greyImage[7]}&babyChair=${greyImage[8]}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          WebView(
            key: key,
            onWebViewCreated: (WebViewController webViewController) async {
              webview = webViewController;

              await webview.loadUrl(url +
                  '/maps?lat=${LocationController.to.lat.value}&lon=${LocationController.to.lon.value}');
            },
            javascriptMode: JavascriptMode.unrestricted,
            javascriptChannels: Set.from([
              JavascriptChannel(
                  name: 'Print',
                  onMessageReceived: (JavascriptMessage message) async {
                    // var messages = message.message;
                    // var Message = messages.split("|");
                    // var bookmark = await bookmarkSelect(LoginCotroller.to.userId.value, Message[0]);
                    // var JsonMessage = {
                    //   "id": Message[0],
                    //   "name": Message[1],
                    //   "address": Message[2],
                    //   "phone": Message[3],
                    //   "lat": Message[4],
                    //   "lon": Message[5],
                    //   "carriage": Message[6],
                    //   "bed": Message[7],
                    //   "tableware": Message[8],
                    //   "nursingroom": Message[9],
                    //   "meetingroom": Message[10],
                    //   "diapers": Message[11],
                    //   "playroom": Message[12],
                    //   "chair": Message[13],
                    //   "menu": Message[14],
                    //   "bookmark": bookmark.toString()
                    // };

                    // await showpopup.showPopUpbottomMenu(
                    //     context,
                    //     2667.h,
                    //     1501.w,
                    //     JsonMessage,
                    //     index,
                    //     userId,
                    //     loginOption,
                    //     "search",
                    //     "restaurant");
                  })
            ]),
          ),
          GestureDetector(
            onTap: () async {
              setState(() {
                greyImage = [0, 0, 0, 0, 0, 0, 0, 0, 0];
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
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 3,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
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
                                fontSize: 60.sp),
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
