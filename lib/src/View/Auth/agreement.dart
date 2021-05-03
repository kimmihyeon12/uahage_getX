import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:uahage/src/API/auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uahage/src/Static/Widget/dialog.dart';
import 'package:uahage/src/Controller/login.controller.dart';
import 'package:get/get.dart';
import 'package:uahage/src/Static/Widget/appbar.dart';
import 'package:uahage/src/Static/Font/font.dart';

class agreement extends GetView<loginCotroller> {
  auth auths = new auth();

  initKakaoTalkInstalled() async {
    final installed = await isKakaoTalkInstalled();
    controller.installedstate(installed);
  }

  kakaoGetEmail() async {
    final User user = await UserApi.instance.me();
    controller.setEmail(user.kakaoAccount.email);
  }

  issueAccessToken(String authCode) async {
    try {
      var token = await AuthApi.instance.issueAccessToken(authCode);
      AccessTokenStore.instance.toStore(token);
      await kakaoGetEmail();
      var isAlreadyRegistered = await auths.checkEmail(
          controller.emails.value, controller.loginOption.value);

      if (!isAlreadyRegistered) {
        var data = await auths.signIn(
            controller.emails.value, controller.loginOption.value);
        controller.userId(data["userId"]);
        controller.tokens(data["token"]);
        Get.toNamed("/navigator");
      } else {
        Get.toNamed("/register");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  loginWithKakao() async {
    try {
      var code = await AuthCodeClient.instance.request();
      await issueAccessToken(code);
    } catch (e) {
      print(e.toString());
    }
  }

  loginWithTalk() async {
    try {
      var code = await AuthCodeClient.instance.requestWithTalk();
      await issueAccessToken(code);
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    Get.put(loginCotroller());

    initKakaoTalkInstalled();
    KakaoContext.clientId = "581f27a7aed8a99e5b0a78b33c855dab";
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Color(0xffd9d4d5), // navigation bar color
      statusBarColor: Color(0xffd9d4d5), // status bar color
    ));

    ScreenUtil.init(context, width: 1501, height: 2667);
    return SafeArea(
      child: Scaffold(
        appBar: imageAppbar(context, "약관동의"),
        body: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(),

              Container(
                  margin: EdgeInsets.only(top: 441.h),
                  child: boldfont("서비스 약관에 동의해주세요.", 78, Color(0xffff7292))),

              // Agreement
              Container(
                margin: EdgeInsets.only(top: 156.h),
                width: 1296.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14.0),
                  border: Border.all(width: 0.1),
                ),
                child: // 모두 동의합니다.
                    Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 91.h,
                          margin: EdgeInsets.only(
                              left: 37.w, top: 65.h, bottom: 65.h),
                          child: InkWell(
                            onTap: () {
                              print(controller.check[0]);
                              if (controller.check[0] == false) {
                                controller.setChecked(0, true);
                              } else {
                                controller.setChecked(0, false);
                              }
                            },
                            child: controller.check[0] == true
                                ? Image.asset(
                                    "./assets/agreementPage/checked.png")
                                : Image.asset(
                                    "./assets/agreementPage/unchecked.png"),
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.only(
                              left: 30.w,
                            ),
                            child:
                                boldfont("모두 동의합니다.", 62.5, Color(0xff000000))),
                      ],
                    ),
                    Divider(
                        thickness: 0.1, height: 0, color: Color(0xff000000)),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 91.h,
                          margin: EdgeInsets.only(
                              left: 37.w, top: 65.h, bottom: 65.h),
                          child: InkWell(
                              onTap: () {
                                controller.setChecked(1, !controller.check[1]);
                              },
                              child: controller.check[1] == true
                                  ? Image.asset(
                                      "./assets/agreementPage/checked.png")
                                  : Image.asset(
                                      "./assets/agreementPage/unchecked.png")),
                        ),
                        Container(
                          width: 1100.w,
                          margin: EdgeInsets.only(left: 34.w, right: 0),
                          child: InkWell(
                            onTap: () async {
                              final result = await Get.toNamed("/announce");
                              print(result);
                              if (result == "check")
                                controller.setChecked(1, true);
                            },
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceAround,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                normalfont(
                                    "[필수] 이용약관 동의", 62.5, Color(0xff666666)),
                                Container(
                                  height: 74.h,
                                  margin: EdgeInsets.only(right: 20.w),
                                  child: Image.asset(
                                      "./assets/agreementPage/next.png"),
                                ),
                              ],
                            ),
                          ), // [필수] 이용약관 동의
                        ),
                      ],
                    ),
                    Divider(
                        thickness: 0.1, height: 0, color: Color(0xff000000)),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 91.h,
                          margin: EdgeInsets.only(
                              left: 37.w, top: 65.h, bottom: 65.h),
                          child: InkWell(
                              onTap: () {
                                controller.setChecked(2, !controller.check[2]);
                              },
                              child: controller.check[2] == true
                                  ? Image.asset(
                                      "./assets/agreementPage/checked.png")
                                  : Image.asset(
                                      "./assets/agreementPage/unchecked.png")),
                        ),
                        Container(
                          width: 1100.w,
                          margin: EdgeInsets.only(left: 34.w, right: 0),
                          child: InkWell(
                            onTap: () async {
                              final result = await Get.toNamed(
                                "/announce",
                              );

                              if (result == "check")
                                controller.setChecked(2, true);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                normalfont("[필수] 개인정보처리방침 동의", 62.5,
                                    Color(0xff666666)),
                                Container(
                                  height: 74.h,
                                  margin: EdgeInsets.only(right: 20.w),
                                  child: Image.asset(
                                      "./assets/agreementPage/next.png"),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(
                        thickness: 0.1, height: 0, color: Color(0xff000000)),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 91.h,
                          margin: EdgeInsets.only(
                              left: 37.w, top: 65.h, bottom: 65.h),
                          child: InkWell(
                              onTap: () {
                                controller.setChecked(3, !controller.check[3]);
                              },
                              child: controller.check[3] == true
                                  ? Image.asset(
                                      "./assets/agreementPage/checked.png")
                                  : Image.asset(
                                      "./assets/agreementPage/unchecked.png")),
                        ),
                        Container(
                          width: 1100.w,
                          margin: EdgeInsets.only(
                            left: 34.w,
                          ),
                          child: InkWell(
                            onTap: () async {
                              final result = await Get.toNamed("/announce");

                              if (result == "check")
                                controller.setChecked(3, true);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 1000.w,
                                  height: 100.h,
                                  child: normalfont("[필수] 위치기반서비스 이용약관 동의",
                                      62.5, Color(0xff666666)),
                                ),
                                Container(
                                  height: 74.h,
                                  margin: EdgeInsets.only(right: 20.w),
                                  child: Image.asset(
                                      "./assets/agreementPage/next.png"),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Container(
                margin: EdgeInsets.only(top: 243.h),
                child: SizedBox(
                  height: 194.h,
                  width: 1193.w,
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    color: controller.check[0] == true
                        ? const Color(0xffff7292)
                        : Color(0xffcacaca),
                    onPressed: () {
                      if (controller.check[0] == false) {
                        dialog(context, "이용약관에 동의하셔야 합니다.");
                      } else {
                        switch (controller.loginOption.value) {
                          case "kakao":
                            if (controller.installed.value)
                              awaitdialog(loginWithTalk(), context, 200.h,
                                  200.w, 80.w, 100.w, 62.5.sp);
                            else {
                              awaitdialog(loginWithKakao(), context, 200.h,
                                  200.w, 80.w, 100.w, 62.5.sp);
                            }
                            break;
                          /*       case "naver":
                          buildShowDialogOnOk(naverLogin(), context, 200.h,
                              200.w, 80.w, 100.w, 62.5.sp);
                          break;*/

                          default:
                            break;
                        }
                      }
                    },
                    child: normalfont("OK", 62.5, Color(0xffffffff)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
