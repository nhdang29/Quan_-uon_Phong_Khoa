import 'package:flutter/material.dart';
import 'package:flutter_muon_phong_khoa/components/phonglt.dart';
import 'package:flutter_muon_phong_khoa/components/phongth.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {

  @override
  Widget build(BuildContext context) {
    return const TabBarView(
        children: [
          PhongThucHanh(),
          PhongLyThuyet(),
        ],
      );
  }
}
