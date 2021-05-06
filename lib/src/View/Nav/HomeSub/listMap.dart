import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:uahage/src/Controller/image.controller.dart';
import 'package:uahage/src/Controller/location.controller.dart';
import 'package:uahage/src/Static/Widget/popup.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../Static/url.dart';
import 'package:get/get.dart';

class ListMap extends GetView<LocationController> {
  int placeCode = Get.arguments;
  List<int> grey_image = [0, 0, 0, 0, 0, 0, 0, 0, 0];
  String url = URL;
  WebViewController webview;
  Future searchCategory() async {
    ImageController.to.setUrl(
        "/maps/show-place?lat=${controller.lat.value}&lon=${controller.lon.value}&type=filter&menu=${grey_image[0]}&bed=${grey_image[1]}&tableware=${grey_image[2]}&meetingroom=${grey_image[3]}&diapers=${grey_image[4]}&playroom=${grey_image[5]}&carriage=${grey_image[6]}&nursingroom=${grey_image[7]}&chair=${grey_image[8]}");
    await webview.loadUrl(url + ImageController.to.url.value);
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
              ImageController.to.setUrl(
                  '/maps/show-place?lat=${controller.lat.value}&lon=${controller.lon.value}&type=allsearch&place_code=$placeCode');
              await webview.loadUrl(url + ImageController.to.url.value);
              print(url + ImageController.to.url.value);
            },
            javascriptMode: JavascriptMode.unrestricted,
            javascriptChannels: Set.from([
              JavascriptChannel(
                  name: 'Print',
                  onMessageReceived: (JavascriptMessage message) async {})
            ]),
          ),
          placeCode == 1
              ? GestureDetector(
                  onTap: () async {
                    pop popup = new pop();
                    bool result = await popup.popup(context);
                    if (result) {
                      grey_image = ImageController.to.filter_image;
                      await searchCategory();
                    }
                    ImageController.to.initFilterImage();
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
                    margin: EdgeInsets.fromLTRB(51.w, 50.h, 51.w, 0),
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
              : Container(),
        ]),
      ),
    );
  }
}
