import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:flutter/cupertino.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

SpinKitThreeBounce buildSpinKitThreeBounce(double size, double screenWidth) {
  return SpinKitThreeBounce(
    color: Color(0xffFF728E),
    size: size.w,
  );
}

Center progress() {
  return Center(
    child: SizedBox(
        height: 200.h,
        width: 200.w,
        child: buildSpinKitThreeBounce(80, 1500.w)),
  );
}
