import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
import 'package:mbg_mobile_app/common/widgets/image_preview_dialog.dart';

class DapurCheckpointEventCardImage extends StatelessWidget {
  const DapurCheckpointEventCardImage({super.key, required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        MBGImagePreviewDialog.showData(context: context, imageData: imageUrl);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(MBGSizes.cardRadiusMd),
        child: Image.network(
          imageUrl,
          height: 180,
          width: double.infinity,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              height: 180,
              decoration: BoxDecoration(
                color: MBGColors.softGrey,
                borderRadius: BorderRadius.circular(MBGSizes.cardRadiusMd),
              ),
              child: const Center(
                child: CircularProgressIndicator(color: MBGColors.primary),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              height: 180,
              decoration: BoxDecoration(
                color: MBGColors.softGrey,
                borderRadius: BorderRadius.circular(MBGSizes.cardRadiusMd),
              ),
              child: Center(
                child: Icon(
                  Iconsax.gallery_slash,
                  color: MBGColors.grey,
                  size: MBGSizes.iconLg,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
