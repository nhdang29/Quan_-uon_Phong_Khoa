import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_muon_phong_khoa/firebase/firebasehelper.dart';


import '../contrast.dart';
import '../models/phonghoc.dart';

class ThemPhongLyThuyet extends StatelessWidget {
  const ThemPhongLyThuyet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController soPhongControler = TextEditingController();
    TextEditingController soTangControler = TextEditingController();

    return Column(
      children: [
        TextField(
          controller: soPhongControler,
          decoration: const InputDecoration(
              labelText: "Số phòng"
          ),
        ),
        const SizedBox(height: 10,),
        TextField(
          controller: soTangControler,
          decoration: const InputDecoration(
              labelText: "Số tầng"
          ),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 10,),
        ElevatedButton(
          child: const Text("Thêm phòng",style: TextStyle(color: Colors.white),),
          style: ElevatedButton.styleFrom(
            primary: Colors.blue,
          ),
          onPressed: (){
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            FirebaseHelper().getCollection("phonglythuyet").add({
              "loaiPhong": "LT",
              "soPhong": soPhongControler.text,
              "tang": int.parse(soTangControler.text),
            }).then((value){
              soPhongControler.clear();
              soTangControler.clear();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text(
                    "Thêm phòng thành công!"),
                backgroundColor: Colors.green,
              ));
            });
          },
        ),
        const SizedBox(height: 10,),
        const Divider(
          thickness: 1.0,
        ),
        
        StreamBuilder(
          stream: FirebaseHelper().getCollection("phonglythuyet").orderBy("soPhong").snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
            if(snapshot.hasError) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: Text(snapshot.error.toString()),),
              );
            }
            if(snapshot.connectionState == ConnectionState.waiting) return Container(margin: const EdgeInsets.only(top: 20),child: const Center(child: CircularProgressIndicator()));

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: snapshot.data!.docs.map((DocumentSnapshot document){
                  PhongHoc phong = PhongHoc(soPhong: document['soPhong'], loaiPhong: document['loaiPhong'], tang: document['tang']);
                  return Card(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 3.0),
                    color: Colors.white60,
                    shadowColor: Colors.grey,
                    child: ListTile(
                      leading: phong.loaiPhong == "LT" ? const Icon(Icons.school_outlined) : const Icon(Icons.computer_outlined),
                      title: Text("Số phòng: ${phong.soPhong}"),
                      subtitle: phong.loaiPhong == "LT"? const Text("Loại phòng: Lý thuyết"):const Text("Loại phòng: thực hành"),
                      hoverColor: kHoverColor,
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline_rounded, color: Colors.red,),
                        onPressed: (){

                          showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                            title: Text("Xóa phòng ${document['soPhong']}"),
                            content: const Text("Bạn có chắc chắn muốn xóa?"),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'Cancel'),
                                child: const Text('Hủy'),
                              ),
                              TextButton(
                                onPressed: () {
                                  FirebaseHelper().getCollection("phonglythuyet").doc(document.id).delete()
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
                          ));


                        },
                      ),
                    ),
                  );
                }).toList(),
              ),
            );

          },
        ),
        
      ],
    );
  }
}