import 'package:get/get.dart';
import 'package:uahage/src/Controller/login.controller.dart';
import 'package:flutter/material.dart';
import 'package:uahage/src/API/auth.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:uahage/src/API/user.dart';

class SnsLogin extends GetView<loginCotroller> {
  Auth auth = new Auth();
  user users = new user();

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
      var isAlreadyRegistered = await users.checkEmail();

      if (!isAlreadyRegistered) {
        var data = await auth.signIn(
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
    KakaoContext.clientId = "581f27a7aed8a99e5b0a78b33c855dab";
    return Container();
  }
}
