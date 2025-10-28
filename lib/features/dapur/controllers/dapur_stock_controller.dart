import 'package:get/get.dart';
import 'package:mbg_mobile_app/features/dapur/controllers/dapur_controller.dart';
import 'package:mbg_mobile_app/features/dapur/models/dapur_model.dart';
import 'package:mbg_mobile_app/features/dapur/models/dapur_stok_model.dart';
import 'package:mbg_mobile_app/utils/http/http_client.dart';
import 'package:mbg_mobile_app/utils/popups/loaders.dart';

class DapurStockController extends GetxController {
  DapurStockController() : _httpHelper = Get.put(MBGHttpHelper());

  final MBGHttpHelper _httpHelper;
  late final DapurController _dapurController;

  // Data
  final RxList<StokModel> stokList = <StokModel>[].obs;
  final RxList<StokModel> filteredStokList = <StokModel>[].obs;

  // State
  final RxBool isLoading = false.obs;
  final RxBool isSaving = false.obs;
  final RxnString deletingStockId = RxnString();
  final RxnString adjustingStockId = RxnString();
  final Rxn<KategoriStok> selectedCategory = Rxn<KategoriStok>();

  List<KategoriStok> get kategoriOptions => KategoriStok.values;

  Worker? _dapurSubscription;

  @override
  void onInit() {
    super.onInit();
    _dapurController = Get.find<DapurController>();
    _dapurSubscription = ever<DapurModel?>(_dapurController.selectedDapur, (
      dapur,
    ) {
      if (dapur == null) {
        stokList.clear();
        filteredStokList.clear();
      } else {
        fetchStok(dapurId: dapur.id);
      }
    });

    final initialDapur = _dapurController.selectedDapur.value;
    if (initialDapur != null) {
      fetchStok(dapurId: initialDapur.id);
    }
  }

  @override
  void onClose() {
    _dapurSubscription?.dispose();
    super.onClose();
  }

  void selectCategory(KategoriStok? category) {
    selectedCategory.value = category;
    _applyFilter();
  }

  Future<void> fetchStok({String? dapurId}) async {
    final String? effectiveDapurId =
        dapurId ?? _dapurController.selectedDapur.value?.id;

    if (effectiveDapurId == null) {
      stokList.clear();
      filteredStokList.clear();
      return;
    }

    try {
      isLoading.value = true;
      MBGHttpHelper.loadSessionToken();

      final response = await _httpHelper.getRequest(
        'dapur/$effectiveDapurId/stok',
      );

      if (response.statusCode == 200) {
        final body = response.body;
        if (body is Map<String, dynamic> && body['success'] == true) {
          final dataWrapper = body['data'] as Map<String, dynamic>;
          final List<dynamic> dataList = dataWrapper['data'] as List<dynamic>;

          final items = dataList
              .map((json) => StokModel.fromJson(json as Map<String, dynamic>))
              .toList();

          stokList.assignAll(items);
          _applyFilter();
          return;
        }
      }

      throw Exception(response.body?['message'] ?? 'Gagal memuat stok dapur');
    } catch (e) {
      MBGLoaders.errorSnackBar(
        title: 'Gagal Memuat Stok',
        message: e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addStok({
    required String nama,
    required KategoriStok kategori,
    required double stokKg,
  }) async {
    final String? dapurId = _dapurController.selectedDapur.value?.id;
    if (dapurId == null) {
      MBGLoaders.warningSnackBar(
        title: 'Pilih Dapur',
        message: 'Silakan pilih dapur sebelum menambahkan stok.',
      );
      return;
    }

    try {
      isSaving.value = true;
      MBGHttpHelper.loadSessionToken();

      final response = await _httpHelper.postRequest('stok', {
        'nama': nama,
        'kategori': kategori.apiValue,
        'stokKg': stokKg,
        'dapurId': dapurId,
      });

      if (response.statusCode != 201) {
        throw Exception(response.body?['message'] ?? 'Gagal menambahkan stok');
      }

      final responseData = response.body;
      if (responseData == null || responseData['success'] != true) {
        throw Exception('Format respons tidak valid');
      }

      final StokModel newStok = StokModel.fromJson(
        responseData['data'] as Map<String, dynamic>,
      );

      stokList.insert(0, newStok);
      _applyFilter();

      MBGLoaders.successSnackBar(
        title: 'Stok Ditambahkan',
        message: 'Data stok baru berhasil ditambahkan.',
      );

      await Future.delayed(const Duration(milliseconds: 300));
      Get.back(closeOverlays: true);
    } catch (e) {
      MBGLoaders.errorSnackBar(
        title: 'Gagal Menambahkan Stok',
        message: e.toString(),
      );
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> updateStok({
    required String stokId,
    required String nama,
    required KategoriStok kategori,
    required double stokKg,
  }) async {
    try {
      isSaving.value = true;
      MBGHttpHelper.loadSessionToken();

      final response = await _httpHelper.putRequest('stok/$stokId', {
        'nama': nama,
        'kategori': kategori.apiValue,
        'stokKg': stokKg,
      });

      if (response.statusCode != 200) {
        throw Exception(response.body?['message'] ?? 'Gagal memperbarui stok');
      }

      final responseData = response.body;
      if (responseData == null || responseData['success'] != true) {
        throw Exception('Format respons tidak valid');
      }

      final updatedStok = StokModel.fromJson(
        responseData['data'] as Map<String, dynamic>,
      );
      _replaceStok(updatedStok);

      MBGLoaders.successSnackBar(
        title: 'Stok Diperbarui',
        message: 'Data stok berhasil diperbarui.',
      );

      await Future.delayed(const Duration(milliseconds: 300));
      Get.back(closeOverlays: true);
    } catch (e) {
      MBGLoaders.errorSnackBar(
        title: 'Gagal Memperbarui Stok',
        message: e.toString(),
      );
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> adjustStok({
    required String stokId,
    required double adjustment,
  }) async {
    if (adjustment == 0) {
      MBGLoaders.warningSnackBar(
        title: 'Penyesuaian Tidak Valid',
        message: 'Nilai penyesuaian tidak boleh nol.',
      );
      return;
    }

    try {
      adjustingStockId.value = stokId;
      MBGHttpHelper.loadSessionToken();

      final response = await _httpHelper.patchRequest('stok/$stokId/adjust', {
        'adjustment': adjustment,
      });

      if (response.statusCode != 200) {
        throw Exception(response.body?['message'] ?? 'Gagal menyesuaikan stok');
      }

      final responseData = response.body;
      if (responseData == null || responseData['success'] != true) {
        throw Exception('Format respons tidak valid');
      }

      final adjustedStok = StokModel.fromJson(
        responseData['data'] as Map<String, dynamic>,
      );
      _replaceStok(adjustedStok);

      MBGLoaders.successSnackBar(
        title: 'Stok Disesuaikan',
        message: 'Penyesuaian stok berhasil disimpan.',
      );
    } catch (e) {
      MBGLoaders.errorSnackBar(
        title: 'Gagal Menyesuaikan Stok',
        message: e.toString(),
      );
    } finally {
      adjustingStockId.value = null;
    }
  }

  Future<void> deleteStok(String stokId) async {
    try {
      deletingStockId.value = stokId;
      MBGHttpHelper.loadSessionToken();

      final response = await _httpHelper.deleteRequest('stok/$stokId');

      if (response.statusCode != 200) {
        throw Exception(response.body?['message'] ?? 'Gagal menghapus stok');
      }

      stokList.removeWhere((stok) => stok.id == stokId);
      _applyFilter();

      MBGLoaders.successSnackBar(
        title: 'Stok Dihapus',
        message: 'Data stok berhasil dihapus.',
      );
    } catch (e) {
      MBGLoaders.errorSnackBar(
        title: 'Gagal Menghapus Stok',
        message: e.toString(),
      );
    } finally {
      deletingStockId.value = null;
    }
  }

  void _applyFilter() {
    final KategoriStok? category = selectedCategory.value;
    if (category == null) {
      filteredStokList.assignAll(stokList);
      return;
    }

    filteredStokList.assignAll(
      stokList.where((stok) => stok.kategori == category).toList(),
    );
  }

  void _replaceStok(StokModel updatedStok) {
    final int index = stokList.indexWhere((stok) => stok.id == updatedStok.id);
    if (index != -1) {
      stokList[index] = updatedStok;
      stokList.refresh();
      _applyFilter();
    }
  }
}
