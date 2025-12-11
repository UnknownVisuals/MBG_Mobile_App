import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mbg_mobile_app/common/styles/spacing_styles.dart';
import 'package:mbg_mobile_app/common/widgets/empty_list_display.dart';
import 'package:mbg_mobile_app/common/widgets/section_heading.dart';
import 'package:mbg_mobile_app/features/driver/controllers/driver_tray_return_controller.dart';
import 'package:mbg_mobile_app/features/driver/screens/driver_dashboard/widgets/driver_dashboard_qr_scanner.dart';
import 'package:mbg_mobile_app/features/driver/screens/driver_dashboard/widgets/driver_dashboard_quick_action_card.dart';
import 'package:mbg_mobile_app/features/driver/screens/driver_tray_return/widgets/driver_tray_return_card.dart';
import 'package:mbg_mobile_app/features/driver/screens/driver_tray_return/widgets/driver_tray_return_pickup_form.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

class DriverTrayReturnScreen extends StatelessWidget {
  const DriverTrayReturnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DriverTrayReturnController());

    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: controller.fetchTrayPickups,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: MBGSpacingStyles.homeScreenPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => _navigateToScanner(context, controller),
                  child: const DriverDashboardQuickActionCard(
                    title: 'Scan QR Sekolah',
                    subtitle: 'Scan QR Sekolah untuk mengambil tray',
                  ),
                ),
                const SizedBox(height: MBGSizes.spaceBtwSections),
                MBGSectionHeading(
                  title: 'Riwayat Pickup',
                  showActionButton: true,
                  actionButtonTitle:
                      "${controller.filteredTrayPickups.length} pickup",
                ),
                const SizedBox(height: MBGSizes.spaceBtwItems),
                if (controller.filteredTrayPickups.isEmpty)
                  const MBGEmptyListDisplay(
                    title: 'Belum ada pickup',
                    subTitle: 'Riwayat pickup tray akan muncul di sini',
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.filteredTrayPickups.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: MBGSizes.spaceBtwItems),
                    itemBuilder: (context, index) {
                      final item = controller.filteredTrayPickups[index];
                      return DriverTrayReturnCard(item: item);
                    },
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }

  void _navigateToScanner(
    BuildContext context,
    DriverTrayReturnController controller,
  ) {
    Get.to(
      () => DriverDashboardQrScanner(
        onScanned: (code) async {
          if (code.isNotEmpty) {
            // Stop scanning logic is handled by the widget implicitly or we just handle data
            Get.back(); // Close scanner
            controller.resetForm();
            Get.bottomSheet(
              DriverTrayReturnPickupForm(qrCodeId: code),
              isScrollControlled: true,
              backgroundColor: Colors.white,
            );
          }
        },
      ),
    );
  }
}
