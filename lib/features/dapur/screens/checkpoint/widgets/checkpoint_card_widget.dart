import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../controllers/checkpoint_controller.dart';

/// Checkpoint card displaying type, timestamp, and photo
class CheckpointCardWidget extends StatelessWidget {
  final dynamic checkpoint;
  final VoidCallback onPhotoTap;

  const CheckpointCardWidget({
    super.key,
    required this.checkpoint,
    required this.onPhotoTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: MBGSizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Checkpoint Type Header
          Container(
            padding: const EdgeInsets.all(MBGSizes.md),
            decoration: BoxDecoration(
              color: _getCheckpointColor(
                checkpoint.tipe,
              ).withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(MBGSizes.borderRadiusMd),
                topRight: Radius.circular(MBGSizes.borderRadiusMd),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _getCheckpointIcon(checkpoint.tipe),
                  color: _getCheckpointColor(checkpoint.tipe),
                ),
                const SizedBox(width: MBGSizes.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Get.find<CheckpointController>().getCheckpointTypeName(
                          checkpoint.tipe,
                        ),
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: _getCheckpointColor(checkpoint.tipe),
                            ),
                      ),
                      Text(
                        DateFormat(
                          'dd MMM yyyy, HH:mm',
                        ).format(checkpoint.createdAt),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Photo
          if (checkpoint.foto != null)
            GestureDetector(
              onTap: onPhotoTap,
              child: SizedBox(
                height: 200,
                width: double.infinity,
                child: Image.network(
                  checkpoint.foto!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[200],
                    child: Icon(
                      Icons.broken_image,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  IconData _getCheckpointIcon(String type) {
    switch (type) {
      case 'MULAI_MEMASAK':
        return Iconsax.timer_start;
      case 'SELESAI_MEMASAK':
        return Iconsax.tick_circle;
      case 'SELESAI_PACKING':
        return Iconsax.box;
      case 'KITCHEN_RECEIVED':
        return Iconsax.received;
      case 'WASHING_COMPLETE':
        return Iconsax.security;
      case 'SCHOOL_TO_DRIVER_RETURN':
        return Iconsax.truck_fast;
      case 'DRIVER_TO_KITCHEN':
        return Iconsax.home_2;
      default:
        return Iconsax.camera;
    }
  }

  Color _getCheckpointColor(String type) {
    switch (type) {
      case 'MULAI_MEMASAK':
        return Colors.blue;
      case 'SELESAI_MEMASAK':
        return Colors.green;
      case 'SELESAI_PACKING':
        return Colors.orange;
      case 'KITCHEN_RECEIVED':
        return Colors.purple;
      case 'WASHING_COMPLETE':
        return MBGColors.primary;
      case 'SCHOOL_TO_DRIVER_RETURN':
        return Colors.teal;
      case 'DRIVER_TO_KITCHEN':
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }
}
