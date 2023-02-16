import 'package:flutter/material.dart';
import 'package:flutter_muon_phong_khoa/firebase/firebasehelper.dart';
import 'package:flutter_muon_phong_khoa/contrast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_muon_phong_khoa/models/user.dart';
import 'package:flutter_muon_phong_khoa/function.dart';

class LichSuMuonPhong extends StatelessWidget {
  const LichSuMuonPhong({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Lịch sử mượn",
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
      body: const LichSu(),
    );
  }
}

class LichSu extends StatelessWidget {
  const LichSu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: StreamBuilder(
        stream: FirebaseHelper().getCollection("lichsumuonphong").where('taiKhoan', isEqualTo: currentUser.getMssv).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.hasError) return Center(child: Text(snapshot.error.toString()),);

          if(snapshot.connectionState == ConnectionState.waiting) return Container(margin: const EdgeInsets.only(top: 20),child: const Center(child: CircularProgressIndicator()));

          if(snapshot.hasData && snapshot.data!.docs.isEmpty ) return Container(margin: const EdgeInsets.only(top: 20),child: const Center(child: Text("Bạn chưa có lịch sử đăng kí")));


          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: snapshot.data!.docs.map((DocumentSnapshot document){
                String mota = document['moTa'];

                return Card(
                  child: ListTile(
                    title: Text("${document['phongMuon']}: ${document['loaiPhong']}"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(height: 10,),
                        Text("Tiết: ${formatTietHoc(document['tietHoc'])}"),
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
                            title: Text("Xóa lịch sử phòng ${document['phongMuon']}"),
                            content: const Text("Bạn có chắc chắn muốn xóa?"),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'Cancel'),
                                child: const Text('Hủy'),
                              ),
                              TextButton(
                                onPressed: () {
                                  FirebaseHelper().getCollection("lichsumuonphong").doc(document.id).delete()
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




