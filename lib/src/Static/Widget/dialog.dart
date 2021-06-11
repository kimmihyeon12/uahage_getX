import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:uahage/src/Static/Font/font.dart';
import 'package:uahage/src/Static/Widget/progress.dart';

SpinKitThreeBounce buildSpinKitThreeBounce(double size, double screenWidth) {
  return SpinKitThreeBounce(
    color: Color(0xffFF728E),
    size: size,
  );
}

dialog(context, text) {
  return showDialog(
    context: context,
    builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      title: normalfont(text, 62.5, Color(0xff4d4d4d)),
      actions: [
        FlatButton(
          onPressed: () {
            Get.back();
          },
          child: normalfont("확인", 62.5, Color(0xffff7292)),
        ),
      ],
    ),
  );
}

Future awaitdialog(var function, BuildContext context, var heightSize,
    var widthSize, var height, var width, var _fontsize) {
  ScreenUtil.init(context, width: 1500, height: 2667);
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (ctx) => FutureBuilder(
      future: function,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            title: Text(
              snapshot.data,
              style: TextStyle(
                  color: const Color(0xff4d4d4d),
                  fontWeight: FontWeight.w500,
                  fontFamily: "NotoSansCJKkr_Medium",
                  fontStyle: FontStyle.normal,
                  fontSize: 55.sp),
            ),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: // 확인
                    normalfont("확인", 62.5, Color(0xffff7292)),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return AlertDialog(
            title: Text(
              "${snapshot.error}",
              style: TextStyle(
                  color: const Color(0xff4d4d4d),
                  fontWeight: FontWeight.w500,
                  fontFamily: "NotoSansCJKkr_Medium",
                  fontStyle: FontStyle.normal,
                  fontSize: 55.sp),
            ),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: // 확인
                    normalfont("확인", 62.5, Color(0xffff7292)),
              ),
            ],
          );
        }
        return progress();
      },
    ),
  );
}
