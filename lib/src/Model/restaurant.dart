class Restaurant {
  Restaurant(
      {this.id,
      this.name,
      this.address,
      this.phone,
      this.baby_bed,
      this.baby_menu,
      this.baby_chair,
      this.diaper_change,
      this.stroller,
      this.play_room,
      this.baby_tableware,
      this.meeting_room,
      this.nursing_room,
      this.bookmark,
      this.parking});

  int id;
  String name;
  String address;
  String phone;
  bool baby_menu;
  bool stroller;
  bool baby_bed;
  bool baby_tableware;
  bool nursing_room;
  bool meeting_room;
  bool diaper_change;
  bool play_room;
  bool baby_chair;
  bool parking;
  int bookmark;

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
        id: json["id"],
        name: json["name"],
        address: json["address"],
        phone: json["phone"],
        baby_menu: json["baby_menu"],
        baby_bed: json["baby_bed"],
        baby_tableware: json["baby_tableware"],
        meeting_room: json["meeting_room"],
        diaper_change: json["diaper_change"],
        play_room: json["play_room"],
        stroller: json["stroller"],
        nursing_room: json["nursing_room"],
        baby_chair: json["baby_chair"],
        parking: json["parking"],
        bookmark: json["bookmark"]);
  }
}
