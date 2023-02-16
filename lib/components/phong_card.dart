import 'package:flutter/material.dart';
import 'package:flutter_muon_phong_khoa/viewPage/room_property.dart';
import 'package:flutter_muon_phong_khoa/contrast.dart';
import 'package:flutter_muon_phong_khoa/models/phonghoc.dart';

class CardPhong extends StatefulWidget {
  const CardPhong({Key? key, required this.phongHoc}) : super(key: key);

  final PhongHoc phongHoc;

  @override
  State<CardPhong> createState() => _CardPhongState();
}

class _CardPhongState extends State<CardPhong> {

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 3.0),
      color: Colors.white60,
      shadowColor: Colors.grey,
      child: ListTile(
        leading: widget.phongHoc.loaiPhong == "LT" ? const Icon(Icons.school_outlined) : const Icon(Icons.computer_outlined),
        title: Text("Số phòng: ${widget.phongHoc.soPhong}"),
        subtitle: widget.phongHoc.loaiPhong == "LT"? const Text("Loại phòng: Lý thuyết"):const Text("Loại phòng: thực Hành"),
        hoverColor: kHoverColor,
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => RoomProperty(phongHoc: widget.phongHoc)));
        },
      ),
    );
  }
}

