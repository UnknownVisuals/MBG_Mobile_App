import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/http/dapur_service.dart';
import '../../../utils/popups/loaders.dart';
import '../../../utils/popups/full_screen_loader.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../common/widgets/appbar.dart';
import '../models/stok_model.dart';

class StokManagementScreen extends StatefulWidget {
  const StokManagementScreen({super.key});

  @override
  State<StokManagementScreen> createState() => _StokManagementScreenState();
}

class _StokManagementScreenState extends State<StokManagementScreen> {
  final DapurService _dapurService = Get.find<DapurService>();
  List<StokModel> _stokList = [];
  List<StokModel> _filteredStokList = [];
  bool _isLoading = true;
  String? _selectedCategory;

  final List<String> _categories = [
    'Semua',
    'SAYURAN',
    'BUAH',
    'PROTEIN',
    'KARBOHIDRAT',
    'LAINNYA',
  ];

  @override
  void initState() {
    super.initState();
    _loadStok();
  }

  Future<void> _loadStok() async {
    setState(() => _isLoading = true);
    try {
      final stok = await _dapurService.getAllStok();
      setState(() {
        _stokList = stok;
        _filteredStokList = stok;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      MBGLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  void _filterByCategory(String? category) {
    setState(() {
      _selectedCategory = category;
      if (category == null || category == 'Semua') {
        _filteredStokList = _stokList;
      } else {
        _filteredStokList = _stokList
            .where((s) => s.kategori == category)
            .toList();
      }
    });
  }

  Future<void> _showAddStokDialog() async {
    final namaController = TextEditingController();
    final stokKgController = TextEditingController();
    String selectedKategori = 'LAINNYA';

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Tambah Stok'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: namaController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Bahan',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedKategori,
                  decoration: const InputDecoration(
                    labelText: 'Kategori',
                    border: OutlineInputBorder(),
                  ),
                  items: _categories
                      .where((c) => c != 'Semua')
                      .map(
                        (cat) => DropdownMenuItem(value: cat, child: Text(cat)),
                      )
                      .toList(),
                  onChanged: (value) {
                    setDialogState(() {
                      selectedKategori = value!;
                    });
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: stokKgController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Stok (kg)',
                    border: OutlineInputBorder(),
                    suffixText: 'kg',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (namaController.text.isEmpty ||
                    stokKgController.text.isEmpty) {
                  MBGLoaders.warningSnackBar(
                    title: 'Peringatan',
                    message: 'Semua field harus diisi',
                  );
                  return;
                }

                final stokKg = double.tryParse(stokKgController.text);
                if (stokKg == null || stokKg <= 0) {
                  MBGLoaders.warningSnackBar(
                    title: 'Peringatan',
                    message: 'Stok harus berupa angka positif',
                  );
                  return;
                }

                Navigator.pop(context);
                MBGFullScreenLoader.openLoadingDialog(
                  'Menyimpan stok...',
                  MBGImages.onBoardingImage1,
                );

                try {
                  await _dapurService.createStok({
                    'nama': namaController.text,
                    'kategori': selectedKategori,
                    'stokKg': stokKg,
                  });
                  MBGFullScreenLoader.stopLoading();
                  MBGLoaders.successSnackBar(
                    title: 'Berhasil',
                    message: 'Stok berhasil ditambahkan',
                  );
                  _loadStok();
                } catch (e) {
                  MBGFullScreenLoader.stopLoading();
                  MBGLoaders.errorSnackBar(
                    title: 'Error',
                    message: e.toString(),
                  );
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showAdjustStokDialog(StokModel stok) async {
    final adjustmentController = TextEditingController();
    bool isAddition = true;

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Sesuaikan Stok: ${stok.nama}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Stok saat ini: ${stok.stokKg} kg',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<bool>(
                      title: const Text('Tambah'),
                      value: true,
                      groupValue: isAddition,
                      onChanged: (value) {
                        setDialogState(() {
                          isAddition = value!;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<bool>(
                      title: const Text('Kurang'),
                      value: false,
                      groupValue: isAddition,
                      onChanged: (value) {
                        setDialogState(() {
                          isAddition = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: adjustmentController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Jumlah Penyesuaian',
                  border: OutlineInputBorder(),
                  suffixText: 'kg',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (adjustmentController.text.isEmpty) {
                  MBGLoaders.warningSnackBar(
                    title: 'Peringatan',
                    message: 'Masukkan jumlah penyesuaian',
                  );
                  return;
                }

                final adjustment = double.tryParse(adjustmentController.text);
                if (adjustment == null || adjustment <= 0) {
                  MBGLoaders.warningSnackBar(
                    title: 'Peringatan',
                    message: 'Jumlah harus berupa angka positif',
                  );
                  return;
                }

                final finalAdjustment = isAddition ? adjustment : -adjustment;

                Navigator.pop(context);
                MBGFullScreenLoader.openLoadingDialog(
                  'Menyesuaikan stok...',
                  MBGImages.onBoardingImage1,
                );

                try {
                  await _dapurService.adjustStok(stok.id, finalAdjustment);
                  MBGFullScreenLoader.stopLoading();
                  MBGLoaders.successSnackBar(
                    title: 'Berhasil',
                    message: 'Stok berhasil disesuaikan',
                  );
                  _loadStok();
                } catch (e) {
                  MBGFullScreenLoader.stopLoading();
                  MBGLoaders.errorSnackBar(
                    title: 'Error',
                    message: e.toString(),
                  );
                }
              },
              child: const Text('Sesuaikan'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteStok(String id, String nama) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text('Apakah Anda yakin ingin menghapus stok "$nama"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      MBGFullScreenLoader.openLoadingDialog(
        'Menghapus stok...',
        MBGImages.onBoardingImage1,
      );
      try {
        await _dapurService.deleteStok(id);
        MBGFullScreenLoader.stopLoading();
        MBGLoaders.successSnackBar(
          title: 'Berhasil',
          message: 'Stok berhasil dihapus',
        );
        _loadStok();
      } catch (e) {
        MBGFullScreenLoader.stopLoading();
        MBGLoaders.errorSnackBar(title: 'Error', message: e.toString());
      }
    }
  }

  Color _getCategoryColor(String kategori) {
    switch (kategori) {
      case 'SAYURAN':
        return Colors.green;
      case 'BUAH':
        return Colors.orange;
      case 'PROTEIN':
        return Colors.red;
      case 'KARBOHIDRAT':
        return Colors.brown;
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String kategori) {
    switch (kategori) {
      case 'SAYURAN':
        return Icons.eco;
      case 'BUAH':
        return Icons.apple;
      case 'PROTEIN':
        return Icons.egg;
      case 'KARBOHIDRAT':
        return Icons.rice_bowl;
      default:
        return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MBGAppBar(
        title: const Text('Manajemen Stok'),
        showBackArrow: false,
      ),
      body: Column(
        children: [
          // Category Filter
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected =
                    _selectedCategory == category ||
                    (_selectedCategory == null && category == 'Semua');
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      _filterByCategory(category);
                    },
                  ),
                );
              },
            ),
          ),
          // Stock List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredStokList.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Belum ada stok',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tambahkan stok dengan tombol + di bawah',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _loadStok,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _filteredStokList.length,
                      itemBuilder: (context, index) {
                        final stok = _filteredStokList[index];
                        final categoryColor = _getCategoryColor(stok.kategori);
                        final categoryIcon = _getCategoryIcon(stok.kategori);
                        final isLowStock = stok.stokKg < 5;

                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: isLowStock
                                ? const BorderSide(color: Colors.red, width: 2)
                                : BorderSide.none,
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            leading: CircleAvatar(
                              backgroundColor: categoryColor.withOpacity(0.2),
                              child: Icon(categoryIcon, color: categoryColor),
                            ),
                            title: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    stok.nama,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                if (isLowStock)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Text(
                                      'STOK RENDAH',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8),
                                Text(
                                  stok.kategori,
                                  style: TextStyle(
                                    color: categoryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Stok: ${stok.stokKg} kg',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: isLowStock
                                        ? Colors.red
                                        : Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  color: Colors.blue,
                                  onPressed: () => _showAdjustStokDialog(stok),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  color: Colors.red,
                                  onPressed: () =>
                                      _deleteStok(stok.id, stok.nama),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddStokDialog,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Stok'),
      ),
    );
  }
}
