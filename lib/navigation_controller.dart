import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur.dart';
import 'package:mbg_mobile_app/features/driver/screens/driver.dart';
import 'package:mbg_mobile_app/features/sekolah/screens/sekolah.dart';

class NavigationController extends GetxController {
  RxInt selectedIndex = 0.obs;
  late final List<Widget> menus;

  NavigationController() {
    menus = <Widget>[
      const DapurScreen(),
      const DriverScreen(),
      const SekolahScreen(),
    ];
  }
}
