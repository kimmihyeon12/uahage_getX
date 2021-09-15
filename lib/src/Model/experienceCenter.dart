class Experiencecenter {
  Experiencecenter({this.id, this.name, this.address, this.phone, this.info});
  int id;
  String name;
  String address;
  String phone;
  var info;

  factory Experiencecenter.fromJson(Map<String, dynamic> json) =>
      Experiencecenter(
          id: json["id"],
          name: json["name"],
          address: json["address"],
          phone: json["phone"],
          info: json["info"]);
}
