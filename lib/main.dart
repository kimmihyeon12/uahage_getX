import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:uahage/src/Binding/loginbinding.dart';
import 'package:uahage/src/View/Auth/login.dart';
import 'package:uahage/src/View/Auth/wrapper.dart';
import 'package:uahage/src/View/Loading/loading.dart';
import 'package:uahage/src/View/Nav/navigator.dart';
import 'package:uahage/src/View/Nav/HomeSub/list.dart';
import 'package:uahage/src/View/Auth/register.dart';
import 'package:uahage/src/View/Auth/announce.dart';
import 'package:uahage/src/View/Auth/agreement.dart';
import 'package:uahage/src/Binding/navigatorbinding.dart';
import 'package:uahage/src/View/Nav/home.dart';
import 'package:uahage/src/Binding/homepagebinding.dart';
import 'package:uahage/src/View/Nav/Search.dart';
import 'package:uahage/src/View/Nav/Star.dart';
import 'package:uahage/src/View/Nav/myPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: InitBinding(),
      getPages: [
        GetPage(name: "/", page: () => loading()),
        GetPage(name: "/wrapper", page: () => wrapper()),
        GetPage(name: "/login", page: () => login()),
        GetPage(
            name: "/register", page: () => register(), binding: loginBinding()),
        GetPage(name: "/announce", page: () => announce()),
        GetPage(
            name: "/agreement",
            page: () => agreement(),
            binding: loginBinding()),
        GetPage(
            name: "/navigator",
            page: () => navigation(),
            binding: homebinding()),
        GetPage(name: "/home", page: () => home()),
        GetPage(name: "/search", page: () => search()),
        GetPage(name: "/star", page: () => star()),
        GetPage(name: "/mypage", page: () => mypage()),
        GetPage(name: "/list", page: () => list()),
      ],
    );
  }
}
