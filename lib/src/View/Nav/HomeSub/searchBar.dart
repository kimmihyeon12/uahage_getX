import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:uahage/src/Controller/location.controller.dart';
import 'package:uahage/src/Static/Widget/progress.dart';

import 'package:uahage/src/Static/url.dart';
import 'package:webview_flutter/webview_flutter.dart';
import "package:uahage/src/View/Nav/HomeSub/searchBarToggle.dart";

class SearchBar extends StatefulWidget {
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  String url = URL;
  WebViewController controller;
  String keyword = Get.arguments;

  @override
  final key = UniqueKey();
  Widget build(BuildContext context) {
    print("searchbarpage");
    ScreenUtil.init(context, width: 1500, height: 2667);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              color: Colors.white,
              child: WebView(
                key: key,
                onWebViewCreated: (WebViewController webViewController) async {
                  controller = webViewController;
                  final key = UniqueKey();
                  await controller.loadUrl(url +
                      "/maps/show-list?lat=${LocationController.to.lat.value}&lon=${LocationController.to.lon.value}&keyword=%27$keyword%27");
                  print(controller.currentUrl().toString());
                },
                javascriptMode: JavascriptMode.unrestricted,
                javascriptChannels: Set.from([
                  JavascriptChannel(
                      name: 'Print',
                      onMessageReceived: (JavascriptMessage message) async {
                        var messages = message.message;
                        print('messages: ' + messages);
                        // return SearchBarToggle(address:messages);
                      }),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
