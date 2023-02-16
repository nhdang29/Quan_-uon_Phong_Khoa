
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_muon_phong_khoa/models/phonghoc.dart';
import 'package:flutter_muon_phong_khoa/firebase/firebasehelper.dart';
import 'package:flutter_muon_phong_khoa/components/phong_card.dart';
import 'package:flutter_muon_phong_khoa/contrast.dart';

class PhongThucHanh extends StatefulWidget {
  const PhongThucHanh({Key? key}) : super(key: key);


  @override
  State<PhongThucHanh> createState() => _PhongThucHanhState();
}

class _PhongThucHanhState extends State<PhongThucHanh> {

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: StreamBuilder(
        stream: FirebaseHelper().getCollection(kPhongThucHanh).orderBy('soPhong', descending: false).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.hasError) return Center(child: Text(snapshot.error.toString()),);

          if(snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator(semanticsLabel: "Waiting...",),);


          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: snapshot.data!.docs.map((DocumentSnapshot document){
                PhongHoc phong = PhongHoc(soPhong: document['soPhong'], loaiPhong: document['loaiPhong'], tang: document['tang'], soLuongMay: document['soLuongMay']);
                return CardPhong(phongHoc: phong);
              }).toList() ,
            ),
          );
        },
      ),
    );
  }
}
