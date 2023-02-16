
import 'package:flutter/material.dart';
import 'them_phong_lt.dart';
import 'them_phong_th.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  int currentVal = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text("Chọn loại phòng", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
          const SizedBox(height: 10,),
          RadioListTile(
            activeColor: Colors.blue,
            title: const Text("Thực hành"),
            value: 0,
            groupValue: currentVal,
            onChanged: (int? value) {
              setState(() {
                currentVal = value!;
              });
            },
          ),
          const SizedBox(
            height: 10,
          ),
          RadioListTile(
            activeColor: Colors.blue,
            title: const Text("Lý thuyết"),
            value: 1,
            groupValue: currentVal,
            onChanged: (int? value) {
              setState(() {
                currentVal = value!;
              });
            },
          ),
          const SizedBox(height: 10,),
          currentVal == 0 ? const ThemPhongThucHanh() : const ThemPhongLyThuyet(),
        ],
      ),
    );
  }
}

