import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/common/widgets/empty_list_display.dart';
import 'package:mbg_mobile_app/features/dapur/controllers/dapur_tray_return_controller.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_tray_return/widgets/dapur_tray_return_card.dart';
import 'package:mbg_mobile_app/features/driver/screens/driver_dashboard/widgets/driver_dashboard_qr_scanner.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

class DapurTrayReturnScreen extends StatelessWidget {
  const DapurTrayReturnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DapurTrayReturnController());

    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: controller.fetchTrayReceives,
          child: Padding(
            padding: const EdgeInsets.all(MBGSizes.md),
            child: Column(
              children: [
                // Scan Action Button
                Material(
                  borderRadius: BorderRadius.circular(MBGSizes.borderRadiusLg),
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(
                      MBGSizes.borderRadiusLg,
                    ),
                    onTap: () => _startScanning(context, controller),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: MBGColors.primaryGradient,
                        borderRadius: BorderRadius.circular(
                          MBGSizes.borderRadiusLg,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: MBGColors.primary.withValues(alpha: 0.4),
                            blurRadius: 18,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: MBGSizes.lg,
                        vertical: MBGSizes.md,
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(
                              MBGSizes.defaultSpace / 2,
                            ),
                            decoration: BoxDecoration(
                              color: MBGColors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(
                                MBGSizes.cardRadiusMd,
                              ),
                            ),
                            child: const Icon(
                              Iconsax.scan_barcode,
                              color: MBGColors.white,
                              size: MBGSizes.iconLg,
                            ),
                          ),
                          const SizedBox(width: MBGSizes.spaceBtwItems),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Scan QR Driver',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(
                                        color: MBGColors.textWhite,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: MBGSizes.xs),
                                Text(
                                  'Terima pengembalian tray dari driver',
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(color: MBGColors.textWhite),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Iconsax.arrow_right_3,
                            color: MBGColors.textWhite,
                            size: MBGSizes.iconMd,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: MBGSizes.spaceBtwSections),

                if (controller.trayReceives.isEmpty)
                  const Expanded(
                    child: MBGEmptyListDisplay(
                      title: 'Belum ada penerimaan',
                      subTitle: 'Riwayat penerimaan tray akan muncul di sini',
                    ),
                  )
                else
                  Expanded(
                    child: ListView.separated(
                      padding: EdgeInsets.zero,
                      itemCount: controller.trayReceives.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: MBGSizes.spaceBtwItems),
                      itemBuilder: (context, index) {
                        final item = controller.trayReceives[index];
                        return DapurTrayReturnCard(item: item);
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }

  void _startScanning(
    BuildContext context,
    DapurTrayReturnController controller,
  ) {
    Get.to(
      () => DriverDashboardQrScanner(
        title: 'Scan QR Tray',
        subtitle: 'Scan QR code pada tray driver',
        onScanned: (code) async {
          if (code.isNotEmpty) {
            Get.back(); // Stop scanning
            _showConfirmation(context, controller, code);
          }
        },
      ),
    );
  }

  void _showConfirmation(
    BuildContext context,
    DapurTrayReturnController controller,
    String qrCodeId,
  ) {
    Get.defaultDialog(
      title: 'Konfirmasi Penerimaan',
      middleText:
          'Apakah Anda yakin ingin menerima tray dengan ID:\n$qrCodeId?',
      textConfirm: 'Ya, Terima',
      textCancel: 'Batal',
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back(); // Close dialog
        controller.receiveTray(qrCodeId);
      },
    );
  }
}
