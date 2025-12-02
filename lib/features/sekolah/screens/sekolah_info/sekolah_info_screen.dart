import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:mbg_mobile_app/common/styles/spacing_styles.dart';
import 'package:mbg_mobile_app/common/widgets/info_row.dart';
import 'package:mbg_mobile_app/common/widgets/section_heading.dart';
import 'package:mbg_mobile_app/features/sekolah/controllers/sekolah_info_controller.dart';
import 'package:mbg_mobile_app/features/sekolah/models/sekolah_info_model.dart';
import 'package:mbg_mobile_app/features/sekolah/screens/sekolah_info/sekolah_info_horizontal_card_list.dart';
import 'package:mbg_mobile_app/features/sekolah/screens/sekolah_info/widgets/sekolah_info_dapur_card.dart';
import 'package:mbg_mobile_app/features/sekolah/screens/sekolah_info/widgets/sekolah_info_kelas_card.dart';
import 'package:mbg_mobile_app/features/sekolah/screens/sekolah_info/widgets/sekolah_info_map_preview.dart';
import 'package:mbg_mobile_app/features/sekolah/screens/sekolah_info/widgets/sekolah_info_pic_card.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
import 'package:mbg_mobile_app/utils/helpers/responsive.dart';

class SekolahInfoScreen extends StatelessWidget {
  const SekolahInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SekolahInfoController controller = Get.put(SekolahInfoController());

    return Obx(() {
      final SekolahInfoModel? sekolah = controller.sekolahInfo.value;
      final picList = sekolah?.picSekolah ?? [];
      final kelasList = sekolah?.kelas ?? [];
      final dapurList = sekolah?.dapurPelayanan ?? [];

      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(color: MBGColors.primary),
        );
      }

      if (controller.sekolahId == null) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Iconsax.building,
                size: MBGSizes.iconLg * 2,
                color: MBGColors.textSecondary,
              ),
              const SizedBox(height: MBGSizes.spaceBtwItems),
              Text(
                'Belum ada sekolah yang ditugaskan',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: MBGColors.textSecondary,
                ),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        color: MBGColors.primary,
        onRefresh: controller.refreshSekolahInfo,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: MBGSpacingStyles.homeScreenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MBGSectionHeading(
                showLeadingIcon: true,
                leadingIcon: Iconsax.information,
                title: 'Informasi Sekolah',
              ),
              const SizedBox(height: MBGSizes.spaceBtwItems),
              MBGInfoRow(title: 'Nama Sekolah', value: sekolah?.nama ?? '-'),
              MBGInfoRow(title: 'Alamat', value: sekolah?.alamat ?? '-'),
              MBGInfoRow(
                title: 'Provinsi',
                value: sekolah?.province?.name ?? '-',
              ),
              MBGInfoRow(
                title: 'Kabupaten/Kota',
                value: sekolah?.regency?.name ?? '-',
              ),
              MBGInfoRow(
                title: 'Koordinat',
                value:
                    sekolah != null &&
                        sekolah.latitude != null &&
                        sekolah.longitude != null
                    ? '${sekolah.latitude!.toStringAsFixed(4)}, ${sekolah.longitude!.toStringAsFixed(4)}'
                    : '-',
              ),
              MBGInfoRow(
                title: 'Jumlah Siswa Terdaftar',
                value: sekolah?.count?.siswa?.toString() ?? '-',
              ),
              MBGInfoRow(
                title: 'Dibuat Pada',
                value: sekolah?.createdAt != null
                    ? DateFormat(
                        'dd MMMM yyyy, HH:mm',
                        'id_ID',
                      ).format(sekolah!.createdAt!.toLocal())
                    : '-',
              ),
              MBGInfoRow(
                title: 'Diperbarui Pada',
                value: sekolah?.updatedAt != null
                    ? DateFormat(
                        'dd MMMM yyyy, HH:mm',
                        'id_ID',
                      ).format(sekolah!.updatedAt!.toLocal())
                    : '-',
              ),
              const SizedBox(height: MBGSizes.spaceBtwSections),
              MBGSectionHeading(
                showLeadingIcon: true,
                leadingIcon: Iconsax.location,
                title: 'Lokasi Sekolah',
              ),
              const SizedBox(height: MBGSizes.spaceBtwItems),
              const SekolahInfoMapPreview(),
              const SizedBox(height: MBGSizes.spaceBtwSections),
              MBGSectionHeading(
                showLeadingIcon: true,
                leadingIcon: Iconsax.profile_2user,
                title: 'PIC Sekolah (${picList.length})',
              ),
              const SizedBox(height: MBGSizes.spaceBtwItems),
              SekolahInfoHorizontalCardList<SekolahInfoPICSekolahSummary>(
                items: picList,
                emptyMessage: 'Tidak ada PIC sekolah',
                listHeight: MBGResponsive.autoScaleHeight(context, 190),
                itemBuilder: (context, item, index) =>
                    SekolahInfoPicCard(pic: item),
              ),
              const SizedBox(height: MBGSizes.spaceBtwSections),
              MBGSectionHeading(
                showLeadingIcon: true,
                leadingIcon: Iconsax.buildings,
                title: 'Kelas (${kelasList.length})',
              ),
              const SizedBox(height: MBGSizes.spaceBtwItems),
              SekolahInfoHorizontalCardList<SekolahInfoKelasSummary>(
                items: kelasList,
                emptyMessage: 'Tidak ada kelas yang terdaftar',
                listHeight: MBGResponsive.autoScaleHeight(context, 220),
                itemBuilder: (context, item, index) =>
                    SekolahInfoKelasCard(kelas: item),
              ),
              const SizedBox(height: MBGSizes.spaceBtwSections),
              MBGSectionHeading(
                showLeadingIcon: true,
                leadingIcon: Iconsax.building_3,
                title: 'Dapur Pelayanan (${dapurList.length})',
              ),
              const SizedBox(height: MBGSizes.spaceBtwItems),
              SekolahInfoHorizontalCardList<SekolahInfoDapurPelayananSummary>(
                items: dapurList,
                emptyMessage: 'Belum ada dapur yang melayani',
                listHeight: MBGResponsive.autoScaleHeight(context, 240),
                itemBuilder: (context, item, index) =>
                    SekolahInfoDapurCard(pelayanan: item),
              ),
              const SizedBox(height: MBGSizes.spaceBtwSections * 2),
            ],
          ),
        ),
      );
    });
  }
}
