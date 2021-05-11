import 'package:flutter/material.dart';
import 'package:uahage/src/Controller/location.controller.dart';
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
  String url = URL;
  WebViewController webview;
  final key = UniqueKey();
  List<int> grey_image = [0, 0, 0, 0, 0, 0, 0, 0, 0];

  Future searchCategory() async {
    await webview.loadUrl(url +
        "/maps/show-place?lat=${LocationController.to.lat.value}&lon=${LocationController.to.lon.value}&type=filter&menu=${grey_image[0]}&bed=${grey_image[1]}&tableware=${grey_image[2]}&meetingroom=${grey_image[3]}&diapers=${grey_image[4]}&playroom=${grey_image[5]}&carriage=${grey_image[6]}&nursingroom=${grey_image[7]}&chair=${grey_image[8]}");
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 1500, height: 2667);
    return Scaffold(
      body: SafeArea(
        child: Stack(children: [
          WebView(
            key: key,
            onWebViewCreated: (WebViewController webViewController) async {
              webview = webViewController;
              await webview.loadUrl(url +
                  '/maps/show-place?lat=${LocationController.to.lat.value}&lon=${LocationController.to.lon.value}&type=allsearch&place_code=${1}');
            },
            javascriptMode: JavascriptMode.unrestricted,
            javascriptChannels: Set.from([
              JavascriptChannel(
                  name: 'Print',
                  onMessageReceived: (JavascriptMessage message) async {
                    var messages = message.message;
                    print(messages);
                    var Message = messages.split("|");
                    var JsonMessage = {
                      "id": Message[0],
                      "name": Message[1],
                      "address": Message[2],
                      "phone": Message[3],
                      "carriage": Message[4],
                      "bed": Message[5],
                      "tableware": Message[6],
                      "nursingroom": Message[7],
                      "meetingroom": Message[8],
                      "diapers": Message[9],
                      "playroom": Message[10],
                      "chair": Message[11],
                      "menu": Message[12],
                      "examination": Message[13],
                      "fare": Message[14],
                    };
                    await placepopup(
                      context,
                      JsonMessage,
                      "",
                    );
                  }),
            ]),
          ),
          widget.placeCode == 1
              ? GestureDetector(
                  onTap: () async {
                    setState(() {
                      grey_image = [0, 0, 0, 0, 0, 0, 0, 0, 0];
                    });

                    List okButton = await popup(context, grey_image);
                    if (okButton != null) {
                      grey_image = okButton;
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
                )
              : Container()
        ]),
      ),
    );
  }
}
