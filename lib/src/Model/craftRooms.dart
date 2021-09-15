class CraftRooms {
  CraftRooms(
      {this.id, this.name, this.address, this.phone, this.info, this.images});
  int id;
  String name;
  String address;
  String phone;
  var info;
  var images;
  factory CraftRooms.fromJson(Map<String, dynamic> json) => CraftRooms(
      id: json["id"],
      name: json["name"],
      address: json["address"],
      phone: json["phone"],
      info: json["info"],
      images: json["images"]);
}
