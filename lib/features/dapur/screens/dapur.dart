import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mbg_mobile_app/common/styles/spacing_styles.dart';
import 'package:mbg_mobile_app/common/widgets/appbar.dart';
import 'package:mbg_mobile_app/common/widgets/drawer.dart';
import 'package:mbg_mobile_app/features/authentication/controllers/user_controller.dart';
import 'package:mbg_mobile_app/features/dapur/controllers/dapur_controller.dart';
import 'package:mbg_mobile_app/features/dapur/screens/widgets/progress_summary_card.dart';
import 'package:mbg_mobile_app/features/dapur/screens/widgets/timeline_list.dart';
import 'package:mbg_mobile_app/features/dapur/screens/widgets/timeline_header.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

class DapurScreen extends StatelessWidget {
  const DapurScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Get.put(UserController());
    final dapurController = Get.put(DapurController());

    return Scaffold(
      appBar: MBGAppBar(
        showDrawerIcon: true,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Selamat Datang Kembali",
              style: Theme.of(context).textTheme.labelMedium,
            ),
            Text(
              "Halo, ${userController.user.value?.name ?? ''}!",
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      drawer: MBGDrawer(userController: userController),
      body: Padding(
        padding: MBGSpacingStyles.homeScreenPadding,
        child: Obx(
          () => Column(
            children: [
              // Progress Summary Card
              ProgressSummaryCard(
                completedCount: dapurController.completedCount.value,
                totalCount: dapurController.totalCount.value,
              ),
              const SizedBox(height: MBGSizes.spaceBtwSections),

              // Timeline Header
              const TimelineHeader(),
              const SizedBox(height: MBGSizes.spaceBtwItems),

              // Timeline List
              Expanded(
                child: TimelineList(
                  events: dapurController.events.toList(),
                  scrollController: dapurController.scrollController,
                  cardKeys: dapurController.cardKeys,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
