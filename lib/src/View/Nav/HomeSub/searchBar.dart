import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:uahage/src/Controller/connection.controller.dart';
import 'package:uahage/src/Controller/location.controller.dart';
import 'package:uahage/src/Controller/place.restaurant.bookmark.controller.dart';
import 'package:uahage/src/Controller/user.controller.dart';
import 'package:uahage/src/Service/connection.dart';
import 'package:uahage/src/Service/places.restaurant.bookmarks.dart';
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
  String url = pageURL;
  WebViewController controller;
  String keyword = Get.arguments;
  Bookmark bookmark = new Bookmark();
  int page = 0;
  @override
  final key = UniqueKey();
  Widget build(BuildContext context) {
    connection();

    ScreenUtil.init(context, width: 1500, height: 2667);
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
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
                            final key = UniqueKey();
                            await controller.loadUrl(url +
                                "/search?keyword=$keyword&userId=${UserController.to.userId}");
                            //  "/maps/show-list?userId=${UserController.to.userId}&lat=${LocationController.to.lat.value}&lon=${LocationController.to.lon.value}&keyword=%27$keyword%27&token=${UserController.to.token.value}");
                          },
                          javascriptMode: JavascriptMode.unrestricted,
                          javascriptChannels: Set.from([
                            JavascriptChannel(
                                name: 'Print',
                                onMessageReceived:
                                    (JavascriptMessage message) async {
                                  var messages = jsonDecode(message.message);
                                  print("searchbar");
                                  print(messages);
                                  if (messages == null) {
                                    Get.off(SearchNoneResult(),
                                        transition: Transition.fadeIn);
                                  }

                                  await placepopup(context, messages, "", 1);
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
      ),
    );
  }
}
