import 'package:flutter/material.dart';
import '../../../models/sekolah_siswa_model.dart';

/// Card widget displaying student information
class SiswaCardWidget extends StatelessWidget {
  final SekolahSiswaModel siswa;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const SiswaCardWidget({
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

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundImage: siswa.fotoUrl != null
              ? NetworkImage(siswa.fotoUrl!)
              : null,
          child: siswa.fotoUrl == null ? Text(siswa.nama[0]) : null,
        ),
        title: Text(
          siswa.nama,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('NIS: ${siswa.nis}'),
            const SizedBox(height: 4),
            Row(
              children: [
                Text('IMT: ${siswa.imt.toStringAsFixed(1)}'),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusGiziColor(
                      siswa.statusGizi,
                    ).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _getStatusGiziLabel(siswa.statusGizi),
                    style: TextStyle(
                      color: _getStatusGiziColor(siswa.statusGizi),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '${siswa.umur} tahun • ${siswa.tinggiBadan} cm • ${siswa.beratBadan} kg',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        isThreeLine: true,
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
