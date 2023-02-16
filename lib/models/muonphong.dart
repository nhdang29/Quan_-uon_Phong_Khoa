import 'package:flutter_muon_phong_khoa/models/phonghoc.dart';
import 'package:flutter_muon_phong_khoa/models/user.dart';

class MuonPhong {
  late User nguoiMuon;
  late PhongHoc phongMuon;
  late int tietHoc;
  late String ngayMuon;

  MuonPhong({required this.nguoiMuon, required this.phongMuon, required this.tietHoc, required this.ngayMuon});

  MuonPhong.fromJson(Map<String, dynamic> json) {
    nguoiMuon = User.fromJson(json['nguoiMuon']);
    phongMuon =  PhongHoc.fromJson(json['PhongHoc']);
    tietHoc = json['tietHoc'];
    ngayMuon = json['ngayMuon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nguoiMuon'] = nguoiMuon;
    data['PhongHoc'] = phongMuon.toJson();
    data['tietHoc'] = tietHoc;
    data['ngayMuon'] = ngayMuon;
    return data;
  }
}