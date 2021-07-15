import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:uahage/src/Controller/place.restaurant.bookmark.controller.dart';
import 'package:uahage/src/Static/Font/font.dart';

appBar(context, text, bookmarkColor) {
  return  PreferredSize(
      preferredSize: Size.fromHeight(130.h),
      child: Container(
        decoration: BoxDecoration(
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.black38,
                  blurRadius: 5.0,
                  offset: Offset(0.0, 0.75)
              )
            ],
          color: Colors.white,
        ),


        height: 270.h,
        child: Stack(
          children: [
            Container(
              margin:EdgeInsets.only(top:105.h,left:30.w),
              child: IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: Color(0xffff7292)),
                  onPressed: () {
                    Get.back(result: bookmarkColor);
                  }),
            ),
            Container(
              width: 1125.w,
              child: Center(
                child: Container(
                  margin: EdgeInsets.only(top:90.h),
                  child: normalfont(text, 55,Color(0xffff7292))
                  ,),
              ),
            )


          ],
        ),
      ));



}

imageAppbar(context, text) {
  return PreferredSize(
      preferredSize: Size.fromHeight(130.h),
      child: Container(
        child: Stack(
          children: [
            Image.asset(
              './assets/homePage/bar.png',
              fit: BoxFit.fill,
              height: 400.h,

            ),

text != "우아하게"?
            Container(
              width: 1125.w,
              child: Center(
                child: Container(
                  margin: EdgeInsets.only(top:90.h),
                  child: normalfont(text, 55,Colors.white)
                  ,),
              ),
            ):

            Container(
              width:1125.w,
              margin: EdgeInsets.only(top:95.h),
              child: Center(
                child: Image.asset(
                  './assets/homePage/uahage.png',
                  fit: BoxFit.fill,
                  height: 75.h,
                ),
              ),
            )
          ],
        ),
      ));
}
