import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mbg_mobile_app/features/dapur/controllers/dapur_checkpoint_controller.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_checkpoint/widgets/dapur_checkpoint_event_card.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
import 'package:timelines_plus/timelines_plus.dart';

class DapurCheckpointList extends StatelessWidget {
  const DapurCheckpointList({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DapurCheckpointController>();

    return FixedTimeline.tileBuilder(
      theme: TimelineThemeData(nodePosition: 0),
      builder: TimelineTileBuilder.connected(
        itemCount: controller.allCheckpointTypes.length,
        contentsBuilder: (context, index) {
          final tipe = controller.allCheckpointTypes[index];
          final status = controller.getCheckpointStatus(tipe);
          final checkpoint = controller.getCheckpointModel(tipe);

          return Padding(
            padding: const EdgeInsets.only(
              left: MBGSizes.spaceBtwItems,
              bottom: MBGSizes.spaceBtwItems,
            ),
            child: DapurCheckpointEventCard(
              tipe: tipe,
              status: status,
              checkpoint: checkpoint,
            ),
          );
        },
        indicatorBuilder: (context, index) {
          final tipe = controller.allCheckpointTypes[index];
          final status = controller.getCheckpointStatus(tipe);

          return OutlinedDotIndicator(
            color: status == 'completed'
                ? MBGColors.primary
                : status == 'active'
                ? MBGColors.warning
                : MBGColors.grey,
          );
        },
        connectorBuilder: (context, index, connectorType) {
          final tipe = controller.allCheckpointTypes[index];
          final status = controller.getCheckpointStatus(tipe);

          return DashedLineConnector(
            color: status == 'completed' ? MBGColors.primary : MBGColors.grey,
          );
        },
      ),
    );
  }
}
