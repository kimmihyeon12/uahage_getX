import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:uahage/src/Controller/connection.controller.dart';
import 'package:uahage/src/Controller/location.controller.dart';
import 'package:uahage/src/Controller/place.restaurant.bookmark.controller.dart';
import 'package:uahage/src/Controller/user.controller.dart';
import 'package:uahage/src/Service/connection.dart';
import 'package:uahage/src/Service/places.restaurant.bookmarks.dart';
import 'package:uahage/src/Static/Widget/appbar.dart';
import 'package:uahage/src/Static/Widget/popup.dart';
import 'package:uahage/src/Static/Widget/progress.dart';

import 'package:uahage/src/Static/url.dart';
import 'package:uahage/src/View/Nav/HomeSub/searchNoneResult.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SearchBar extends StatefulWidget {
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  String url = URL;
  WebViewController controller;
  String keyword = Get.arguments;
  Bookmark bookmark = new Bookmark();
  int page = 0;
  @override
  final key = UniqueKey();
  Widget build(BuildContext context) {
    print("searchbar keyword : $keyword");
    connection();

    ScreenUtil.init(context, width: 1125, height: 2436);
    return Scaffold(
      appBar: appBar(context,"항목",""),
      body: IndexedStack(
        index: page,
        children: [
          Stack(
            children: [
              ConnectionController.to.connectionstauts !=
                      "ConnectivityResult.none"
                  ? Container(
                      color: Colors.white,
                      child: WebView(
                        key: key,
                        onPageStarted: (a) {
                          setState(() {
                            page = 1;
                          });
                        },
                        onPageFinished: (a) {
                          setState(() {
                            page = 0;
                          });
                        },
                        onWebViewCreated:
                            (WebViewController webViewController) async {
                          controller = webViewController;

                          print("키워드 : $keyword");
                          var _url = "/maps/show-list";

                          Map<String, String> queryParams = {
                            'userId':'${UserController.to.userId}',
                            'lat': '${LocationController.to.lat.value}',
                            'long': "${LocationController.to.lon.value}",
                            'keyword': "'$keyword'", //searchkey.toString()
                            'token':'${UserController.to.token.value}'
                          };
                          var headers = {
                            HttpHeaders.contentTypeHeader: 'application/json',
                          };
                          String queryString =
                              Uri(queryParameters: queryParams).query;
                          var requestUrl =url+ _url + '?' + queryString;
                          print(requestUrl);
                          await controller.loadUrl(requestUrl);
                          print(controller.currentUrl());
                            },
                        javascriptMode: JavascriptMode.unrestricted,
                        javascriptChannels: Set.from([
                          JavascriptChannel(
                              name: 'Print',
                              onMessageReceived:
                                  (JavascriptMessage message) async {
                                var messages = message.message;

                                if (messages == "null") {
                                  Get.off(SearchNoneResult(),
                                      transition: Transition.fadeIn);
                                }
                                // messages["bookmark"] = 0;
                                // BookmarkController.to.placeBookmarkInit();
                                // await bookmark
                                //     .bookmarkSelectAll(UserController.to.userId);
                                // for (int i = 0;
                                //     i <
                                //         BookmarkController
                                //             .to.placeBookmark.length;
                                //     i++) {
                                //   if (BookmarkController.to.placeBookmark[i].id ==
                                //       messages["id"]) {
                                //     messages["bookmark"] = 1;
                                //   }
                                // }

                                // await placepopup(context, messages, "", 1);
                              }),
                        ]),
                      ),
                    )
                  : progress()
            ],
          ),
          progress(),
        ],
      ),
    );
  }
}
