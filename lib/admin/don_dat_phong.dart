
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../firebase/firebasehelper.dart';
import '../function.dart';

class AdminDatPhong extends StatefulWidget {
  const AdminDatPhong({Key? key}) : super(key: key);

  @override
  State<AdminDatPhong> createState() => _AdminDatPhongState();
}

class _AdminDatPhongState extends State<AdminDatPhong> {

  bool giamdan = true;
  String filter = "timestamp";
  int limiter = 5;
  Map<String, String> fil = {
    "timestamp": "Thời gian",
    "phongMuon": "Phòng học"
  };

  @override

  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 3),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("dangkimuonphong").limit(limiter).orderBy(filter, descending: giamdan).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
            if(snapshot.hasError) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: Text(snapshot.error.toString()),),
              );
            }
            if(snapshot.connectionState == ConnectionState.waiting) return Container(margin: const EdgeInsets.only(top: 20),child: const Center(child: CircularProgressIndicator()));

            if(snapshot.hasData && snapshot.data!.docs.isEmpty ) return Container(margin: const EdgeInsets.only(top: 20),child: const Center(child: Text("Chưa có đơn đăng kí")));

            DateTime now = DateTime( DateTime.now().year , DateTime.now().month, DateTime.now().day );

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text("Sắp xếp theo: "),
                      DropdownButton(
                        hint: Text(fil[filter]!),
                        onChanged: (String? newValue){
                          setState(() {
                            filter = newValue!;
                          });
                        },
                        icon: const Icon(Icons.arrow_drop_down),
                        items: const [
                          DropdownMenuItem(child: Text("Thời gian"),value: "timestamp",),
                          DropdownMenuItem(child: Text("Phòng học"), value: "phongMuon",),
                        ],
                      ),
                      IconButton(
                        icon: giamdan ? const FaIcon(FontAwesomeIcons.sortDown) : const FaIcon(FontAwesomeIcons.sortUp),
                        onPressed: (){
                          setState(() {
                            giamdan = !giamdan;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 5,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: snapshot.data!.docs.map((DocumentSnapshot document){
                      DateTime ngaymuon = DateTime.parse(document['timestamp']);

                      if( ngaymuon.isBefore(now) ) {
                        FirebaseHelper().getCollection("dangkimuonphong").doc(document.id).delete();
                        FirebaseHelper().getCollection("lichsumuonphong").add({
                          "taiKhoan": document['taiKhoan'],
                          "phongMuon": document['phongMuon'],
                          "loaiPhong": document['loaiPhong'],
                          "ngayMuon": document['ngayMuon'],
                          "tietHoc": document['tietHoc'],
                          "timestamp": document['timestamp'],
                          "moTa": document['moTa']
                        });
                      }


                      String mota = document['moTa'];


                      return Card(
                        child: ListTile(
                          title: Text("${document['phongMuon']}: ${document['loaiPhong']}",style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(height: 15,),
                              Text("Tiết: ${formatTietHoc(document['tietHoc'])}"),
                              const SizedBox(height: 10,),
                              Row(
                                children: [
                                  const Text("Tài khoản mượn:"),
                                  TextButton(
                                    child: Text("${document['taiKhoan']}", style: const TextStyle(decoration: TextDecoration.underline, color: Colors.blue),),
                                    onPressed: (){
                                      FirebaseHelper().getCollection("users").doc(document['taiKhoan'].toString().toLowerCase()).get()
                                          .then((DocumentSnapshot doc){

                                        showDialog(context: context, builder: (BuildContext context){
                                          return AlertDialog(
                                            title: Text("Mã số: ${doc['taiKhoan'].toString().toUpperCase()}"),
                                            content: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text("Tên: ${doc['ten']}"),
                                                const SizedBox(height: 15,),
                                                Text("Lớp: ${doc['lop']}"),
                                                const SizedBox(height: 15,),
                                                Text("Email: ${doc['email']}"),
                                                const SizedBox(height: 15,),
                                                Text("Chức vụ: ${doc['chucVu']}"),
                                              ],
                                            ),
                                          );
                                        });

                                      });

                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10,),
                              if(mota.isNotEmpty) Text("Thông tin mô tả: $mota"),
                              const SizedBox(height: 10,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(document['ngayMuon'], style: const TextStyle(fontSize: 10, fontStyle: FontStyle.italic),),
                                ],
                              ),
                              const SizedBox(height: 10,),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.delete_forever,
                              color: Colors.red,
                            ),
                            onPressed: (){

                              showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: Text("Xóa phòng ${document['phongMuon']}"),
                                  content: const Text("Bạn có chắc chắn muốn xóa?"),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, 'Cancel'),
                                      child: const Text('Hủy'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        FirebaseHelper().getCollection("dangkimuonphong").doc(document.id).delete()
                                            .then((value) {
                                          Navigator.pop(context, 'OK');
                                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                            content: Text(
                                                "Xóa thành công!"),
                                            backgroundColor: Colors.green,
                                          ));

                                        })
                                            .onError((error, stackTrace) {
                                          Navigator.pop(context, 'Cancel');
                                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                            content: Text(
                                                "Xóa thất bại!"),
                                            backgroundColor: Colors.red,
                                          ));
                                        } );
                                      },
                                      child: const Text('Xóa',style: TextStyle(color: Colors.red),),
                                    ),
                                  ],
                                ),
                              );


                            },
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 5,),
                  if(snapshot.data!.docs.length >= limiter)
                    ElevatedButton(
                    child: const Text("Xem thêm", style: TextStyle(color: Colors.white),),
                    onPressed: (){
                      setState(() {
                        limiter += 10;
                      });
                    },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                      ),
                  ),

                ],
              ),
            );
            },
        ),
      ),
    );
  }
}
