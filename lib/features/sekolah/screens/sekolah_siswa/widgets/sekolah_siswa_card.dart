import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

import '../../../models/sekolah_siswa_model.dart';

/// Card widget displaying student information
class SekolahSiswaCardWidget extends StatelessWidget {
  final SekolahSiswaModel siswa;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const SekolahSiswaCardWidget({
    super.key,
    required this.siswa,
    required this.onTap,
    required this.onDelete,
  });

  Color _getStatusGiziColor(String? statusGizi) {
    if (statusGizi == null) return Colors.grey;
    switch (statusGizi) {
      case 'GIZI_BAIK':
        return Colors.green;
      case 'GIZI_KURANG':
        return Colors.orange;
      case 'GIZI_BURUK':
        return Colors.red;
      case 'OBESITAS':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  String _getStatusGiziLabel(String? statusGizi) {
    if (statusGizi == null) return 'N/A';
    return statusGizi.replaceAll('_', ' ');
  }

  String _formatGender(String? gender) {
    if (gender == 'PEREMPUAN') return 'Perempuan';
    if (gender == 'LAKI_LAKI') return 'Laki-laki';
    return 'Tidak tersedia';
  }

  String _safeText(String? value, {String fallback = '-'}) {
    if (value == null || value.trim().isEmpty) return fallback;
    return value;
  }

  Widget _buildInfoPill(IconData icon, String label, BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: MBGSizes.sm,
        vertical: MBGSizes.xs,
      ),
      decoration: BoxDecoration(
        color: MBGColors.light.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(MBGSizes.cardRadiusSm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: MBGSizes.iconSm, color: MBGColors.textSecondary),
          const SizedBox(width: MBGSizes.xs),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: MBGColors.textSecondary),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayName = _safeText(siswa.nama, fallback: 'Nama tidak tersedia');
    final nisValue = _safeText(siswa.nis, fallback: 'N/A');
    final imtValue = siswa.imt != null ? siswa.imt!.toStringAsFixed(1) : 'N/A';
    final umur = siswa.umur?.toString() ?? '-';
    final tinggi = siswa.tinggiBadan?.toStringAsFixed(1) ?? '-';
    final berat = siswa.beratBadan?.toStringAsFixed(1) ?? '-';
    final kelasLabel = siswa.kelas?.nama ?? 'Kelas belum tersedia';
    final statusColor = _getStatusGiziColor(siswa.statusGizi);
    final genderDisplay = _formatGender(siswa.jenisKelamin);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [MBGColors.white, MBGColors.primaryBackground],
        ),
        borderRadius: BorderRadius.circular(MBGSizes.cardRadiusLg),
        boxShadow: [
          BoxShadow(
            color: MBGColors.primary.withValues(alpha: 0.15),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(MBGSizes.cardRadiusLg),
        child: Padding(
          padding: const EdgeInsets.all(MBGSizes.sm * 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          MBGColors.primary.withValues(alpha: 0.35),
                          MBGColors.primary.withValues(alpha: 0.05),
                        ],
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 28,
                      backgroundColor: MBGColors.lightContainer,
                      backgroundImage: siswa.fotoUrl != null
                          ? NetworkImage(siswa.fotoUrl!)
                          : null,
                      child: siswa.fotoUrl == null
                          ? Text(
                              displayName.characters.first,
                              style: const TextStyle(fontSize: 24),
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(width: MBGSizes.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                displayName,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: onTap,
                                  padding: const EdgeInsets.all(4),
                                  constraints: const BoxConstraints(
                                    minHeight: 32,
                                    minWidth: 32,
                                  ),
                                  icon: const Icon(
                                    Iconsax.edit,
                                    color: MBGColors.primary,
                                  ),
                                  tooltip: 'Edit siswa',
                                ),
                                IconButton(
                                  onPressed: onDelete,
                                  padding: const EdgeInsets.all(4),
                                  constraints: const BoxConstraints(
                                    minHeight: 32,
                                    minWidth: 32,
                                  ),
                                  icon: const Icon(
                                    Iconsax.trash,
                                    color: MBGColors.error,
                                  ),
                                  tooltip: 'Hapus siswa',
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: MBGSizes.xs),
                        Row(
                          children: [
                            Icon(
                              Iconsax.hashtag,
                              size: MBGSizes.iconSm,
                              color: MBGColors.textSecondary,
                            ),
                            const SizedBox(width: MBGSizes.xs),
                            Text(
                              'NIS: $nisValue',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: MBGColors.textSecondary),
                            ),
                          ],
                        ),
                        const SizedBox(height: MBGSizes.xs),
                        Row(
                          children: [
                            Icon(
                              Iconsax.book_square,
                              size: MBGSizes.iconSm,
                              color: MBGColors.textSecondary,
                            ),
                            const SizedBox(width: MBGSizes.xs),
                            Expanded(
                              child: Text(
                                kelasLabel,
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: MBGColors.textSecondary),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: MBGSizes.xs),
              Wrap(
                spacing: MBGSizes.sm,
                runSpacing: MBGSizes.xs,
                children: [
                  _buildInfoPill(Iconsax.user, genderDisplay, context),
                  _buildInfoPill(Iconsax.activity, 'IMT $imtValue', context),
                  _buildInfoPill(
                    Iconsax.weight_1,
                    '$tinggi cm • $berat kg',
                    context,
                  ),
                  _buildInfoPill(Iconsax.calendar, '$umur tahun', context),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: MBGSizes.sm,
                      vertical: MBGSizes.xs,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(
                        MBGSizes.cardRadiusSm,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Iconsax.heart,
                          size: MBGSizes.iconSm,
                          color: statusColor,
                        ),
                        const SizedBox(width: MBGSizes.xs),
                        Text(
                          _getStatusGiziLabel(siswa.statusGizi),
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(color: statusColor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
