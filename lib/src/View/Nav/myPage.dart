import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uahage/src/Service/users.dart';
import 'package:uahage/src/Static/Widget/progress.dart';
import 'package:uahage/src/Static/Font/font.dart';
import 'package:uahage/src/Service/user.dart';
import 'package:uahage/src/View/Nav/userMotify.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  Users users = new Users();
  bool isIdValid = false;
  Map userdata;

  void userSelect() async {
    var data = await users.select();
    userdata = data;
  }

  var boy_image = [
    './assets/register/boy_grey.png',
    './assets/register/boy_pink.png'
  ];
  var girl_image = [
    './assets/register/girl_grey.png',
    './assets/register/girl_pink.png'
  ];

  @override
  Widget build(BuildContext context) {
    userSelect();
    print(userdata);
    ScreenUtil.init(context, width: 1500, height: 2667);
    return userdata != null
        ? WillPopScope(
            onWillPop: () async => false,
            child: Scaffold(
              backgroundColor: Colors.white,
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    //Center avatar
                    Padding(
                      padding: EdgeInsets.only(top: 150.h),
                    ),
                    Center(
                      child: Stack(
                        children: [
                          SizedBox(
                            height: 439.h,
                            width: 439.w,
                            child: CircleAvatar(
                              backgroundImage:
                                  AssetImage("./assets/myPage/avatar.png"),
                              child: (() {
                                if ('${userdata["image_path"]}' != "") {
                                  return Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              userdata["image_path"]),
                                          fit: BoxFit.cover),
                                    ),
                                  );
                                } else {
                                  return Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: AssetImage(
                                            "./assets/myPage/avatar.png"),
                                      ),
                                    ),
                                  );
                                }
                              }()),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Nickname
                    Container(
                      margin: EdgeInsets.only(top: 31.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            child: userdata["nickname"] == ''
                                ? boldfont("우아하게", 70, Color(0xff3a3939))
                                : boldfont(userdata["nickname"], 70,
                                    Color(0xff3a3939)),
                          ),
                          Container(
                            child: InkWell(
                              onTap: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => UserModify(
                                            userdata: userdata,
                                          )),
                                );

                                if (result == true) {
                                  await userSelect();
                                  setState(() {});
                                }
                              },
                              child: Image.asset(
                                "./assets/myPage/button1_pink.png",
                                width: 361.w,
                                height: 147.h,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),

                    //Gender
                    Container(
                      margin: EdgeInsets.fromLTRB(99.w, 35.h, 0, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 아이성별
                          normalfont(
                              "아이성별", 58, Color.fromARGB(255, 255, 114, 148)),

                          Container(
                            margin: EdgeInsets.fromLTRB(99.w, 0.h, 0, 0),
                            height: 362.h,
                            width: 262.w,
                            child: InkWell(
                              child: Image.asset(userdata['baby_gender'] != "F"
                                  ? girl_image[0]
                                  : girl_image[1]),
                            ),
                          ),
                          Container(
                            height: 362.h,
                            width: 262.w,
                            margin: EdgeInsets.only(left: 98.w),
                            child: InkWell(
                              child: Image.asset(userdata['baby_gender'] != "M"
                                  ? boy_image[0]
                                  : boy_image[1]),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Birthday
                    Container(
                      margin: EdgeInsets.fromLTRB(99.w, 5.h, 0, 0),
                      child: Row(
                        children: [
                          // 아이생일
                          normalfont(
                              "아이생일", 58, Color.fromARGB(255, 255, 114, 148)),
                          Expanded(
                            flex: 1,
                            child: Container(
                              margin: EdgeInsets.fromLTRB(82.w, 0, 121.w, 0),
                              child: Stack(
                                children: [
                                  AbsorbPointer(
                                    child: TextFormField(
                                      readOnly: true,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Color(0xffff7292),
                                          fontSize: 57.sp,
                                          fontFamily: 'NotoSansCJKkr_Medium',
                                          fontStyle: FontStyle.normal,
                                          letterSpacing: -1.0),
                                      decoration: InputDecoration(
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: const Color(0xffff7292),
                                          ),
                                          //Color.fromRGBO(255, 114, 148, 1.0)
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xffff7292)),
                                        ),
                                        hintText:
                                            userdata["baby_birthday"] == ''
                                                ? "생년월일을 선택해주세요"
                                                : userdata["baby_birthday"],
                                        hintStyle: TextStyle(
                                            color:
                                                userdata["baby_birthday"] == ''
                                                    ? Color(0xffd4d4d4)
                                                    : Color(0xffff7292),
                                            fontFamily: "NotoSansCJKkr_Medium",
                                            fontSize: 57.0.sp),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Ages
                    Container(
                      margin: EdgeInsets.fromLTRB(155.w, 91.h, 0, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 보호자 연령대
                          normalfont("보호자\n연령대", 58,
                              Color.fromARGB(255, 255, 114, 148)),

                          Container(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 59.w),
                                      child: Image.asset(
                                        userdata["age_group_type"] == 1
                                            ? './assets/register/10_pink.png'
                                            : './assets/register/10_grey.png',
                                        height: 194.h,
                                        width: 249.w,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 55.w),
                                      child: Image.asset(
                                        userdata["age_group_type"] == 2
                                            ? './assets/register/20_pink.png'
                                            : './assets/register/20_grey.png',
                                        height: 194.h,
                                        width: 249.w,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 55.w),
                                      child: Image.asset(
                                        userdata["age_group_type"] == 3
                                            ? './assets/register/30_pink.png'
                                            : './assets/register/30_grey.png',
                                        height: 194.h,
                                        width: 249.w,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 59.w, top: 45.h),
                                      child: Image.asset(
                                        userdata["age_group_type"] == 4
                                            ? './assets/register/40_pink.png'
                                            : './assets/register/40_grey.png',
                                        height: 194.h,
                                        width: 249.w,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 55.w, top: 45.h),
                                      child: Image.asset(
                                        userdata["age_group_type"] == 5
                                            ? './assets/register/50_pink.png'
                                            : './assets/register/50_grey.png',
                                        height: 194.h,
                                        width: 249.w,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 55.w, top: 45.h),
                                      child: Image.asset(
                                        userdata["age_group_type"] == 6
                                            ? './assets/register/others_pink.png'
                                            : './assets/register/others_grey.png',
                                        height: 194.h,
                                        width: 249.w,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Ok Button

                    //logout
                    Container(
                      margin: EdgeInsets.fromLTRB(931.w, 370.h, 0, 71.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                  ),
                                  title: // 로그아웃 하시겠습니까?
                                      normalfont(
                                          "로그아웃 하시겠습니까?", 58, Colors.black),
                                  actions: [
                                    FlatButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: normalfont(
                                          "아니요", 55, Color(0xffff7292)),
                                    ),
                                    FlatButton(
                                      onPressed: () async {
                                        SharedPreferences prefs =
                                            await SharedPreferences
                                                .getInstance();
                                        await prefs.clear();
                                        Navigator.pop(context);
                                        Get.offAllNamed('/login');
                                      },
                                      child: normalfont(
                                          "네", 55, Color(0xffff7292)),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: // 로그아웃
                                normalfont("로그아웃", 52, Color(0xffb1b1b1)),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 15.w, right: 15.w),
                            child: normalfont("|", 52, Color(0xffb1b1b1)),
                          ),
                          InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                  ),
                                  title: normalfont(
                                      "탈퇴하시겠습니까? 탈퇴 시 기존 데이터를 복구할 수 없습니다.",
                                      55,
                                      Color(0xff4d4d4d)),
                                  actions: [
                                    FlatButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: normalfont(
                                          "아니요", 55, Color(0xffff7292)),
                                    ),
                                    FlatButton(
                                      onPressed: () async {
                                        Navigator.pop(context);
                                        SharedPreferences prefs =
                                            await SharedPreferences
                                                .getInstance();

                                        //delete data in the database
                                        showDialog(
                                          context: context,
                                          builder: (_) => FutureBuilder(
                                            future: users.delete(),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                WidgetsBinding.instance
                                                    .addPostFrameCallback(
                                                        (_) async {
                                                  await prefs.clear();
                                                  Get.offNamed("/withdrawal");
                                                });
                                              } else if (snapshot.hasError) {
                                                return AlertDialog(
                                                  title:
                                                      Text("${snapshot.error}"),
                                                );
                                              }
                                              return Center(
                                                child: SizedBox(
                                                  height: 200.h,
                                                  width: 200.w,
                                                  child: progress(),
                                                ),
                                              );
                                            },
                                          ),
                                        );
                                      },
                                      child: // 네
                                          normalfont(
                                              "예", 55, Color(0xffff7292)),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: normalfont("회원탈퇴", 55, Color(0xffb1b1b1)),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        : Container();
  }
}
