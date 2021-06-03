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

  @override
  final key = UniqueKey();
  Widget build(BuildContext context) {
    connection();
    print("searchbarpage");
    ScreenUtil.init(context, width: 1500, height: 2667);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            ConnectionController.to.connectionstauts !=
                    "ConnectivityResult.none"
                ? Container(
                    color: Colors.white,
                    child: WebView(
                      key: key,
                      onWebViewCreated:
                          (WebViewController webViewController) async {
                        controller = webViewController;
                        final key = UniqueKey();
                        await controller.loadUrl(url +
                            "/maps/show-list?userId=${UserController.to.userId}&lat=${LocationController.to.lat.value}&lon=${LocationController.to.lon.value}&keyword=%27$keyword%27");
                        print(controller.currentUrl().toString());
                      },
                      javascriptMode: JavascriptMode.unrestricted,
                      javascriptChannels: Set.from([
                        JavascriptChannel(
                            name: 'Print',
                            onMessageReceived:
                                (JavascriptMessage message) async {
                              var messages = message.message;
                              print('messages: ' + messages);

                              var Message = messages.split("|");
                              var JsonMessage = {
                                "id": int.parse(Message[0]),
                                "name": Message[1],
                                "address": Message[2],
                                "phone": Message[3],
                                "stroller": Message[4] == "true" ? true : false,
                                "baby_bed": Message[5] == "true" ? true : false,
                                "baby_tableware":
                                    Message[6] == "true" ? true : false,
                                "nursing_room":
                                    Message[7] == "true" ? true : false,
                                "meeting_room":
                                    Message[8] == "true" ? true : false,
                                "diaper_change":
                                    Message[9] == "true" ? true : false,
                                "play_room":
                                    Message[10] == "true" ? true : false,
                                "baby_chair":
                                    Message[11] == "true" ? true : false,
                                "baby_menu":
                                    Message[12] == "true" ? true : false,
                                "parking": Message[13] == "true" ? true : false,
                                "bookmark": 0,
                              };
                              BookmarkController.to.placeBookmarkInit();
                              await bookmark
                                  .bookmarkSelectAll(UserController.to.userId);
                              for (int i = 0;
                                  i <
                                      BookmarkController
                                          .to.placeBookmark.length;
                                  i++) {
                                if (BookmarkController.to.placeBookmark[i].id
                                        .toString() ==
                                    Message[0].toString()) {
                                  JsonMessage["bookmark"] = 1;
                                }
                              }
                              await placepopup(context, JsonMessage, "", 1);
                            }),
                      ]),
                    ),
                  )
                : progress()
          ],
        ),
      ),
    );
  }
}
