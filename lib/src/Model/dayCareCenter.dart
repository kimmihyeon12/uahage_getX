class DayCareCenter {
  DayCareCenter({this.id, this.name, this.address, this.phone, this.use_bus});
  int id;
  String name;
  String address;
  String phone;
  bool use_bus;

  factory DayCareCenter.fromJson(Map<String, dynamic> json) => DayCareCenter(
      id: json["id"],
      name: json["name"],
      address: json["address"],
      phone: json["phone"],
      use_bus: json["use_bus"]);
}
