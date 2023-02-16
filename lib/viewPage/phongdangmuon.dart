import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_muon_phong_khoa/contrast.dart';
import 'package:flutter_muon_phong_khoa/firebase/firebasehelper.dart';

import '../models/user.dart';

class PhongDangMuon extends StatelessWidget {
  const PhongDangMuon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Phòng đang mượn",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_left),
          onPressed:() => Navigator.pop(context),
        ),
        elevation: 3.0,
        backgroundColor: Colors.white,
        flexibleSpace: Image(
          image: AssetImage(kAppbarbg),
          fit: BoxFit.fill,
          //alignment: Alignment.topRight,
        ),
      ),
      body: const DangMuon(),
    );
  }
}

class DangMuon extends StatelessWidget {
  const DangMuon({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: StreamBuilder(
        stream: FirebaseHelper().getCollection("dangkimuonphong").where('taiKhoan', isEqualTo: currentUser.mssv).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.hasError) {
            return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: Text(snapshot.error.toString()),),
          );
          }

          if(snapshot.connectionState == ConnectionState.waiting) return Container(margin: const EdgeInsets.only(top: 20),child: const Center(child: CircularProgressIndicator()));

          if(snapshot.hasData && snapshot.data!.docs.isEmpty ) return Container(margin: const EdgeInsets.only(top: 20),child: const Center(child: Text("Bạn chưa có lịch sử đăng kí")));


          DateTime now = DateTime( DateTime.now().year , DateTime.now().month, DateTime.now().day );

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
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

                List tietHoc = document['tietHoc'] as List;
                String mota = document['moTa'];
                return Card(
                  child: ListTile(
                    title: Text("${document['phongMuon']}: ${document['loaiPhong']}"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(height: 10,),
                        Text("Tiết: ${formatTietHoc(tietHoc)}"),
                        const SizedBox(height: 10,),
                        if(mota.isNotEmpty)  Text("Thông tin mô tả: ${document['moTa']}"),
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
                            title: Text("Xóa đăng kí phòng ${document['phongMuon']}"),
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
          );
        },
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