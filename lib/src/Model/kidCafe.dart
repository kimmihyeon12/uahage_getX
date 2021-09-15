class KidCafe {
  KidCafe({this.id, this.name, this.address, this.phone, this.info});
  int id;
  String name;
  String address;
  String phone;
  var info;

  factory KidCafe.fromJson(Map<String, dynamic> json) => KidCafe(
      id: json["id"],
      name: json["name"],
      address: json["address"],
      phone: json["phone"],
      info: json["info"]);
}
