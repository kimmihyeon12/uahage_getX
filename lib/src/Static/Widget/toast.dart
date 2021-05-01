import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uahage_getx/src/Static/Font/font.dart';

toast(context, text) {
  ScreenUtil.init(context, width: 1500, height: 2667);
  FToast fToast = FToast();
  fToast.init(context);
  Widget toast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      color: Colors.black45,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        normalfont(text, 45, Colors.white),
      ],
    ),
  );

  fToast.showToast(
    child: toast,
    gravity: ToastGravity.BOTTOM,
    toastDuration: Duration(seconds: 1),
  );
}
