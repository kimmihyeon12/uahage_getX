import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:uahage/src/Static/Widget/appbar.dart';
import 'package:uahage/src/View/Nav/HomeSub/reviseSuggest.dart';

class SearchNoneResult extends StatefulWidget {
  @override
  _SearchNoneResultState createState() => _SearchNoneResultState();
}

class _SearchNoneResultState extends State<SearchNoneResult> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 1500, height: 2667);
    return SafeArea(
      child: Scaffold(
        appBar: imageAppbar(context, "우아하게"),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 803.h),
              child: Image.asset(
                './assets/starPage/group.png',
                height: 600.h,
                width: 800.w,
              ),
            ),
            InkWell(
              onTap: () {
                Get.to(ReviseSuggest(placeId: null, placeCategoryId: null));
              },
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 50.h),
                child: Image.asset(
                  './assets/starPage/placeregistrationrequest.png',
                  width: 500.w,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
