import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../utils/constants/sizes.dart';

class AbsensiClassListWidget extends StatelessWidget {
  final List<Map<String, dynamic>> kelasList;
  final Map<String, dynamic>? selectedKelas;
  final Function(Map<String, dynamic>)? onKelasTap;

  const AbsensiClassListWidget({
    super.key,
    required this.kelasList,
    this.selectedKelas,
    this.onKelasTap,
  });

  @override
  Widget build(BuildContext context) {
    final selectedNama = selectedKelas?['nama'];
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            color: colors.outlineVariant, // ADAPTIVE BORDER
          ),
        ),
      ),
      child: ListView.builder(
        padding: const EdgeInsets.all(MBGSizes.md),
        itemCount: kelasList.length,
        itemBuilder: (context, index) {
          final kelas = kelasList[index];
          final isSelected = kelas['nama'] == selectedNama;

          return Card(
            elevation: isSelected ? 3 : 1,
            color: isSelected
                ? colors.primaryContainer.withOpacity(0.4) // ADAPTIVE SELECTED BG
                : colors.surface, // DEFAULT BG
            margin: const EdgeInsets.only(bottom: MBGSizes.sm),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(MBGSizes.borderRadiusMd),
              side: BorderSide(
                color: isSelected
                    ? colors.primary
                    : colors.outlineVariant, // ADAPTIVE BORDER
                width: 1,
              ),
            ),
            child: ListTile(
              onTap: () => onKelasTap?.call(kelas),

              // LEADING ICON / BOX
              leading: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: isSelected
                      ? colors.primary
                      : colors.primary.withOpacity(0.15),
                  borderRadius:
                      BorderRadius.circular(MBGSizes.borderRadiusMd),
                ),
                child: Center(
                  child: Text(
                    kelas['nama'],
                    style: text.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isSelected ? colors.onPrimary : colors.primary,
                    ),
                  ),
                ),
              ),

              // TITLE
              title: Text(
                'Kelas ${kelas['nama']}',
                style: text.titleMedium?.copyWith(
                  fontWeight:
                      isSelected ? FontWeight.bold : FontWeight.normal,
                  color: colors.onSurface,
                ),
              ),

              // SUBTITLE
              subtitle: Text(
                '${kelas['jumlahSiswa']} siswa',
                style: text.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),

              // TRAILING ICON
              trailing: Icon(
                isSelected ? Iconsax.tick_circle5 : Iconsax.arrow_right_3,
                color: isSelected ? colors.primary : colors.outline,
              ),
            ),
          );
        },
      ),
    );
  }
}
