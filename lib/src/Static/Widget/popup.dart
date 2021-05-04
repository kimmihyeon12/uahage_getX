import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:uahage/src/Controller/image.controller.dart';

class pop extends GetView<ImageController> {
  popup(context) {
    return showGeneralDialog(
        context: context,
        pageBuilder: (BuildContext buildContext, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return StatefulBuilder(builder: (context, setState) {
            return SafeArea(
              child: Builder(builder: (context) {
                return Obx(
                  () => Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            top: 600.h, bottom: 0.h, left: 190.w, right: 0.w),
                        width: 1100.w,
                        height: 1060.h,
                        child: Card(
                          shadowColor: Colors.black54,
                          elevation: 1,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Container(
                            margin: EdgeInsets.only(
                                top: 85.h, left: 50.w, right: 50.w),
                            child: SizedBox(
                              child: GridView.count(
                                crossAxisCount: 3,
                                children: List.generate(9, (index) {
                                  return Scaffold(
                                    backgroundColor: Colors.white,
                                    body: Center(
                                      child: InkWell(
                                        onTap: () {
                                          controller.setFilterImage(index);
                                        },
                                        child:
                                            controller.filter_image[index] == 0
                                                ? Image.asset(
                                                    "./assets/searchPage/image" +
                                                        (index + 1).toString() +
                                                        "_grey.png",
                                                    height: 293.h,
                                                    width: 218.w,
                                                  )
                                                : Image.asset(
                                                    "./assets/searchPage/image" +
                                                        (index + 1).toString() +
                                                        ".png",
                                                    height: 293.h,
                                                    width: 218.w,
                                                  ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 1850.h,
                        left: 400.w,
                        right: 400.w,
                        child: SizedBox(
                          width: 611.w,
                          height: 195.h,
                          child: FlatButton(
                            onPressed: () async {
                              Get.back(result: true);
                            },
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(8.0),
                            ),
                            color: Color.fromRGBO(255, 114, 148, 1.0),
                            child: Text(
                              "OK",
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'NotoSansCJKkr_Medium',
                                fontSize: 60.sp,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            );
          });
        },
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: null,
        transitionDuration: const Duration(milliseconds: 150));
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
