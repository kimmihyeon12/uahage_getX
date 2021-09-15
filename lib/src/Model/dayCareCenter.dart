class DayCareCenter {
  DayCareCenter({this.id, this.name, this.address, this.phone, this.info});
  int id;
  String name;
  String address;
  String phone;
  var info;

  factory DayCareCenter.fromJson(Map<String, dynamic> json) => DayCareCenter(
      id: json["id"],
      name: json["name"],
      address: json["address"],
      phone: json["phone"],
      info: json["info"]);
}
