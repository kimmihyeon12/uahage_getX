import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:uahage/src/Binding/place.restaurant.bookmark.binding.dart';
import 'package:uahage/src/Controller/place.restaurant.bookmark.controller.dart';
import 'package:uahage/src/Controller/user.controller.dart';
import 'package:uahage/src/Model/experienceCenter.dart';
import 'package:uahage/src/Model/hospitals.dart';
import 'package:uahage/src/Model/kidCafe.dart';
import 'package:uahage/src/Model/restaurant.dart';

import 'package:uahage/src/Service/places.restaurant.bookmarks.dart';
import 'package:uahage/src/Service/report.dart';
import 'package:uahage/src/Service/review.dart';
import 'package:uahage/src/Static/Font/font.dart';
import 'package:uahage/src/Static/Widget/dialog.dart';
import 'package:uahage/src/View/Auth/announce.dart';
import 'package:uahage/src/View/Nav/HomeSub/listSub.dart';

import 'icon.dart';

class pop extends StatefulWidget {
  @override
  _popState createState() => _popState();
}

class _popState extends State<pop> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

Future<Object> popup(context, grey_image) {
  return showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext buildContext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return StatefulBuilder(builder: (context, setState) {
          return SafeArea(
            child: Builder(builder: (context) {
              return Stack(
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
                        margin:
                            EdgeInsets.only(top: 85.h, left: 50.w, right: 50.w),
                        child: SizedBox(
                          child: GridView.count(
                            crossAxisCount: 3,
                            children: List.generate(9, (index) {
                              return Scaffold(
                                backgroundColor: Colors.white,
                                body: Center(
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        grey_image[index] = 1;
                                      });
                                      print(grey_image);
                                    },
                                    child: grey_image[index] == 0
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
                          Navigator.pop(context, grey_image);
                          grey_image = [
                            0,
                            0,
                            0,
                            0,
                            0,
                            0,
                            0,
                            0,
                            0,
                          ];
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
              );
            }),
          );
        });
      },
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: null,
      transitionDuration: const Duration(milliseconds: 150));
}

Future<Object> placepopup(context, Message, type, placeCode) async {
  print(Message["name"]);
  int mark;
  if (placeCode == 1) {
    mark = Message["bookmark"];
  }

  Bookmark bookmark = new Bookmark();
  return showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext buildContext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return StatefulBuilder(builder: (context, setState) {
          return Builder(builder: (context) {
            return Stack(
              children: [
                GestureDetector(
                  onPanDown: (a) {
                    Navigator.pop(context);
                  },
                  child: Container(
                    color: Colors.transparent,
                    width: MediaQuery.of(context).size.width,
                    height: type == 'search' ? 1874.h : 2100.h,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: type == 'search' ? 1900.h : 2100.h,
                      bottom: type == 'search' ? 263.h : 50.h,
                      left: 33.w,
                      right: 33.w),
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                    shadowColor: Colors.black54,
                    elevation: 1,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: InkWell(
                      onTap: () async {
                        var message;
                        if (placeCode == 1) {
                          message = Restaurant.fromJson(Message);
                          message.bookmark = mark;
                        } else if (placeCode == 2) {
                          message = Hospitals.fromJson(Message);
                        } else if (placeCode == 4) {
                          message = KidCafe.fromJson(Message);
                        } else if (placeCode == 5) {
                          message = Experiencecenter.fromJson(Message);
                        }

                        print(message);
                        // // Navigator.push(
                        // //     context,
                        // //     MaterialPageRoute(
                        // //         builder: (context) => ListSub("")) );
                        // Get.to(Announce());
                        var result = await Get.offNamed("/listsub", arguments: {
                          "data": message,
                          "placeCode": placeCode,
                          "index": 1,
                        });
                        setState(() {
                          mark = result;
                        });
                        print("result $result");
                      },
                      child: Row(
                        children: [
                          Padding(
                              padding: EdgeInsets.only(
                            left: 30.w,
                          )),
                          Image.asset(
                            "./assets/listPage/clipGroup1.png",
                            height: 409.h,
                            width: 413.w,
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                            left: 53.w,
                          )),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 50.h),
                                width: 900.w,
                                height: 82.h,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 700.w,
                                      child: Text(
                                          Message["name"].length <= 10
                                              ? Message["name"]
                                              : Message["name"]
                                                  .substring(0, 11),
                                          style: TextStyle(
                                            color: const Color(0xff010000),
                                            fontWeight: FontWeight.w500,
                                            fontFamily: "NotoSansCJKkr_Bold",
                                            fontStyle: FontStyle.normal,
                                            fontSize: 58.sp,
                                          ),
                                          textAlign: TextAlign.left),
                                    ),
                                    (() {
                                      if (placeCode == 1) {
                                        return Container(
                                          margin: EdgeInsets.only(
                                              left: 8.w, top: 25.h),
                                          child: InkWell(
                                            child: Container(
                                              padding: EdgeInsets.only(
                                                  left: 30.w,
                                                  right: 30.w,
                                                  bottom: 10.h),
                                              child: Image.asset(
                                                mark == 0 || mark == null
                                                    ? "./assets/listPage/love_grey.png"
                                                    : "./assets/listPage/love_color.png",
                                                height: 80.h,
                                              ),
                                            ),
                                            onTap: () async {
                                              if (mark == 0 || mark == null) {
                                                await bookmark.bookmarkToogle(
                                                    UserController
                                                        .to.userId.value,
                                                    Message["id"]);

                                                setState(() {
                                                  mark = 1;
                                                });
                                              } else {
                                                await bookmark.bookmarkToogle(
                                                    UserController
                                                        .to.userId.value,
                                                    Message["id"]);
                                                BookmarkController.to
                                                    .starPlaceBookmarkrefresh(
                                                        Message["index"]);
                                                setState(() {
                                                  mark = 0;
                                                });
                                              }
                                            },
                                          ),
                                        );
                                      } else {
                                        return Container();
                                      }
                                    }())
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10.h),
                                width: 650.w,
                                height: 135.h,
                                child: Text(Message["address"],
                                    style: TextStyle(
                                        color: const Color(0xffb0b0b0),
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "NotoSansCJKkr_Medium",
                                        fontStyle: FontStyle.normal,
                                        fontSize: 56.sp,
                                        height: 1.3),
                                    textAlign: TextAlign.left),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 15.h),
                                height: 120.h,
                                width: 650.w,
                                alignment: Alignment.bottomRight,
                                child: Row(children: [
                                  icon(
                                      context,
                                      Message["baby_menu"],
                                      Message["stroller"],
                                      Message["baby_bed"],
                                      Message["baby_tableware"],
                                      Message["nursing_room"],
                                      Message["meeting_room"],
                                      Message["diaper_change"],
                                      Message["play_room"],
                                      Message["baby_chair"]

                                      // PlaceController
                                      //     .to.place[index].parking
                                      //     .toString())
                                      ),
                                ]),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          });
        });
      },
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: null,
      transitionDuration: const Duration(milliseconds: 150));
}

class Report extends StatefulWidget {
  List reportIndex = [false, false, false, false, false, false];

  var width = 1500 / 720;
  var height = 2667 / 1280;

  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

report(context, reviewId) {
  print("report");
  List reportIndex = [false, false, false, false, false, false];
  var width = 1500 / 720;
  var height = 2667 / 1280;
  bool isreport = false;
  final myController = TextEditingController();
  bool btnColor = false;
  return showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext buildContext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return StatefulBuilder(builder: (context, setState) {
          return SafeArea(
            child: Builder(builder: (context) {
              return Container(
                color: Colors.black54,
                child: Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          top: 231 * height.h,
                          bottom: 0.h,
                          left: 85 * width.w,
                          right: 0.w),
                      width: 550 * width.w,
                      height: 736 * height.h,
                      child: Card(
                        shadowColor: Colors.black54,
                        elevation: 1,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Container(
                            margin: EdgeInsets.only(
                              top: 30 * height.h,
                              left: 33 * width.w,
                              right: 33 * width.w,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                        width: 420 * width.w,
                                        child:
                                            boldfont("신고유형", 68, Colors.black)),
                                    InkWell(
                                      onTap: () {
                                        Get.back();
                                      },
                                      child: Image.asset(
                                        "./assets/sublistPage/cancel.png",
                                        width: 26 * width.w,
                                      ),
                                    ),
                                  ],
                                ),

                                Padding(
                                    padding:
                                        EdgeInsets.only(top: 37 * height.h)),
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          reportIndex[0] = !reportIndex[0];
                                          isreport = false;
                                          for (int i = 0;
                                              i < reportIndex.length;
                                              i++) {
                                            if (reportIndex[i]) {
                                              isreport = true;
                                            }
                                          }
                                        });
                                      },
                                      child: reportIndex[0]
                                          ? Image.asset(
                                              "./assets/sublistPage/check.png",
                                              width: 32 * width.w,
                                            )
                                          : Image.asset(
                                              "./assets/sublistPage/uncheck.png",
                                              width: 32 * width.w,
                                            ),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(
                                            right: 7 * width.w)),
                                    Container(
                                      width: 206 * width.w,
                                      child: normalfont(
                                          "영리목적/홍보성", 58, Color(0xff666666)),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          reportIndex[1] = !reportIndex[1];
                                          isreport = false;
                                          for (int i = 0;
                                              i < reportIndex.length;
                                              i++) {
                                            if (reportIndex[i]) {
                                              isreport = true;
                                            }
                                          }
                                        });
                                      },
                                      child: reportIndex[1]
                                          ? Image.asset(
                                              "./assets/sublistPage/check.png",
                                              width: 32 * width.w,
                                            )
                                          : Image.asset(
                                              "./assets/sublistPage/uncheck.png",
                                              width: 32 * width.w,
                                            ),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(
                                            right: 7 * width.w)),
                                    normalfont("기능작동오류", 58, Color(0xff666666)),
                                  ],
                                ),
                                Padding(
                                    padding:
                                        EdgeInsets.only(top: 47 * height.h)),

                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          reportIndex[2] = !reportIndex[2];
                                          isreport = false;
                                          for (int i = 0;
                                              i < reportIndex.length;
                                              i++) {
                                            if (reportIndex[i]) {
                                              isreport = true;
                                            }
                                          }
                                        });
                                      },
                                      child: reportIndex[2]
                                          ? Image.asset(
                                              "./assets/sublistPage/check.png",
                                              width: 32 * width.w,
                                            )
                                          : Image.asset(
                                              "./assets/sublistPage/uncheck.png",
                                              width: 32 * width.w,
                                            ),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(
                                            right: 7 * width.w)),
                                    Container(
                                      width: 206 * width.w,
                                      child: normalfont(
                                          "음란성/선전성", 58, Color(0xff666666)),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          reportIndex[3] = !reportIndex[3];
                                          isreport = false;
                                          for (int i = 0;
                                              i < reportIndex.length;
                                              i++) {
                                            if (reportIndex[i]) {
                                              isreport = true;
                                            }
                                          }
                                        });
                                      },
                                      child: reportIndex[3]
                                          ? Image.asset(
                                              "./assets/sublistPage/check.png",
                                              width: 32 * width.w,
                                            )
                                          : Image.asset(
                                              "./assets/sublistPage/uncheck.png",
                                              width: 32 * width.w,
                                            ),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(
                                            right: 7 * width.w)),
                                    normalfont(
                                        "욕설/인신공격", 58, Color(0xff666666)),
                                  ],
                                ),
                                Padding(
                                    padding:
                                        EdgeInsets.only(top: 47 * height.h)),
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          reportIndex[4] = !reportIndex[4];
                                          isreport = false;
                                          for (int i = 0;
                                              i < reportIndex.length;
                                              i++) {
                                            if (reportIndex[i]) {
                                              isreport = true;
                                            }
                                          }
                                        });
                                      },
                                      child: reportIndex[4]
                                          ? Image.asset(
                                              "./assets/sublistPage/check.png",
                                              width: 32 * width.w,
                                            )
                                          : Image.asset(
                                              "./assets/sublistPage/uncheck.png",
                                              width: 32 * width.w,
                                            ),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(
                                            right: 7 * width.w)),
                                    Container(
                                      width: 206 * width.w,
                                      child: normalfont(
                                          "개인정보노출", 58, Color(0xff666666)),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          reportIndex[5] = !reportIndex[5];
                                          isreport = false;
                                          for (int i = 0;
                                              i < reportIndex.length;
                                              i++) {
                                            if (reportIndex[i]) {
                                              isreport = true;
                                            }
                                          }
                                        });
                                      },
                                      child: reportIndex[5]
                                          ? Image.asset(
                                              "./assets/sublistPage/check.png",
                                              width: 32 * width.w,
                                            )
                                          : Image.asset(
                                              "./assets/sublistPage/uncheck.png",
                                              width: 32 * width.w,
                                            ),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(
                                            right: 7 * width.w)),
                                    normalfont("반복 게시", 58, Color(0xff666666)),
                                  ],
                                ),
                                Padding(
                                    padding:
                                        EdgeInsets.only(top: 49 * height.h)),
                                // Text input
                                Container(
                                  width: double.infinity,
                                  height: 330 * width.w,
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(255, 114, 142, 0.05),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    border: Border.all(
                                      color: Color.fromRGBO(255, 114, 142, 0.4),
                                    ),
                                  ),
                                  child: TextFormField(
                                    onChanged: (e) {
                                      if (myController.text.length >= 10) {
                                        setState(() {
                                          btnColor = true;
                                        });
                                      } else {
                                        if (btnColor)
                                          setState(() {
                                            btnColor = false;
                                          });
                                      }
                                    },
                                    controller: myController,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color:
                                            Color.fromRGBO(255, 114, 142, 0.6)),
                                    maxLines: 20,
                                    maxLength: 100,
                                    cursorColor:
                                        Color.fromRGBO(255, 114, 142, 0.6),
                                    decoration: InputDecoration(
                                      isDense: true,
                                      border: InputBorder.none,
                                      hintText: "신고하실 내용을 설명해주세요",
                                      hintStyle: TextStyle(
                                          color: Color.fromRGBO(
                                              255, 114, 142, 0.6)),
                                      counterStyle: TextStyle(
                                          fontSize: 50.sp,
                                          color: Color.fromRGBO(
                                              255, 114, 142, 0.6),
                                          fontFamily: "NotoSansCJKkr_Medium"),
                                      contentPadding: EdgeInsets.only(
                                          top: 20.sp,
                                          right: 19.sp,
                                          left: 15.sp),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      ),
                    ),
                    Positioned(
                      top: 1000 * height.h,
                      left: 117 * width.w,
                      right: 117 * width.w,
                      child: SizedBox(
                        width: 488 * width.w,
                        height: 96 * height.h,
                        child: FlatButton(
                          onPressed: () async {
                            if (myController.text.length > 10 && isreport) {
                              bool result = await reviewReport(
                                  reportIndex, reviewId, myController.text);
                              if (result) {
                                await dialog(context, "신고가 완료되었습니다");
                                Get.back();
                              }
                            } else {
                              await dialog(context, "모든필드를 입력해주세요");
                            }
                          },
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(8.0),
                          ),
                          color: (() {
                            return myController.text.length > 10 && isreport
                                ? Color.fromRGBO(255, 114, 148, 1.0)
                                : Color.fromRGBO(212, 212, 212, 1.0);
                          }()),
                          child: Text(
                            "완료",
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
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: null,
      transitionDuration: const Duration(milliseconds: 150));
}
