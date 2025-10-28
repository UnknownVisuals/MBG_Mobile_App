import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

class MBGImagePreviewDialog extends StatelessWidget {
  const MBGImagePreviewDialog._({this.imageFile, this.imageData})
    : assert(
        imageFile != null || imageData != null,
        'Either imageFile or imageData must be provided',
      );

  final File? imageFile;
  final String? imageData;

  /// Show image preview dialog for File
  static void showFile({
    required BuildContext context,
    required File imageFile,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MBGImagePreviewDialog._(imageFile: imageFile);
      },
    );
  }

  /// Show image preview dialog for base64/network image
  static void showData({
    required BuildContext context,
    required String imageData,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MBGImagePreviewDialog._(imageData: imageData);
      },
    );
  }

  /// Backward compatibility - show File image
  static void show({required BuildContext context, required File imageFile}) {
    showFile(context: context, imageFile: imageFile);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Close button
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(bottom: MBGSizes.sm),
              child: ElevatedButton.icon(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: MBGColors.dark,
                  padding: const EdgeInsets.symmetric(
                    horizontal: MBGSizes.md,
                    vertical: MBGSizes.xs,
                  ),
                ),
                icon: const Icon(Iconsax.close_circle),
                label: Text(
                  'close'.tr,
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge?.copyWith(color: Colors.white),
                ),
              ),
            ),
          ),

          // Image container
          Flexible(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(MBGSizes.productImageRadius),
              child: InteractiveViewer(child: _buildImage()),
            ),
          ),
        ],
      ),
    );
  }

  /// Build image widget that handles both File and base64/network images
  Widget _buildImage() {
    if (imageFile != null) {
      // Handle File images
      return Image.file(
        imageFile!,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: MBGColors.grey.withValues(alpha: 0.3),
            child: const Icon(Iconsax.image, color: MBGColors.grey, size: 48),
          );
        },
      );
    } else if (imageData != null) {
      // Handle base64 and network images
      if (imageData!.startsWith('data:image')) {
        // Handle base64 images
        try {
          final base64String = imageData!.split(',').last;
          final Uint8List bytes = base64Decode(base64String);
          return Image.memory(
            bytes,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: MBGColors.grey.withValues(alpha: 0.3),
                child: const Icon(
                  Iconsax.image,
                  color: MBGColors.grey,
                  size: 48,
                ),
              );
            },
          );
        } catch (e) {
          return Container(
            color: MBGColors.grey.withValues(alpha: 0.3),
            child: const Icon(Iconsax.image, color: MBGColors.grey, size: 48),
          );
        }
      } else {
        // Handle network images
        return Image.network(
          imageData!,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: MBGColors.grey.withValues(alpha: 0.3),
              child: const Icon(Iconsax.image, color: MBGColors.grey, size: 48),
            );
          },
        );
      }
    } else {
      // Fallback error state
      return Container(
        color: MBGColors.grey.withValues(alpha: 0.3),
        child: const Icon(Iconsax.image, color: MBGColors.grey, size: 48),
      );
    }
  }
}
