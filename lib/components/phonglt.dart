import 'package:flutter/material.dart';
import 'package:flutter_muon_phong_khoa/components/phong_card.dart';
import 'package:flutter_muon_phong_khoa/models/phonghoc.dart';
import 'package:flutter_muon_phong_khoa/firebase/firebasehelper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_muon_phong_khoa/contrast.dart';

class PhongLyThuyet extends StatefulWidget {
  const PhongLyThuyet({Key? key}) : super(key: key);

  @override
  State<PhongLyThuyet> createState() => _PhongLyThuyetState();
}

class _PhongLyThuyetState extends State<PhongLyThuyet> {

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: StreamBuilder(
        stream: FirebaseHelper().getCollection(kPhongLyThuyet).orderBy('soPhong', descending: false).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.hasError) return Center(child: Text(snapshot.error.toString()),);

          if(snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator(),);


          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: snapshot.data!.docs.map((DocumentSnapshot document){
                PhongHoc phong = PhongHoc(soPhong: document['soPhong'], loaiPhong: document['loaiPhong'], tang: document['tang']);
                return CardPhong(phongHoc: phong);
              }).toList() ,
            ),
          );
        },
      ),
    );
  }
}
