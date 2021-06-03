import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'package:uahage/src/Binding/place.binding.dart';
import 'package:uahage/src/Binding/user.binding.dart';
import 'package:uahage/src/Controller/connection.controller.dart';
import 'package:uahage/src/Controller/location.controller.dart';
import 'package:uahage/src/Controller/place.restaurant.bookmark.controller.dart';
import 'package:uahage/src/Controller/user.controller.dart';
import 'package:uahage/src/View/Auth/login.dart';
import 'package:uahage/src/View/Loading/loading.dart';
import 'package:uahage/src/View/Nav/HomeSub/searchBar.dart';
import 'package:uahage/src/View/Nav/navigator.dart';
import 'package:uahage/src/View/Nav/HomeSub/list.dart';
import 'package:uahage/src/View/Nav/HomeSub/listsub.dart';
import 'package:uahage/src/View/Auth/register.dart';
import 'package:uahage/src/View/Auth/announce.dart';
import 'package:uahage/src/View/Auth/agreement.dart';
import 'package:uahage/src/View/Nav/home.dart';
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
      debugShowCheckedModeBanner: false,
      initialBinding: BindingsBuilder(() => {
            Get.put(UserController()),
            Get.put(LocationController()),
            Get.put(BookmarkController()),
            Get.put(ConnectionController()),
          }),
      getPages: [
        GetPage(
          name: "/",
          page: () => Loading(),
        ),
        GetPage(name: "/login", page: () => Login()),
        GetPage(name: "/agreement", page: () => Agreement()),
        GetPage(name: "/announce", page: () => Announce()),
        GetPage(name: "/register", page: () => Register()),

        GetPage(
          name: "/withdrawal",
          page: () => Withdrawal(),
        ),

        //NAV
        GetPage(
          name: "/navigator",
          page: () => Navigation(),
        ),
        GetPage(name: "/home", page: () => Home(), bindings: [
          PlaceBinding(),
        ]),
        GetPage(name: "/list", page: () => PlaceList(), bindings: [
          PlaceBinding(),
        ]),
        GetPage(name: "/listsub", page: () => ListSub(), bindings: [
          PlaceBinding(),
        ]),
        GetPage(name: "/searchbar", page: () => SearchBar(), bindings: [
          PlaceBinding(),
        ]),
        GetPage(
          name: "/search",
          page: () => Search(),
        ),
        GetPage(name: "/star", page: () => Star()),
        GetPage(name: "/mypage", page: () => MyPage()),
        GetPage(
          name: "/userModify",
          page: () => UserModify(),
        ),
      ],
    );
  }
}
