import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:mbg_mobile_app/features/dapur/controllers/dapur_info_controller.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

class DapurInfoMapPreview extends StatelessWidget {
  const DapurInfoMapPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final DapurInfoController dapurInfoController =
        Get.find<DapurInfoController>();

    return Obx(() {
      final dapur = dapurInfoController.dapurInfo.value;

      return Container(
        height: 240,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(MBGSizes.borderRadiusLg),
        ),
        clipBehavior: Clip.antiAlias,
        child: FlutterMap(
          options: MapOptions(
            initialCenter: LatLng(dapur?.latitude ?? 0, dapur?.longitude ?? 0),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://mt1.google.com/vt/lyrs=m&x={x}&y={y}&z={z}',
              userAgentPackageName: 'com.mbg.tracker.app',
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: LatLng(dapur?.latitude ?? 0, dapur?.longitude ?? 0),
                  rotate: true,
                  child: const Icon(
                    Icons.location_pin,
                    size: MBGSizes.iconLg,
                    color: MBGColors.error,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
