import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:mbg_mobile_app/features/dapur/controllers/dapur_info_controller.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
import 'package:mbg_mobile_app/utils/helpers/helper_functions.dart';

class DapurInfoMapPreview extends StatelessWidget {
  const DapurInfoMapPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final DapurInfoController dapurInfoController =
        Get.find<DapurInfoController>();

    return Obx(() {
      final dapur = dapurInfoController.dapurInfo.value;
      final bool isDarkMode = MBGHelperFunctions.isDarkMode(context);

      return Container(
        height: 240,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(MBGSizes.borderRadiusLg),
          border: Border.all(
            color: isDarkMode
                ? MBGColors.lightGrey.withValues(alpha: 0.4)
                : MBGColors.grey,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: FlutterMap(
          options: MapOptions(
            initialCenter: LatLng(dapur?.latitude ?? 0, dapur?.longitude ?? 0),
          ),
          children: [
            if (isDarkMode)
              ColorFiltered(
                colorFilter: const ColorFilter.matrix([
                  // Grayscale + Invert Matrix
                  // R = 255 - (0.2126*R + 0.7152*G + 0.0722*B)
                  -0.2126, -0.7152, -0.0722, 0, 255, // Red
                  -0.2126, -0.7152, -0.0722, 0, 255, // Green
                  -0.2126, -0.7152, -0.0722, 0, 255, // Blue
                  0, 0, 0, 1, 0, // Alpha
                ]),
                child: TileLayer(
                  urlTemplate:
                      'https://mt1.google.com/vt/lyrs=m&x={x}&y={y}&z={z}',
                  userAgentPackageName: 'com.mbg.tracker.app',
                ),
              )
            else
              TileLayer(
                urlTemplate:
                    'https://mt1.google.com/vt/lyrs=m&x={x}&y={y}&z={z}',
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
