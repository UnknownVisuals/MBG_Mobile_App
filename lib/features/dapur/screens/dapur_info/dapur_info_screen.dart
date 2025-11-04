import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:mbg_mobile_app/common/styles/spacing_styles.dart';
import 'package:mbg_mobile_app/common/widgets/info_row.dart';
import 'package:mbg_mobile_app/common/widgets/section_heading.dart';
import 'package:mbg_mobile_app/features/dapur/controllers/dapur_info_controller.dart';
import 'package:mbg_mobile_app/features/dapur/models/dapur_info_model.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_info/dapur_info_horizontal_card_list.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_info/widgets/dapur_info_map_preview.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_info/widgets/dapur_info_driver_card.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_info/widgets/dapur_info_karyawan_card.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_info/widgets/dapur_info_pic_card.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_info/widgets/dapur_info_sekolah_card.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_info/widgets/dapur_info_stok_card.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

class DapurInfoScreen extends StatelessWidget {
  const DapurInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DapurInfoController dapurInfoController = Get.put(
      DapurInfoController(),
    );

    return Obx(() {
      final dapur = dapurInfoController.dapurInfo.value;
      final picDapur = dapur?.picDapur ?? [];
      final drivers = dapur?.drivers ?? [];
      final karyawan = dapur?.karyawan ?? [];
      final stokBahanBaku = dapur?.stokBahanBaku ?? [];
      final sekolahDilayani = dapur?.sekolahDilayani ?? [];

      if (dapurInfoController.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(color: MBGColors.primary),
        );
      }

      return RefreshIndicator(
        color: MBGColors.primary,
        onRefresh: dapurInfoController.refreshDapurInfo,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: MBGSpacingStyles.homeScreenPadding,
          child: Column(
            children: [
              // =========================
              // DAPUR INFORMATION SECTION
              // =========================
              MBGSectionHeading(
                showLeadingIcon: true,
                leadingIcon: Iconsax.information,
                title: 'Informasi Dapur',
              ),
              const SizedBox(height: MBGSizes.spaceBtwItems),
              MBGInfoRow(title: 'Nama Dapur', value: "${dapur?.nama}"),
              MBGInfoRow(title: 'Alamat', value: "${dapur?.alamat}"),
              MBGInfoRow(title: 'Status', value: "${dapur?.status}"),
              MBGInfoRow(
                title: 'Koordinat',
                value: "${dapur?.latitude}, ${dapur?.longitude}",
              ),
              MBGInfoRow(
                title: 'Dibuat Pada',
                value: dapur?.createdAt != null
                    ? DateFormat(
                        'dd MMMM yyyy, HH:mm',
                      ).format(dapur!.createdAt.toLocal())
                    : '-',
              ),
              MBGInfoRow(
                title: 'Diperbarui Pada',
                value: dapur?.updatedAt != null
                    ? DateFormat(
                        'dd MMMM yyyy, HH:mm',
                      ).format(dapur!.updatedAt.toLocal())
                    : '-',
              ),
              const SizedBox(height: MBGSizes.spaceBtwSections),

              // ===================
              // MAP PREVIEW SECTION
              // ===================
              MBGSectionHeading(
                showLeadingIcon: true,
                leadingIcon: Iconsax.location,
                title: 'Lokasi Dapur',
              ),
              const SizedBox(height: MBGSizes.spaceBtwItems),
              DapurInfoMapPreview(),
              const SizedBox(height: MBGSizes.spaceBtwSections),

              // =================
              // PIC DAPUR SECTION
              // =================
              MBGSectionHeading(
                showLeadingIcon: true,
                leadingIcon: Iconsax.profile_2user,
                title: 'PIC Dapur (${picDapur.length})',
              ),
              const SizedBox(height: MBGSizes.spaceBtwItems),
              DapurInfoHorizontalCardList<PICDapurSummary>(
                items: picDapur,
                emptyMessage: 'Tidak ada PIC yang ditugaskan',
                listHeight: 180,
                itemBuilder: (context, item, index) =>
                    DapurInfoPicCard(pic: item),
              ),
              const SizedBox(height: MBGSizes.spaceBtwSections),

              // ===============
              // DRIVERS SECTION
              // ===============
              MBGSectionHeading(
                showLeadingIcon: true,
                leadingIcon: Iconsax.truck,
                title: 'Driver (${drivers.length})',
              ),
              const SizedBox(height: MBGSizes.spaceBtwItems),
              DapurInfoHorizontalCardList<DriversSummary>(
                items: drivers,
                emptyMessage: 'Tidak ada driver yang ditugaskan',
                listHeight: 215,
                itemBuilder: (context, item, index) =>
                    DapurInfoDriverCard(driver: item),
              ),
              const SizedBox(height: MBGSizes.spaceBtwSections),

              // ================
              // KARYAWAN SECTION
              // ================
              MBGSectionHeading(
                showLeadingIcon: true,
                leadingIcon: Iconsax.people,
                title: 'Karyawan (${karyawan.length})',
              ),
              const SizedBox(height: MBGSizes.spaceBtwItems),
              DapurInfoHorizontalCardList<KaryawanSummary>(
                items: karyawan,
                emptyMessage: 'Tidak ada karyawan terdaftar',
                listHeight: 190,
                itemBuilder: (context, item, index) =>
                    DapurInfoKaryawanCard(karyawan: item),
              ),
              const SizedBox(height: MBGSizes.spaceBtwSections),

              // =======================
              // STOK BAHAN BAKU SECTION
              // =======================
              MBGSectionHeading(
                showLeadingIcon: true,
                leadingIcon: Iconsax.box,
                title: 'Stok Bahan Baku (${stokBahanBaku.length})',
              ),
              const SizedBox(height: MBGSizes.spaceBtwItems),
              DapurInfoHorizontalCardList<StockSummary>(
                items: stokBahanBaku,
                emptyMessage: 'Tidak ada stok bahan baku',
                listHeight: 190,
                itemBuilder: (context, item, index) =>
                    DapurInfoStokCard(stok: item),
              ),
              const SizedBox(height: MBGSizes.spaceBtwSections),

              // ========================
              // SEKOLAH DILAYANI SECTION
              // ========================
              MBGSectionHeading(
                showLeadingIcon: true,
                leadingIcon: Iconsax.building_3,
                title: 'Sekolah Dilayani (${sekolahDilayani.length})',
              ),
              const SizedBox(height: MBGSizes.spaceBtwItems),
              DapurInfoHorizontalCardList<SekolahDilayaniSummary>(
                items: sekolahDilayani,
                emptyMessage: 'Tidak ada sekolah yang dilayani',
                listHeight: 235,
                itemBuilder: (context, item, index) =>
                    DapurInfoSekolahCard(sekolahDilayani: item),
              ),
              const SizedBox(height: MBGSizes.spaceBtwSections * 2),
            ],
          ),
        ),
      );
    });
  }
}
