import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:uahage/src/Controller/user.controller.dart';
import 'package:uahage/src/Static/Font/font.dart';
import 'package:uahage/src/Static/Image/homeImage.dart';
import 'package:uahage/src/Static/Widget/appbar.dart';
import 'package:get/get.dart';
import 'package:uahage/src/Static/Widget/toast.dart';
import 'package:uahage/src/View/Nav/HomeSub/searchBar.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var width = 1500 / 720;
  var height = 2667 / 1280;

  imageView(fileName) {
    return CachedNetworkImage(
      fadeInDuration: Duration(microseconds: 10),
      fadeOutDuration: Duration(microseconds: 10),
      imageUrl:
          "https://uahage.s3.ap-northeast-2.amazonaws.com/homepage/$fileName.png",
      fit: BoxFit.fill,
    );
  }

  int index = 1;
  String keyword = "";
  @override
  Widget build(BuildContext context) {
    print(UserController.to.userId);
    print(UserController.to.token);
    FocusScopeNode currentFocus = FocusScope.of(context);
    ScreenUtil.init(context, width: 1125, height: 2436);
    return GestureDetector(
      onPanDown: (a) {},
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: imageAppbar(context, "우아하게"),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: 1125.w,
                height: 677.h,
                child: Stack(
                  children: [
                    PageView.builder(
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        return imageView("image${index + 1}");
                      },
                      // onPageChanged: (int page) {
                      //   setState(() {
                      //     print(page);
                      //     index = page + 1;
                      //   });
                      // },
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        decoration: new BoxDecoration(
                            color: Color.fromRGBO(255, 114, 148, 0.5),
                            //   image: DecorationImage(
                            //     image: AssetImage('./assets/path.png'),
                            //   ),
                            borderRadius: BorderRadius.circular(20.0)),
                        margin: EdgeInsets.only(top: 775.h, right: 40.w),
                        padding:
                            EdgeInsets.symmetric(vertical: 1, horizontal: 10),
                        child: Text(
                          '$index/1',
                          style: TextStyle(
                            fontSize: 62.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 65.w, top: 55.h),
                      child: boldfont(
                          "영·유아 보호자와\n함께하는\n정보제공 서비스", 64, Color(0xffff7292)),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(49.w, 53.h, 49.w, 0),
                height: 132.h,
                child: Theme(
                  data: new ThemeData(
                      primaryColor: Color.fromRGBO(255, 114, 148, 1.0),
                      fontFamily: 'NotoSansCJKkr_Medium'),
                  child: TextField(
                    onChanged: (txt) {
                      setState(() {
                        keyword = txt;
                      });
                    },
                    cursorColor: Color(0xffff7292),
                    style: TextStyle(
                        color: Color(0xffff7292),
                        fontSize: 46.sp,
                        letterSpacing: -1.0),
                    decoration: InputDecoration(
                      fillColor: Color(0xffff7292),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            width: 2,
                            color: Color(0xffff7292),
                          )),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            width: 2,
                            color: Color(0xffff7292),
                          )),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            width: 0,
                            color: Color(0xffff7292),
                          )),
                      contentPadding: EdgeInsets.fromLTRB(53.w, 0, 0, 0),
                      hintText: "장소, 주소, 상호명을 검색해주세요",
                      hintStyle: TextStyle(
                          color: Color(0xffcccccc),
                          fontSize: 46.sp,
                          fontFamily: 'NotoSansCJKkr_Medium',
                          letterSpacing: -1.0),
                      suffixIcon: IconButton(
                          onPressed: keyword != ""
                              ? () {
                                  //  FocusScope.of(context).unfocus();
print("home keyword : $keyword");
                                  Get.toNamed("/searchbar",
                                      arguments: keyword);
                                }
                              : () {
                                  toast(context, "주소를 입력해주세요!", "bottom");
                                  //  FocusScope.of(context).unfocus();
                                },
                          icon: Image.asset(
                            "./assets/homePage/search.png",
                            width: 65.w,
                            height: 65.h,
                          )),
                    ),
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(
                top: 50.h,
              )),
              Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                          padding: EdgeInsets.only(
                        left: 56.w,
                      )),
                      GestureDetector(
                        child: Image.asset(
                          homeimage[0],
                          width: 164.w,
                          height: 167.h,
                        ),
                        onTap: () {
                          //  currentFocus.unfocus();
                          Get.toNamed("/list", arguments: 1);
                        },
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                        left: 137.w,
                      )),
                      GestureDetector(
                        child: Image.asset(
                          homeimage[1],
                          width: 125.w,
                          height: 200.h,
                        ),
                        onTap: () {
                          // currentFocus.unfocus();
                          Get.toNamed("/list", arguments: 2);
                        },
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                        left: 145.w,
                      )),
                      GestureDetector(
                        child: Image.asset(
                          homeimage[2],
                          width: 144.w,
                          height: 207.h,
                        ),
                        onTap: () {
                          //  currentFocus.unfocus();
                          Get.toNamed("/list", arguments: 3);
                        },
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                        left: 151.w,
                      )),
                      GestureDetector(
                        child: Image.asset(
                          homeimage[3],
                          width: 112.w,
                          height: 195.2.h,
                        ),
                        onTap: () {
                          currentFocus.unfocus();
                          toast(context, " 서비스 준비 중이에요!  ", "bottom");
                        },
                      ),
                    ],
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                    top: 80.h,
                  )),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                          padding: EdgeInsets.only(
                        left: 66.5.w,
                      )),
                      GestureDetector(
                        child: Image.asset(
                          homeimage[4],
                          width: 144.w,
                          height: 197.h,
                        ),
                        onTap: () {
                          // currentFocus.unfocus();
                          Get.toNamed("/list", arguments: 5);
                        },
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                        left: 155.w,
                      )),
                      GestureDetector(
                        child: Image.asset(
                          homeimage[5],
                          width: 114.w,
                          height: 181.h,
                        ),
                        onTap: () {
                          //  currentFocus.unfocus();
                          Get.toNamed("/list", arguments: 6);
                        },
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                        left: 166.w,
                      )),
                      GestureDetector(
                        child: Image.asset(
                          homeimage[6],
                          width: 108.w,
                          height: 187.h,
                        ),
                        onTap: () {
                          currentFocus.unfocus();
                          toast(context, " 서비스 준비 중이에요!  ", "bottom");
                        },
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                        left: 171 .w,
                      )),
                      GestureDetector(
                        child: Image.asset(
                          homeimage[7],
                          width: 117.3.w,
                          height: 181 .h,
                        ),
                        onTap: () {
                          //   currentFocus.unfocus();
                          Get.toNamed("/list", arguments: 8);
                        },
                      ),
                    ],
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                    top: 103.h,
                  )),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                          padding: EdgeInsets.only(
                        left: 65.w,
                      )),
                      GestureDetector(
                        child: Image.asset(
                          homeimage[8],
                          width: 144.w,
                          height: 175.h,
                        ),
                        onTap: () {
                          currentFocus.unfocus();
                          toast(context, " 서비스 준비 중이에요!  ", "bottom");
                        },
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                  padding: EdgeInsets.only(
                top: 40.h,
              )),
              Container(
                padding: EdgeInsets.only(
                  left: 68.w,
                  top: 50.h,
                  bottom: 33.h,
                ),
                color: Color.fromRGBO(247, 248, 250, 1.0),
                // height: 650 .h,
                width: 1125.w,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        "./assets/homePage/logo_grey.png",
                        width: 191.w,
                        height: 47.h,
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                        top: 20.h,
                      )),
                      normalfont(
                          "상호명 : (주)호호컴퍼니\n대표이사 : 김화영     사업자등록번호 : 322-86-01766\n유선번호 : 061-331-3116  팩스 : 061-331-3117\nemail : hohoco0701@gmail.com \n주소 : 전라남도 나주시 빛가람로 740 한빛타워 6층 601호\ncopyrightⓒ 호호컴퍼니 Inc. All Rights Reserved.            \n사업자 정보 확인   |   이용약관   |   개인정보처리방침",
                          30,
                          Color.fromRGBO(151, 151, 151, 1.0)),
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
