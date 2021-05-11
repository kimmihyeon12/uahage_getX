import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:uahage/src/Binding/bookmarkbinding.dart';

import 'package:uahage/src/Binding/placebinding.dart';
import 'package:uahage/src/Binding/user.binding.dart';
import 'package:uahage/src/View/Auth/login.dart';
import 'package:uahage/src/View/Loading/loading.dart';
import 'package:uahage/src/View/Nav/navigator.dart';
import 'package:uahage/src/View/Nav/HomeSub/list.dart';
import 'package:uahage/src/View/Nav/HomeSub/listsub.dart';
import 'package:uahage/src/View/Auth/register.dart';
import 'package:uahage/src/View/Auth/announce.dart';
import 'package:uahage/src/View/Auth/agreement.dart';
import 'package:uahage/src/View/Nav/home.dart';
import 'package:uahage/src/Binding/locationbinding.dart';
import 'package:uahage/src/View/Nav/search.dart';
import 'package:uahage/src/View/Nav/myPage.dart';
import 'package:uahage/src/View/Auth/withdrawal.dart';
import 'package:uahage/src/View/Nav/userMotify.dart';
import 'src/View/Nav/Star.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      //    initialBinding: NavigationBiding(),
      getPages: [
        GetPage(
            name: "/",
            page: () => Loading(),
            bindings: [LocationBinding(), UserBinding()]),
        GetPage(name: "/login", page: () => Login(), binding: UserBinding()),
        GetPage(
            name: "/agreement",
            page: () => Agreement(),
            binding: UserBinding()),
        GetPage(name: "/announce", page: () => Announce()),
        GetPage(
            name: "/register", page: () => Register(), binding: UserBinding()),

        GetPage(
          name: "/withdrawal",
          page: () => Withdrawal(),
        ),

        //NAV
        GetPage(
            name: "/navigator",
            page: () => Navigation(),
            bindings: [UserBinding(), LocationBinding(), BookmarkBinding()]),
        GetPage(name: "/home", page: () => Home(), bindings: [
          PlaceBinding(),
        ]),
        GetPage(name: "/list", page: () => PlaceList(), bindings: [
          PlaceBinding(),
        ]),
        GetPage(name: "/listsub", page: () => ListSub(), bindings: []),
        GetPage(
          name: "/search",
          page: () => Search(),
        ),
        GetPage(name: "/star", page: () => Star()),
        GetPage(name: "/mypage", page: () => MyPage()),
        GetPage(
            name: "/userModify",
            page: () => UserModify(),
            binding: UserBinding()),
      ],
    );
  }
}
