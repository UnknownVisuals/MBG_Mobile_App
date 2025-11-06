import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

class SekolahManagementScreen extends StatelessWidget {
  const SekolahManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Data dummy sekolah
    final Map<String, String> sekolahInfo = {
      'nama': 'SD Negeri Harapan Bangsa',
      'alamat': 'Jl. Merdeka No. 45, Jakarta',
      'telepon': '(021) 888-1234',
      'email': 'info@harapanbangsa.sch.id',
      'jumlahSiswa': '320',
      'jumlahGuru': '25',
      'akreditasi': 'A',
    };

    final List<Map<String, String>> daftarGuru = [
      {'nama': 'Ibu Siti Nurhaliza', 'mapel': 'Matematika'},
      {'nama': 'Bapak Joko Santoso', 'mapel': 'Bahasa Indonesia'},
      {'nama': 'Ibu Rani Wulandari', 'mapel': 'IPA'},
      {'nama': 'Bapak Adi Pratama', 'mapel': 'Penjaskes'},
      {'nama': 'Ibu Maya Dewi', 'mapel': 'Bahasa Inggris'},
    ];

    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : Colors.grey[50],
      appBar: AppBar(
        backgroundColor: MBGColors.primary,
        title: const Text(
          'Manajemen Sekolah',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView( // ✅ Fix overflow di layar kecil
        padding: const EdgeInsets.all(MBGSizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ====== Profil Sekolah ======
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(MBGSizes.borderRadiusMd),
              ),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(MBGSizes.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Iconsax.buildings, color: MBGColors.primary, size: 28),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            sekolahInfo['nama'] ?? '',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      sekolahInfo['alamat'] ?? '',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: MBGSizes.sm),
                    Row(
                      children: [
                        const Icon(Iconsax.call, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          sekolahInfo['telepon'] ?? '',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(width: 12),
                        const Icon(Iconsax.sms, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            sekolahInfo['email'] ?? '',
                            style: Theme.of(context).textTheme.bodySmall,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: MBGSizes.md),

                    // ✅ Ganti Row dengan Wrap agar responsif
                    Wrap(
                      spacing: MBGSizes.sm,
                      runSpacing: MBGSizes.sm,
                      children: [
                        _buildInfoBadge(Iconsax.personalcard, 'Guru',
                            sekolahInfo['jumlahGuru'] ?? '0', Colors.orange),
                        _buildInfoBadge(Iconsax.profile_2user, 'Siswa',
                            sekolahInfo['jumlahSiswa'] ?? '0', MBGColors.success),
                        _buildInfoBadge(Iconsax.star, 'Akreditasi',
                            sekolahInfo['akreditasi'] ?? '-', Colors.blueAccent),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: MBGSizes.lg),

            // ====== Daftar Guru ======
            Text(
              'Daftar Guru',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: MBGSizes.sm),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(MBGSizes.borderRadiusMd),
              ),
              child: ListView.separated(
                itemCount: daftarGuru.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (context, index) =>
                    const Divider(height: 0, indent: 16, endIndent: 16),
                itemBuilder: (context, index) {
                  final guru = daftarGuru[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: MBGColors.primary.withOpacity(0.1),
                      child: const Icon(Iconsax.user, color: MBGColors.primary),
                    ),
                    title: Text(guru['nama'] ?? ''),
                    subtitle: Text('Mapel: ${guru['mapel'] ?? '-'}'),
                    trailing: IconButton(
                      icon: const Icon(Iconsax.edit, color: Colors.grey),
                      onPressed: () {},
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: MBGSizes.lg),

            // ====== Tombol Aksi ======
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Iconsax.add),
                    label: const Text('Tambah Guru'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MBGColors.primary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: MBGSizes.md),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Iconsax.setting),
                    label: const Text('Edit Info Sekolah'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Badge builder dibuat fleksibel untuk digunakan di dalam Wrap
  Widget _buildInfoBadge(
      IconData icon, String label, String value, Color color) {
    return Container(
      width: 110, // ✅ Lebar tetap agar muat di baris kecil
      padding: const EdgeInsets.all(MBGSizes.md),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(MBGSizes.borderRadiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}


// import 'package:flutter/material.dart';

// class SekolahManagementScreen extends StatelessWidget {
//   const SekolahManagementScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(Icons.school, size: 64, color: Colors.grey),
//             const SizedBox(height: 16),
//             Text(
//               'Sekolah Management',
//               style: Theme.of(context).textTheme.headlineSmall,
//             ),
//             const SizedBox(height: 8),
//             const Text('Manage school information'),
//           ],
//         ),
//       ),
//     );
//   }
// }
