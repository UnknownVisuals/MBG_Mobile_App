import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/features/sekolah/models/sekolah_siswa_model.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: MBGSizes.sm,
        vertical: MBGSizes.xs,
      ),
      decoration: BoxDecoration(
        color: isDark
            ? MBGColors.darkerGrey.withValues(alpha: 0.4)
            : MBGColors.grey.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(MBGSizes.cardRadiusSm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: MBGSizes.iconSm, color: theme.colorScheme.onSurface),
          const SizedBox(width: MBGSizes.xs),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

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
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(MBGSizes.cardRadiusLg),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.4)
                : MBGColors.primary.withValues(alpha: 0.1),
            blurRadius: isDark ? 10 : 18,
            offset: const Offset(0, 6),
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
              /// === HEADER ===
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Avatar
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDark
                          ? MBGColors.darkGrey.withValues(alpha: 0.4)
                          : MBGColors.lightGrey.withValues(alpha: 0.3),
                    ),
                    child: CircleAvatar(
                      radius: 28,
                      backgroundColor: isDark
                          ? MBGColors.darkGrey
                          : MBGColors.lightContainer,
                      backgroundImage: siswa.fotoUrl != null
                          ? NetworkImage(siswa.fotoUrl!)
                          : null,
                      child: siswa.fotoUrl == null
                          ? Text(
                              displayName.characters.first,
                              style: TextStyle(
                                fontSize: 24,
                                color: theme.colorScheme.onSurface,
                              ),
                            )
                          : null,
                    ),
                  ),

                  const SizedBox(width: MBGSizes.md),

                  /// Nama + Edit/Delete
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Nama + Icons
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                displayName,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                            ),

                            Row(
                              children: [
                                IconButton(
                                  onPressed: onTap,
                                  icon: Icon(
                                    Iconsax.edit,
                                    color: MBGColors.primary,
                                  ),
                                  tooltip: 'Edit siswa',
                                ),
                                IconButton(
                                  onPressed: onDelete,
                                  icon: Icon(
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

                        /// NIS
                        Row(
                          children: [
                            Icon(
                              Iconsax.hashtag,
                              size: MBGSizes.iconSm,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: MBGSizes.xs),
                            Text(
                              'NIS: $nisValue',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: MBGSizes.xs),

                        /// Kelas
                        Row(
                          children: [
                            Icon(
                              Iconsax.book_square,
                              size: MBGSizes.iconSm,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: MBGSizes.xs),
                            Expanded(
                              child: Text(
                                kelasLabel,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: MBGSizes.sm),

              /// === PILLS ROW ===
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

                  /// Status gizi pill
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
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: statusColor,
                          ),
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
