class Experiencecenter {
  Experiencecenter(
      {this.id, this.name, this.address, this.phone, this.admission_fee});
  int id;
  String name;
  String address;
  String phone;
  String admission_fee;

  factory Experiencecenter.fromJson(Map<String, dynamic> json) =>
      Experiencecenter(
          id: json["id"],
          name: json["name"],
          address: json["address"],
          phone: json["phone"],
          admission_fee: json["admission_fee"]);
}
