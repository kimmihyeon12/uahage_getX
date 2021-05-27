import 'package:uahage/src/Controller/location.controller.dart';
import 'package:uahage/src/Controller/place.restaurant.bookmark.controller.dart';
import 'package:uahage/src/Controller/user.controller.dart';
import 'package:uahage/src/Service/places.restaurant.bookmarks.dart';
import 'package:uahage/src/Static/Widget/popup.dart';
import 'package:uahage/src/Static/Widget/progress.dart';
import 'package:uahage/src/Static/url.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_config/flutter_config.dart';

class SearchBarToggle extends StatefulWidget {
  @override
  _SearchBarToggleState createState() => _SearchBarToggleState();
}

class _SearchBarToggleState extends State<SearchBarToggle> {
  int toggle = 0;
  WebViewController controller;
  String url = URL;
  List<String> name = [];
  List<String> address = [];
  Bookmark bookmark = new Bookmark();
  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: toggle,
      children: [
        WillPopScope(
          //     onWillPop: _onbackpressed,
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              toolbarHeight: 250.h,
              // automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_sharp,
                  color: Color(0xffff7292),
                ),
                iconSize: 100.w,
                color: Colors.white,
                onPressed: () {
                  // setState(() {
                  //   searchbtn = false;
                  //   print(searchbtn);
                  // });
                  Navigator.pop(context, 'closed');
                },
              ),
              elevation: 0,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                      padding: EdgeInsets.only(
                    top: 500.h,
                  )),
                  // Padding(
                  //     padding: EdgeInsets.only(
                  //   left: 870 .w,
                  // )),
                  GestureDetector(
                    child: Image.asset(
                      './assets/off.png',
                      width: 290.w,
                      height: 183.h,
                    ),
                    onTap: () {
                      setState(() {
                        toggle = 1;
                      });
                    },
                  ),
                ],
              ),
            ),
            body: Stack(
              children: [
                ListView.builder(
                    itemCount: name.length,
                    itemBuilder: (context, index) {
                      print('snapshot.data.length');
                      // print(snapshot.data.id[index]);
                      return Card(
                        elevation: 0.3,
                        child: GestureDetector(
                          child: Container(
                              height: 400.h,
                              padding: EdgeInsets.only(
                                top: 30.h,
                                left: 26.w,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                      padding: EdgeInsets.only(
                                    top: 200 /
                                        (1501 /
                                            MediaQuery.of(context).size.width),
                                  )),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 1300.w,
                                        height: 100.h,
                                        child: Text(
                                          name[index],
                                          style: TextStyle(
                                            fontSize: 56.sp,
                                            fontFamily: 'NotoSansCJKkr_Medium',
                                          ),
                                        ),
                                      ),
                                      SafeArea(
                                        child: Container(
                                          height: 200.h,
                                          width: 800.w,
                                          child: Text(
                                            address[index],
                                            style: TextStyle(
                                                // fontFamily: 'NatoSans',
                                                color: Colors.grey,
                                                fontSize: 56.sp,
                                                fontFamily:
                                                    'NotoSansCJKkr_Medium',
                                                height: 1.3),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                        ),
                      );
                    })
              ],
            ),
          ),
        ),
        WillPopScope(
          //   onWillPop: _onbackpressed,
          child: Scaffold(
            body: Stack(
              children: [
                SafeArea(
                  child: Stack(children: [
                    WebView(
                      //  onPageFinished: doneLoading,
                      //   onPageStarted: startLoading,
                      onWebViewCreated:
                          (WebViewController webViewController) async {
                        controller = webViewController;
                        await controller.loadUrl(url +
                            "/maps/show-place?type=allsearch&lat=${LocationController.to.lat}&lon=${LocationController.to.lon}&placeName=restaurants");
                      },
                      javascriptMode: JavascriptMode.unrestricted,
                      javascriptChannels: Set.from([
                        JavascriptChannel(
                            name: 'Print',
                            onMessageReceived:
                                (JavascriptMessage message) async {
                              var messages = message.message;
                              print("messages: $messages");
                              List ex = messages.split(",");
                              setState(() {
                                name.add(ex[0]);
                                address.add(ex[1]);
                                // for (int j = 0; j < 2; j++) {
                                //   store_namelist[i] = ex[0];
                                //   addresslist[i] = ex[1];
                                //   print(i.toString() +
                                //       "store_namelist" +
                                //       store_namelist[i]);
                                //   print(i.toString() +
                                //       "addresslist" +
                                //       addresslist[i]);
                                // }
                                // i++;
                              });
                            }),
                        JavascriptChannel(
                            name: 'Print1',
                            onMessageReceived:
                                (JavascriptMessage message) async {
                              var messages = message.message;
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
                            })
                      ]),
                    ),
                    Row(
                      children: [
                        Padding(
                            padding: EdgeInsets.only(
                          top: 250.h,
                        )),
                        IconButton(
                          icon: Icon(Icons.arrow_back_ios_sharp),
                          iconSize: 100.w,
                          color: Color(0xffff7292),
                          onPressed: () {
                            // setState(() {
                            //   searchbtn = 0;
                            // });
                            Navigator.pop(context, 'Yep!');
                          },
                        ),
                        Padding(
                            padding: EdgeInsets.only(
                          left: 950.w,
                        )),
                        GestureDetector(
                          child: Image.asset(
                            './assets/on.png',
                            width: 290.w,
                            height: 183.h,
                          ),
                          onTap: () {
                            setState(() {
                              toggle = 0;
                            });
                          },
                        ),
                      ],
                    )
                  ]),
                )
              ],
            ),
          ),
        ),
        progress(),
      ],
    );
  }
}
