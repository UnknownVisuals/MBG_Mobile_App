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

    return Obx(
      () => Container(
        height: 400,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(MBGSizes.borderRadiusLg),
        ),
        clipBehavior: Clip.antiAlias,
        child: dapurInfoController.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(color: MBGColors.primary),
              )
            : FlutterMap(
                options: MapOptions(
                  initialCenter: dapurInfoController.dapurInfo.value != null
                      ? LatLng(
                          dapurInfoController.dapurInfo.value!.latitude,
                          dapurInfoController.dapurInfo.value!.longitude,
                        )
                      : const LatLng(-6.9175, 107.6191),
                  initialZoom: 16.0,
                  minZoom: 3.0,
                  maxZoom: 19.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://mt1.google.com/vt/lyrs=m&x={x}&y={y}&z={z}',
                    userAgentPackageName: 'com.mbg.tracker.app',
                    maxZoom: 20,
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: dapurInfoController.dapurInfo.value != null
                            ? LatLng(
                                dapurInfoController.dapurInfo.value!.latitude,
                                dapurInfoController.dapurInfo.value!.longitude,
                              )
                            : const LatLng(-6.9175, 107.6191),
                        width: 50,
                        height: 70,
                        child: const Icon(
                          Icons.location_on,
                          size: MBGSizes.iconLg,
                          color: MBGColors.error,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
