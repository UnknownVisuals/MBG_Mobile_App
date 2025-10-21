import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mbg_mobile_app/features/dapur/controllers/dapur_controller.dart';
import '../../../../utils/http/dapur_service.dart';
import '../../../../utils/popups/loaders.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../common/widgets/appbar.dart';
import '../../models/stok_model.dart';
import 'widgets/stok_no_dapur_selected_widget.dart';
import 'widgets/stok_content_widget.dart';

class StokManagementScreen extends StatefulWidget {
  const StokManagementScreen({super.key});

  @override
  State<StokManagementScreen> createState() => _StokManagementScreenState();
}

class _StokManagementScreenState extends State<StokManagementScreen> {
  final DapurService _dapurService = Get.find<DapurService>();
  late final DapurController _dapurController;
  Worker? _dapurWorker;
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
    _dapurController = Get.find<DapurController>();
    _dapurWorker = ever(_dapurController.selectedDapur, (_) => _loadStok());
    _loadStok();
  }

  @override
  void dispose() {
    _dapurWorker?.dispose();
    super.dispose();
  }

  Future<void> _loadStok() async {
    final selectedDapur = _dapurController.selectedDapur.value;

    if (selectedDapur == null) {
      if (!mounted) return;
      setState(() {
        _stokList = [];
        _filteredStokList = [];
        _isLoading = false;
      });
      return;
    }

    if (mounted) {
      setState(() => _isLoading = true);
    }
    try {
      final stok = await _dapurService.getStokByDapur(selectedDapur.id);
      if (!mounted) return;
      setState(() {
        _stokList = stok;
        _filteredStokList = stok;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
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
    final selectedDapur = _dapurController.selectedDapur.value;
    if (selectedDapur == null) {
      MBGLoaders.warningSnackBar(
        title: 'Peringatan',
        message: 'Silakan pilih dapur terlebih dahulu.',
      );
      return;
    }

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
                  initialValue: selectedKategori,
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
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
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
                    'dapurId': selectedDapur.id,
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
    final stokKgController = TextEditingController(
      text: stok.stokKg.toString(),
    );

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Sesuaikan Stok - ${stok.nama}'),
        content: TextField(
          controller: stokKgController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: 'Stok Baru (kg)',
            border: OutlineInputBorder(),
            suffixText: 'kg',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              final newStok = double.tryParse(stokKgController.text);
              if (newStok == null || newStok < 0) {
                MBGLoaders.warningSnackBar(
                  title: 'Peringatan',
                  message: 'Stok harus berupa angka positif',
                );
                return;
              }

              Navigator.pop(context);
              MBGFullScreenLoader.openLoadingDialog(
                'Menyimpan perubahan...',
                MBGImages.onBoardingImage1,
              );

              try {
                await _dapurService.adjustStok(stok.id, newStok - stok.stokKg);
                MBGFullScreenLoader.stopLoading();
                MBGLoaders.successSnackBar(
                  title: 'Berhasil',
                  message: 'Stok berhasil diperbarui',
                );
                _loadStok();
              } catch (e) {
                MBGFullScreenLoader.stopLoading();
                MBGLoaders.errorSnackBar(title: 'Error', message: e.toString());
              }
            },
            child: const Text('Simpan'),
          ),
        ],
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
        return Icons.grass;
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
    return Obx(() {
      final selectedDapur = _dapurController.selectedDapur.value;
      final isKitchenLoading = _dapurController.isDapurLoading.value;
      final errorMessage = _dapurController.dapurError.value;

      return Scaffold(
        appBar: MBGAppBar(
          title: Text(
            selectedDapur != null
                ? 'Manajemen Stok (${selectedDapur.nama})'
                : 'Manajemen Stok',
          ),
          showBackArrow: false,
        ),
        body: isKitchenLoading && selectedDapur == null
            ? const Center(child: CircularProgressIndicator())
            : selectedDapur == null
            ? StokNoDapurSelectedWidget(errorMessage: errorMessage)
            : StokContentWidget(
                categories: _categories,
                selectedCategory: _selectedCategory,
                filteredStokList: _filteredStokList,
                isLoading: _isLoading,
                onCategorySelected: _filterByCategory,
                onRefresh: _loadStok,
                onEdit: _showAdjustStokDialog,
                onDelete: _deleteStok,
                getCategoryColor: _getCategoryColor,
                getCategoryIcon: _getCategoryIcon,
              ),
        floatingActionButton: selectedDapur == null
            ? null
            : FloatingActionButton.extended(
                onPressed: _showAddStokDialog,
                icon: const Icon(Icons.add),
                label: const Text('Tambah Stok'),
              ),
      );
    });
  }
}
