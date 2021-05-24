class Hospitals {
  Hospitals({
    this.id,
    this.name,
    this.address,
    this.phone,
    this.examination_items,
  });
  int id;
  String name;
  String address;
  String phone;
  String examination_items;

  factory Hospitals.fromJson(Map<String, dynamic> json) {
    return Hospitals(
        id: json["id"],
        name: json["name"],
        address: json["address"],
        phone: json["phone"],
        examination_items: json["examination_items"]);
  }
}
