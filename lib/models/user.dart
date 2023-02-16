class User {
  late String mssv;
  late String matKhau;
  late String ten;
  late String lop;
  late String? email;
  late String? cv;
  late int? dinhDanh;

  User({required this.mssv,required this.matKhau,required this.ten, required this.lop, this.email, this.cv, this.dinhDanh});

  User.fromJson(Map<String, dynamic> json) {
    mssv = json['mssv'];
    matKhau = json['matKhau'];
    ten = json['ten'];
    lop = json['lop'];
    email = json['email'];
    cv ?? json['cv'];
    dinhDanh ?? json['dinhDanh'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mssv'] = mssv;
    data['matKhau'] = matKhau;
    data['ten'] = ten;
    data['lop'] = lop;
    data['email'] = email;
    data['cv'] = cv!;
    data['dinhDanh']= dinhDanh!;
    return data;
  }

  String get getMssv => mssv;
  String get getTen => ten;
  void setTen(String nn){
    ten = nn ;
  }
}
late User currentUser;
// User currentUser = User(mssv: "B1910362", matKhau: "000", ten: "Nguyễn Hải Đăng", lop: "DI19V7A4", cv: "Sinh viên");
//User currentUser = User(mssv: "C12345", matKhau: "000", ten: "Nguyễn Văn A", lop: "Khoa CNTT&TT");