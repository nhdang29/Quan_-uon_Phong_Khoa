import 'package:flutter/material.dart';
import 'package:flutter_muon_phong_khoa/contrast.dart';
import 'viewPage/category.dart';
import 'models/user.dart';
import 'viewPage/phongdangmuon.dart';
import 'viewPage/lichsu.dart';
import 'package:firebase_core/firebase_core.dart';
import 'viewPage/login.dart';
import 'viewPage/admin.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CIT Room',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        "login": (context) => const LoginPage(),
        "home": (context) => const MyHomePage(title: 'Mượn phòng khoa CNTT&TT'),
        "admin": (context) => const AdminPage(),
      },
      initialRoute: "login",

    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            title,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.w600),
          ),
          elevation: 3.0,
          backgroundColor: Colors.white,
          flexibleSpace: Image(
            image: AssetImage(kAppbarbg),
            fit: BoxFit.fill,
            //alignment: Alignment.topRight,
          ),
          bottom: const TabBar(
            labelPadding: EdgeInsets.all(8.0),
            tabs: [
              Text(
                "Thực hành",
                style: TextStyle(color: Colors.black),
              ),
              Text(
                "Lý thuyết",
                style: TextStyle(
                  color: Colors.black,
                ),
              )
            ],
          ),
        ),
        endDrawer: Drawer(
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: DrawerHeader(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage(kAppbarbg),
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${currentUser.ten} - ${currentUser.mssv}",
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10,),
                        currentUser.cv != null ? Text(
                          "Chức vụ: ${currentUser.cv}",
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ) : Text("Chức vụ: chưa", style: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w600,
                        ),),
                      ],
                    ),
                  ),
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.history),
                title: const Text("Lịch sử mượn phòng"),
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LichSuMuonPhong())),
              ),
              ListTile(
                leading: const Icon(Icons.room_preferences_outlined),
                title: const Text("Các phòng đang mượn"),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PhongDangMuon()));
                },
              ),
              const Spacer(),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.power_settings_new),
                title: const Text("Đăng xuất"),
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(context, "login", (route) => false);
                },
              ),
            ],
          ),
        ),
        body: const CategoryPage(),
      ),
    );
  }
}
