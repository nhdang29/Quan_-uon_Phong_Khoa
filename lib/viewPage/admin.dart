import 'package:flutter/material.dart';

import '../models/user.dart';
import 'package:flutter_muon_phong_khoa/admin/admin_home.dart';
import 'package:flutter_muon_phong_khoa/admin/don_dat_phong.dart';
import 'package:flutter_muon_phong_khoa/contrast.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {

  String title = "Quản lý phòng học";
  int currentPage = 0;
  List<Widget> listPageAdmin = [
    const AdminHome(),
    const AdminDatPhong(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(title,style: const TextStyle(
            color: Colors.black, fontWeight: FontWeight.w600),),
        elevation: 3.0,
        backgroundColor: Colors.white,
        // flexibleSpace: Image(
        //   image: AssetImage(kAppbarbg),
        //   fit: BoxFit.fill,
        //   //alignment: Alignment.topRight,
        // ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              color: Colors.blue,
              gradient: linearGradientCustom,
          ),
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: DrawerHeader(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  gradient: linearGradientCustom,
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        currentUser.ten,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      currentUser.cv != null
                          ? Text(
                              "Chức vụ: ${currentUser.cv}",
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          : Text(
                              "Chức vụ: chưa",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
            const Divider(),
            ListTile(
                leading: const Icon(Icons.home),
                title: const Text("Phòng học"),
                selected: currentPage == 0 ? true : false,
                selectedColor: Colors.blue,
                onTap: () {
                  if (currentPage != 0) {
                    setState(() {
                      currentPage = 0;
                      title = "Quản lý phòng học";
                    });
                  }
                }),
            ListTile(
                leading: const Icon(Icons.note_alt),
                title: const Text("Đơn đặt phòng"),
                selected: currentPage == 1 ? true : false,
                selectedColor: Colors.blue,
                onTap: () {
                  if (currentPage != 1) {
                    setState(() {
                      currentPage = 1;
                      title = "Quản lý đơn đặt phòng";
                    });
                  }
                }),
            const Spacer(),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.power_settings_new),
              title: const Text("Đăng xuất"),
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, "login", (route) => false);
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(child: listPageAdmin[currentPage]),
    );
  }
}
