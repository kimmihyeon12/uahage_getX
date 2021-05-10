import 'package:flutter/material.dart';

icon(context, menu, carriage, bed, tableware, nursingroom, meetingroom, diapers,
    playroom, chair) {
  print(chair);
  return Row(
    children: [
      menu == "1"
          ? Container(
              child: Image.asset("./assets/listPage/menu.png",
                  width: 30, height: 30),
              padding: EdgeInsets.only(
                  right: 20 / (1501 / MediaQuery.of(context).size.width)),
            )
          : Container(
              child: Image.asset("./assets/listPage/menu.png",
                  width: 0, height: 0),
              padding: EdgeInsets.only(
                  right: 0 / (1501 / MediaQuery.of(context).size.width)),
            ),
      bed == "1"
          ? Container(
              child: Image.asset("./assets/listPage/bed.png",
                  width: 30, height: 30),
              padding: EdgeInsets.only(
                  right: 20 / (1501 / MediaQuery.of(context).size.width)),
            )
          : Container(
              child:
                  Image.asset("./assets/listPage/bed.png", width: 0, height: 0),
              padding: EdgeInsets.only(
                  right: 0 / (1501 / MediaQuery.of(context).size.width)),
            ),
      tableware == "1"
          ? Container(
              child: Image.asset("./assets/listPage/tableware.png",
                  width: 30, height: 30),
              padding: EdgeInsets.only(
                  right: 20 / (1501 / MediaQuery.of(context).size.width)),
            )
          : Container(
              child: Image.asset("./assets/listPage/tableware.png",
                  width: 0, height: 0),
              padding: EdgeInsets.only(
                  right: 0 / (1501 / MediaQuery.of(context).size.width)),
            ),
      meetingroom == "1"
          ? Container(
              child: Image.asset("./assets/listPage/meetingroom.png",
                  width: 30, height: 30),
              padding: EdgeInsets.only(
                  right: 20 / (1501 / MediaQuery.of(context).size.width)),
            )
          : Container(
              child: Image.asset("./assets/listPage/meetingroom.png",
                  width: 0, height: 0),
              padding: EdgeInsets.only(
                  right: 0 / (1501 / MediaQuery.of(context).size.width)),
            ),
      diapers == "1"
          ? Container(
              child: Image.asset("./assets/listPage/diapers.png",
                  width: 30, height: 30),
              padding: EdgeInsets.only(
                  right: 20 / (1501 / MediaQuery.of(context).size.width)),
            )
          : Container(
              child: Image.asset("./assets/listPage/diapers.png",
                  width: 0, height: 0),
              padding: EdgeInsets.only(
                  right: 0 / (1501 / MediaQuery.of(context).size.width)),
            ),
      playroom == "1"
          ? Container(
              child: Image.asset("./assets/listPage/playroom.png",
                  width: 30, height: 30),
              padding: EdgeInsets.only(
                  right: 20 / (1501 / MediaQuery.of(context).size.width)),
            )
          : Container(
              child: Image.asset("./assets/listPage/playroom.png",
                  width: 0, height: 0),
              padding: EdgeInsets.only(
                  right: 0 / (1501 / MediaQuery.of(context).size.width)),
            ),
      carriage == "1"
          ? Container(
              child: Image.asset("./assets/listPage/carriage.png",
                  width: 30, height: 30),
              padding: EdgeInsets.only(
                  right: 20 / (1501 / MediaQuery.of(context).size.width)),
            )
          : Container(
              child: Image.asset("./assets/listPage/carriage.png",
                  width: 0, height: 0),
            ),
      nursingroom == "1"
          ? Container(
              child: Image.asset("./assets/listPage/nursingroom.png",
                  width: 30, height: 30),
              padding: EdgeInsets.only(
                  right: 20 / (1501 / MediaQuery.of(context).size.width)),
            )
          : Container(
              child: Image.asset("./assets/listPage/nursingroom.png",
                  width: 0, height: 0),
              padding: EdgeInsets.only(
                  right: 0 / (1501 / MediaQuery.of(context).size.width)),
            ),
      chair == "1"
          ? Container(
              child: Image.asset("./assets/listPage/chair.png",
                  width: 30, height: 30),
              padding: EdgeInsets.only(
                  right: 20 / (1501 / MediaQuery.of(context).size.width)),
            )
          : Container(
              child: Image.asset("./assets/listPage/chair.png",
                  width: 0, height: 0),
              padding: EdgeInsets.only(
                  right: 0 / (1501 / MediaQuery.of(context).size.width)),
            ),
    ],
  );
}
