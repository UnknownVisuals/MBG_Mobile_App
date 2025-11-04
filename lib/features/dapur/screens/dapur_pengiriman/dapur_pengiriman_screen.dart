import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/common/styles/spacing_styles.dart';
import 'package:mbg_mobile_app/common/widgets/chip_filter.dart';
import 'package:mbg_mobile_app/features/dapur/models/dapur_pengiriman_model.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_pengiriman/widgets/dapur_pengiriman_card.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_pengiriman/widgets/dapur_pengiriman_empty.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

/// Main pengiriman management screen - Dumb UI with hardcoded data
class DapurPengirimanScreen extends StatelessWidget {
  const DapurPengirimanScreen({super.key});

  // Hardcoded mock data for visualization
  static final List<PengirimanModel> _mockPengirimanList = [
    PengirimanModel(
      id: '1',
      qrCodeId: 'QR-001-2024',
      status: 'PENDING',
      jumlahTray: 50,
      jumlahKeranjang: 10,
      sekolahId: 'sekolah-1',
      sekolahNama: 'SDN 01 Jakarta Pusat',
      sekolahAlamat: 'Jl. Sudirman No. 123, Jakarta Pusat',
      dapurId: 'dapur-1',
      createdAt: DateTime(2024, 11, 1, 8, 0),
      updatedAt: DateTime(2024, 11, 1, 8, 0),
    ),
    PengirimanModel(
      id: '2',
      qrCodeId: 'QR-002-2024',
      status: 'IN_TRANSIT',
      jumlahTray: 45,
      jumlahKeranjang: 9,
      sekolahId: 'sekolah-2',
      sekolahNama: 'SDN 02 Jakarta Selatan',
      sekolahAlamat: 'Jl. Gatot Subroto No. 456, Jakarta Selatan',
      dapurId: 'dapur-1',
      driverId: 'driver-1',
      driverNama: 'Budi Santoso',
      waktuDiambil: DateTime(2024, 11, 2, 7, 30),
      createdAt: DateTime(2024, 11, 2, 6, 0),
      updatedAt: DateTime(2024, 11, 2, 7, 30),
    ),
    PengirimanModel(
      id: '3',
      qrCodeId: 'QR-003-2024',
      status: 'DITERIMA',
      jumlahTray: 60,
      jumlahKeranjang: 12,
      sekolahId: 'sekolah-3',
      sekolahNama: 'SDN 03 Jakarta Timur',
      sekolahAlamat: 'Jl. Ahmad Yani No. 789, Jakarta Timur',
      dapurId: 'dapur-1',
      driverId: 'driver-2',
      driverNama: 'Siti Aminah',
      waktuDiambil: DateTime(2024, 11, 1, 7, 0),
      waktuDiterima: DateTime(2024, 11, 1, 9, 30),
      createdAt: DateTime(2024, 11, 1, 6, 0),
      updatedAt: DateTime(2024, 11, 1, 9, 30),
    ),
    PengirimanModel(
      id: '4',
      qrCodeId: 'QR-004-2024',
      status: 'PENDING',
      jumlahTray: 40,
      jumlahKeranjang: 8,
      sekolahId: 'sekolah-4',
      sekolahNama: 'SDN 04 Jakarta Barat',
      sekolahAlamat: 'Jl. Daan Mogot No. 321, Jakarta Barat',
      dapurId: 'dapur-1',
      createdAt: DateTime(2024, 11, 3, 8, 0),
      updatedAt: DateTime(2024, 11, 3, 8, 0),
    ),
  ];

  // Hardcoded selected filter
  static const String _selectedFilter = 'all';

  @override
  Widget build(BuildContext context) {
    // Filter the mock data based on selected filter
    final filteredList = _getFilteredList(_selectedFilter);

    return Scaffold(
      body: Padding(
        padding: MBGSpacingStyles.homeScreenPadding,
        child: Column(
          children: [
            // Chip Filter Section
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  MBChipFilter(
                    chipFilterString: 'Semua (${_mockPengirimanList.length})',
                    chipFilterColor: Colors.blue,
                    chipFilterIcon: Iconsax.category,
                    isSelected: _selectedFilter == 'all',
                    onTap: () {
                      // In real implementation, this would update state
                    },
                  ),
                  const SizedBox(width: MBGSizes.spaceBtwItems),
                  MBChipFilter(
                    chipFilterString: 'Pending (${_getPendingCount()})',
                    chipFilterColor: Colors.orange,
                    chipFilterIcon: Iconsax.clock,
                    isSelected: _selectedFilter == 'pending',
                    onTap: () {
                      // In real implementation, this would update state
                    },
                  ),
                  const SizedBox(width: MBGSizes.spaceBtwItems),
                  MBChipFilter(
                    chipFilterString: 'Dikirim (${_getInTransitCount()})',
                    chipFilterColor: Colors.purple,
                    chipFilterIcon: Iconsax.truck_fast,
                    isSelected: _selectedFilter == 'in_transit',
                    onTap: () {
                      // In real implementation, this would update state
                    },
                  ),
                  const SizedBox(width: MBGSizes.spaceBtwItems),
                  MBChipFilter(
                    chipFilterString: 'Selesai (${_getCompletedCount()})',
                    chipFilterColor: Colors.green,
                    chipFilterIcon: Iconsax.tick_circle,
                    isSelected: _selectedFilter == 'completed',
                    onTap: () {
                      // In real implementation, this would update state
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: MBGSizes.spaceBtwItems),

            // List Section
            Expanded(
              child: filteredList.isEmpty
                  ? const DapurPengirimanEmpty()
                  : RefreshIndicator(
                      onRefresh: () async {
                        // In real implementation, this would refresh data
                        await Future.delayed(const Duration(seconds: 1));
                      },
                      child: ListView.builder(
                        itemCount: filteredList.length,
                        itemBuilder: (context, index) {
                          final pengiriman = filteredList[index];
                          return DapurPengirimanCard(pengiriman: pengiriman);
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => (),
        backgroundColor: MBGColors.primary,
        icon: Icon(Iconsax.profile_add, color: MBGColors.white),
        label: Text(
          'Buat Pengiriman',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: MBGColors.white),
        ),
      ),
    );
  }

  // Helper methods for filtering
  static List<PengirimanModel> _getFilteredList(String filter) {
    switch (filter) {
      case 'pending':
        return _mockPengirimanList.where((p) => p.status == 'PENDING').toList();
      case 'in_transit':
        return _mockPengirimanList
            .where((p) => p.status == 'IN_TRANSIT' || p.status == 'DIAMBIL')
            .toList();
      case 'completed':
        return _mockPengirimanList
            .where((p) => p.status == 'DITERIMA')
            .toList();
      case 'all':
      default:
        return _mockPengirimanList;
    }
  }

  static int _getPendingCount() {
    return _mockPengirimanList.where((p) => p.status == 'PENDING').length;
  }

  static int _getInTransitCount() {
    return _mockPengirimanList
        .where((p) => p.status == 'IN_TRANSIT' || p.status == 'DIAMBIL')
        .length;
  }

  static int _getCompletedCount() {
    return _mockPengirimanList.where((p) => p.status == 'DITERIMA').length;
  }
}
