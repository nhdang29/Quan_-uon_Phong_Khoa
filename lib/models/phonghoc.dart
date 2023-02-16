
class PhongHoc{

  PhongHoc({required this.soPhong, required this.loaiPhong, this.tang, this.soLuongMay});

  late String soPhong;
  late String loaiPhong;
  int? soLuongMay;
  int? tang;

  PhongHoc.fromJson(Map<String, dynamic> json) {
    soPhong = json['soPhong'];
    loaiPhong = json['loaiPhong'];
    tang = json['tang'];
    soLuongMay = json['soLuongMay'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['soPhong'] = soPhong;
    data['loaiPhong'] = loaiPhong;
    data['tang'] = tang;
    data['soLuongMay'] = soLuongMay;
    return data;
  }

  String get getLoaiPhong => loaiPhong;

  String get getSoPhong => soPhong;

  int get getSoLuongMay => soLuongMay!;

}


