
import 'package:flutter/material.dart';
import 'package:flutter_muon_phong_khoa/contrast.dart';
import 'package:flutter_muon_phong_khoa/models/user.dart';
import 'package:flutter_muon_phong_khoa/models/phonghoc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_muon_phong_khoa/viewPage/phongdangmuon.dart';


class RoomProperty extends StatefulWidget {
  const RoomProperty(
      {Key? key,
      required this.phongHoc})
      : super(key: key);

  final PhongHoc phongHoc;

  @override
  State<RoomProperty> createState() => _RoomPropertyState();
}

class _RoomPropertyState extends State<RoomProperty> {
  DateTime _dateTime = DateTime.now();
  CollectionReference dangkimuonphong =
      FirebaseFirestore.instance.collection('dangkimuonphong');

  List<int> menuItems = [
    0,
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15
  ];
  List<int> menuItemsSV = [
    0,
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
  ];
  List<dynamic> mapMenuItem = [
    "Không",
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    "Sáng",
    "Chiều",
    "Tối",
  ];

  Map<int, dynamic> buoiHoc = {
    0: 0,
    1: [1],
    2: [2],
    3: [3],
    4: [4],
    5: [5],
    6: [6],
    7: [7],
    8: [8],
    9: [9],
    10: [10],
    11: [11],
    12: [12],
    13: [1,2,3,4,5],
    14: [6,7,8,9],
    15: [10,11,12]
  };




  int tietHoc = 0;
  static List tietHocDaDangKi = [];

  TextEditingController desController = TextEditingController();




  SnackBar dkThatBai = const SnackBar(
    content: Text(
        "Bạn không đăng kí được tiết này!"),
    backgroundColor: Colors.red,
  );


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Chi tiết phòng",
          style:
              TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        flexibleSpace: Image(
          image: AssetImage(kAppbarbg),
          fit: BoxFit.fill,
          //alignment: Alignment.topRight,
        ),
        centerTitle: true,
        elevation: 3.0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_left),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Text("Số phòng: ${widget.phongHoc.soPhong}",style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),),
                      const SizedBox(height: 10,),
                      widget.phongHoc.loaiPhong == "LT"
                          ? Text("Loại phòng: lý thuyết, tầng: ${widget.phongHoc.tang}")
                          : Text(
                          "Loại phòng: thực hành, số lượng máy: ${widget.phongHoc.soLuongMay}, tầng: ${widget.phongHoc.tang}"),

                      const SizedBox(height: 10,),

                      Column(
                        children: [
                          Text(
                              "Tên người mượn: ${currentUser.ten}"),
                          const SizedBox(height: 5,),
                          Text("Mã số: ${currentUser.mssv}"),
                        ],
                      ),

                    ],
                  ),
                ),
              ),


              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Card(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("1)  Ngày: ${_dateTime.day}-${_dateTime.month}-${_dateTime.year}", style: const TextStyle(fontWeight: FontWeight.bold),),
                          const SizedBox(width: 8,),
                          ElevatedButton(
                            child: const Text("Chọn ngày", style: TextStyle(color: Colors.white),),
                            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.green)),
                            onPressed: () {
                              showDatePicker(
                                context: context,
                                initialDate: _dateTime,
                                firstDate: DateTime.now(),
                                lastDate: DateTime(_dateTime.year + 2),
                                fieldHintText: "mm/dd/yyyy",
                              ).then((date) {
                                if (date != null) {
                                  setState(() {
                                    _dateTime = date;
                                    tietHoc = 0;
                                  });
                                }
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8,),

                      StreamBuilder(
                        stream: FirebaseFirestore.instance.collection("dangkimuonphong").where("phongMuon", isEqualTo: widget.phongHoc.soPhong).where("ngayMuon", isEqualTo: "${_dateTime.day}/${_dateTime.month}/${_dateTime.year}").snapshots(),
                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                          if(snapshot.connectionState == ConnectionState.waiting) return Container(margin: const EdgeInsets.only(top: 20),child: const Center(child: CircularProgressIndicator()));

                          if(snapshot.hasData && snapshot.data!.docs.isEmpty ) {
                            tietHocDaDangKi.clear();
                            return Container(margin: const EdgeInsets.only(top: 20),child: const Center(child: Text("Chưa có tiết nào được đăng kí")));
                          }


                              tietHocDaDangKi.clear();
                              for(int i = 0; i< snapshot.data!.docs.length; i++){
                                List temp = snapshot.data!.docs[i]['tietHoc'];
                                for (var element in temp) {
                                  tietHocDaDangKi.add(element);
                                }
                              }
                              tietHocDaDangKi.sort();

                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
                                child: Text("Các tiết đã được đăng kí: "+formatTietHoc(tietHocDaDangKi)),
                              );
                        },
                      ),
                      const SizedBox(height: 15,),
                    ],
                  ),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("2)  Buổi/tiết:", style: TextStyle(fontWeight: FontWeight.bold),),
                  const SizedBox(width: 5,),
                  // nut chon tiet hoc, sinh vien chi chon duoc moi lan mot tiet hoc
                  // giang vien co the chon duoc buoi hoc (5 tiet)
                  DropdownButton(
                    items: currentUser.dinhDanh == 1 ?  menuItemsSV.map((int item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Text(mapMenuItem[item].toString()),
                      );
                    }).toList()
                        : menuItems.map((int item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Text(mapMenuItem[item].toString()),
                      );
                    }).toList(),
                    // =============================

                    value: tietHoc,
                    onChanged: (int? newValue) {

                        setState(() {
                          tietHoc = newValue!;
                        });
                    },
                  ),
                ],
              ),

              const SizedBox(height: 20,),

              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Card(
                  child: Column(
                    children: [
                      const SizedBox(height: 5,),
                      const Text("3) Mô tả", style: TextStyle(fontWeight: FontWeight.bold),),
                      const SizedBox(height: 10,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextField(
                          controller: desController,
                          decoration: const InputDecoration(
                            hintText: "Nhập thông tin thêm. VD: Môn v.v",
                            hintStyle: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                            border: InputBorder.none,

                          ),

                        ),
                      )
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20,),


              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    child: const Text("Quay lại", style: TextStyle(color: Colors.white),),
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red)),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8,),
                  ElevatedButton(
                    child: const Text("3) Đăng ký mượn phòng",style: TextStyle(color: Colors.white),),
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.green)),
                    onPressed: () {
                      if(tietHoc != 0 ) {

                        if( tietHocDaDangKi.isNotEmpty ) {
                          if ((tietHoc == 13) && (tietHocDaDangKi.contains(1) ||
                              tietHocDaDangKi.contains(2) ||
                              tietHocDaDangKi.contains(3) ||
                              tietHocDaDangKi.contains(4) ||
                              tietHocDaDangKi.contains(5))) {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(dkThatBai);
                          } else

                          if ((tietHoc == 14) && (tietHocDaDangKi.contains(6) ||
                              tietHocDaDangKi.contains(7) ||
                              tietHocDaDangKi.contains(8) ||
                              tietHocDaDangKi.contains(9))) {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(dkThatBai);
                          } else

                          if ((tietHoc == 15) && (tietHocDaDangKi.contains(10) ||
                              tietHocDaDangKi.contains(11) ||
                              tietHocDaDangKi.contains(12))) {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(dkThatBai);
                          } else

                          if (!tietHocDaDangKi.contains(tietHoc)) {
                            dangkimuonphong.add({
                              "taiKhoan": currentUser.mssv,
                              "phongMuon": widget.phongHoc.soPhong,
                              "loaiPhong": widget.phongHoc.loaiPhong == 'TH' ? "Thực hành" : "Lý thuyết",
                              "ngayMuon": "${_dateTime.day}/${_dateTime.month}/${_dateTime.year}",
                              "tietHoc": buoiHoc[tietHoc],
                              "moTa": desController.text,
                              "timestamp": _dateTime.toString(),
                            }).then((value) {
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  const PhongDangMuon()));
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    "Đăng kí mượn phòng ${widget.phongHoc.soPhong}, ngày ${_dateTime.day}-${_dateTime.month}-${_dateTime.year}\nBuổi/tiết: ${mapMenuItem[tietHoc].toString().toLowerCase()} thành công!"),
                                backgroundColor: Colors.green,
                              ));
                            });
                          } else {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(dkThatBai);
                          }

                        } else{
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          dangkimuonphong.add({
                            "taiKhoan": currentUser.mssv,
                            "phongMuon": widget.phongHoc.soPhong,
                            "loaiPhong": widget.phongHoc.loaiPhong == 'TH' ? "Thực hành" : "Lý thuyết",
                            "ngayMuon": "${_dateTime.day}/${_dateTime.month}/${_dateTime.year}",
                            "tietHoc": buoiHoc[tietHoc],
                            "moTa": desController.text ,
                            "timestamp": _dateTime.toString(),
                          }).then((value) {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  const PhongDangMuon()));
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  "Đăng kí mượn phòng ${widget.phongHoc.soPhong}, ngày ${_dateTime.day}-${_dateTime.month}-${_dateTime.year}\nBuổi/tiết: ${mapMenuItem[tietHoc].toString().toLowerCase()} thành công!"),
                              backgroundColor: Colors.green,
                            ));
                          });

                        }

                      }else{
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text(
                              "Bạn cần phải chọn buổi học!"),
                          backgroundColor: Colors.red,
                        ));
                      }

                    },
                  ),
                ],
              ),

              const SizedBox(height: 20,),



            ],
          ),
        ),
      ),
    );
  }
}

String formatTietHoc(List tietHoc){
  String tietStr = "";
  for(int i = 0; i < tietHoc.length - 1; i++){
    tietStr += "${tietHoc[i]}, ";
  }
  tietStr += tietHoc.last.toString();
  return tietStr;
}

