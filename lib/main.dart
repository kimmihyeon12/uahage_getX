import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:uahage/src/Binding/loginbinding.dart';
import 'package:uahage/src/Binding/urlbinding.dart';
import 'package:uahage/src/View/Auth/login.dart';
import 'package:uahage/src/View/Loading/loading.dart';
import 'package:uahage/src/View/Nav/navigator.dart';
import 'package:uahage/src/View/Nav/HomeSub/list.dart';
import 'package:uahage/src/View/Auth/register.dart';
import 'package:uahage/src/View/Auth/announce.dart';
import 'package:uahage/src/View/Auth/agreement.dart';
import 'package:uahage/src/Binding/navigatorbinding.dart';
import 'package:uahage/src/View/Nav/home.dart';
import 'package:uahage/src/Binding/imagebinding.dart';
import 'package:uahage/src/Binding/locationbinding.dart';
import 'package:uahage/src/View/Nav/search.dart';
import 'package:uahage/src/View/Nav/myPage.dart';
import 'package:uahage/src/View/Auth/withdrawal.dart';
import 'src/Binding/loginbinding.dart';
import 'src/View/Nav/Star.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: NavigationBiding(),
      getPages: [
        GetPage(
            name: "/",
            page: () => loading(),
            bindings: [LocationBinding(), LoginBinding()]),
        GetPage(name: "/login", page: () => login()),
        GetPage(
            name: "/register", page: () => register(), binding: LoginBinding()),
        GetPage(name: "/announce", page: () => announce()),
        GetPage(
            name: "/agreement",
            page: () => agreement(),
            binding: LoginBinding()),

        /* GetPage(
            name: "/userMotify",
            page: () => UserMotify(),
            binding: homebinding()),*/
        GetPage(
          name: "/withdrawal",
          page: () => withdrawal(),
        ),

        //NAV
        GetPage(
            name: "/navigator",
            page: () => navigation(),
            bindings: [LoginBinding(), ImageBinding()]),
        GetPage(name: "/home", page: () => Home()),
        GetPage(
          name: "/search",
          page: () => Search(),
        ),
        GetPage(name: "/star", page: () => Star()),
        GetPage(name: "/mypage", page: () => MyPage()),
        GetPage(name: "/list", page: () => list()),
      ],
    );
  }
}
