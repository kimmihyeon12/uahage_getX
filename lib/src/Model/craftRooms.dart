class CraftRooms {
  CraftRooms(
      {this.id,
      this.name,
      this.address,
      this.phone,
      this.url,
      this.worked_at,
      this.store_info,
      this.image_path});
  int id;
  String name;
  String address;
  String phone;
  String url;
  String worked_at;
  String store_info;
  List image_path;
  factory CraftRooms.fromJson(Map<String, dynamic> json) => CraftRooms(
      id: json["id"],
      name: json["name"],
      address: json["address"],
      phone: json["phone"],
      url: json["url"],
      worked_at: json["worked_at"],
      store_info: json["store_info"],
      image_path: json["image_path"] as List);
}
