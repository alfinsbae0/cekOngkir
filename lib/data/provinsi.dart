class Province {
  Province({
    required this.provinceId,
    required this.province,
  });

  String? provinceId;
  String? province;

  factory Province.fromJson(Map<String, dynamic> json) => Province(
        provinceId: json["province_id"],
        province: json["province"],
      );

  Map<String, dynamic> toJson() => {
        "province_id": provinceId,
        "province": province,
      };

  static List<Province> fromJsonList(List list) {
    if (list.length == 0) return List<Province>.empty();
    return list.map((item) => Province.fromJson(item)).toList();
  }
}
