import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:uahage_getx/src/Controller/login.controller.dart';
import 'package:uahage_getx/src/Static/Font/font.dart';
import 'package:uahage_getx/src/Static/Widget/appbar.dart';
import 'package:uahage_getx/src/Controller/homepage.controller.dart';

import 'package:get/get.dart';
import 'package:uahage_getx/src/Static/Widget/toast.dart';
import 'package:uahage_getx/src/View/Nav/HomeSub/searchBar.dart';

class home extends GetView<homeContoller> {
  var homeimage = [
    "./assets/homePage/restaurant.png",
    "./assets/homePage/hospital.png",
    "./assets/homePage/careCenter.png",
    "./assets/homePage/kindergarten.png",
    "./assets/homePage/kidsCafe.png",
    "./assets/homePage/experiencecenter.png",
    "./assets/homePage/amusementpark.png",
    "./assets/homePage/toylibrary.png",
    "./assets/homePage/childcareCenter.png"
  ];
  imageView(fileName) {
    return CachedNetworkImage(
      imageUrl:
          "https://uahage.s3.ap-northeast-2.amazonaws.com/homepage/$fileName.png",
      fit: BoxFit.fill,
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(loginCotroller());
    print(loginCotroller.to.userId.value);
    print(loginCotroller.to.tokens.value);

    FocusScopeNode currentFocus = FocusScope.of(context);
    ScreenUtil.init(context, width: 1500, height: 2667);
    return GestureDetector(
      onPanDown: (a) {
        currentFocus.unfocus();
      },
      child: Obx(
        () => SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: imageAppbar(context, "홈"),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: 1500.w,
                    height: 900.h,
                    child: Stack(
                      children: [
                        PageView.builder(
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            print(controller.currentIndex.value);
                            return imageView(
                                "image${(controller.currentIndex.value) + 1}");
                          },
                          onPageChanged: (int index) {
                            controller.changePageIndex(++index);
                          },
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            decoration: new BoxDecoration(
                                color: Colors.pink[200],
                                borderRadius: BorderRadius.circular(20.0)),
                            margin: EdgeInsets.only(top: 40.h, right: 40.w),
                            padding: EdgeInsets.symmetric(
                                vertical: 1, horizontal: 10),
                            child: Text(
                              '${(controller.currentIndex.value)}/5',
                              style: TextStyle(
                                fontSize: 62.sp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(49.w, 53.h, 49.w, 0),
                    height: 182.h,
                    child: Theme(
                      data: new ThemeData(
                          primaryColor: Color.fromRGBO(255, 114, 148, 1.0),
                          fontFamily: 'NotoSansCJKkr_Medium'),
                      child: TextField(
                        onChanged: (txt) {
                          controller.changeTextField(txt);
                        },
                        cursorColor: Color(0xffff7292),
                        style: TextStyle(
                            color: Color(0xffcccccc),
                            fontSize: 60.sp,
                            letterSpacing: -1.0),
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
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
                          contentPadding: EdgeInsets.fromLTRB(76.w, 0, 0, 0),
                          hintText: "장소, 주소, 상호명을 검색해주세요",
                          hintStyle: TextStyle(
                              color: Color(0xffcccccc),
                              fontSize: 60.sp,
                              fontFamily: 'NotoSansCJKkr_Medium',
                              letterSpacing: -1.0),
                          suffixIcon: IconButton(
                              onPressed: controller.textfield.value != ""
                                  ? () {
                                      FocusScope.of(context).unfocus();
                                      Get.to(searchbar());
                                    }
                                  : () {
                                      toast(context, "주소를 입력해주세요!");
                                      FocusScope.of(context).unfocus();
                                    },
                              icon: Image.asset(
                                "./assets/homePage/search.png",
                                width: 88.w,
                                height: 87.h,
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
                            left: 78.w,
                          )),
                          GestureDetector(
                            child: Image.asset(
                              homeimage[0],
                              width: 219.w,
                              height: 211.h,
                            ),
                            onTap: () {
                              currentFocus.unfocus();
                              Get.toNamed("/list", arguments: "restaurant");
                            },
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                            left: 180.w,
                          )),
                          GestureDetector(
                            child: Image.asset(
                              homeimage[1],
                              width: 169.w,
                              height: 255.h,
                            ),
                            onTap: () {
                              currentFocus.unfocus();
                              Get.toNamed("/list",
                                  arguments: "Examination_institution");
                            },
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                            left: 196.w,
                          )),
                          GestureDetector(
                            child: Image.asset(
                              homeimage[2],
                              width: 190.w,
                              height: 264.h,
                            ),
                            onTap: () {
                              currentFocus.unfocus();
                              toast(context, " 서비스 준비 중이에요!  ");
                            },
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                            left: 211.w,
                          )),
                          GestureDetector(
                            child: Image.asset(
                              homeimage[3],
                              width: 163.w,
                              height: 248.h,
                            ),
                            onTap: () {
                              currentFocus.unfocus();
                              toast(context, " 서비스 준비 중이에요!  ");
                            },
                          ),
                        ],
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                        top: 100.h,
                      )),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                              padding: EdgeInsets.only(
                            left: 92.w,
                          )),
                          GestureDetector(
                            child: Image.asset(
                              homeimage[4],
                              width: 192.w,
                              height: 251.h,
                            ),
                            onTap: () {
                              currentFocus.unfocus();
                              Get.toNamed("/list", arguments: "Kids_cafe");
                            },
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                            left: 206.w,
                          )),
                          GestureDetector(
                            child: Image.asset(
                              homeimage[5],
                              width: 151.w,
                              height: 230.h,
                            ),
                            onTap: () {
                              currentFocus.unfocus();
                              Get.toNamed("/list",
                                  arguments: "Experience_center");
                            },
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                            left: 224.w,
                          )),
                          GestureDetector(
                            child: Image.asset(
                              homeimage[6],
                              width: 142.w,
                              height: 239.h,
                            ),
                            onTap: () {
                              currentFocus.unfocus();
                              toast(context, " 서비스 준비 중이에요!  ");
                            },
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                            left: 159.w,
                          )),
                          GestureDetector(
                            child: Image.asset(
                              homeimage[7],
                              width: 294.w,
                              height: 202.h,
                            ),
                            onTap: () {
                              currentFocus.unfocus();
                              toast(context, " 서비스 준비 중이에요!  ");
                            },
                          ),
                        ],
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                        top: 100.h,
                      )),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                              padding: EdgeInsets.only(
                            left: 91.w,
                          )),
                          GestureDetector(
                            child: Image.asset(
                              homeimage[8],
                              width: 189.w,
                              height: 221.h,
                            ),
                            onTap: () {
                              currentFocus.unfocus();
                              toast(context, " 서비스 준비 중이에요!  ");
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                    top: 120.h,
                  )),
                  Container(
                    padding: EdgeInsets.only(
                      left: 100.w,
                      top: 82.h,
                      bottom: 120.h,
                    ),
                    color: Color.fromRGBO(247, 248, 250, 1.0),
                    // height: 650 .h,
                    width: 1500.w,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            "./assets/homePage/logo_grey.png",
                            width: 256.w,
                            height: 63.h,
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                            top: 57.h,
                          )),
                          normalfont(
                              "상호명 : (주)호호컴퍼니\n대표이사 : 김화영     사업자등록번호 : 322-86-01766\n유선번호 : 061-331-3116  팩스 : 061-331-3117\nemail : hohoco0701@gmail.com \n주소 : 전라남도 나주시 빛가람로 740 한빛타워 6층 601호\ncopyrightⓒ 호호컴퍼니 Inc. All Rights Reserved.            \n사업자 정보 확인   |   이용약관   |   개인정보처리방침",
                              45,
                              Color.fromRGBO(151, 151, 151, 1.0)),
                        ]),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
