import 'dart:io';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:mbg_mobile_app/features/dapur/models/checkpoint_model.dart';
import 'package:mbg_mobile_app/features/dapur/models/dapur_model.dart';
import 'package:mbg_mobile_app/features/dapur/models/dapur_karyawan_model.dart';
import 'package:mbg_mobile_app/features/dapur/models/menu_harian_model.dart';
import 'package:mbg_mobile_app/features/dapur/models/menu_planning_model.dart';
import 'package:mbg_mobile_app/features/dapur/models/pengiriman_model.dart';
import 'package:mbg_mobile_app/features/dapur/models/dapur_stok_model.dart';
import 'package:mbg_mobile_app/features/dapur/models/kalender_akademik_model.dart';
import 'package:mbg_mobile_app/utils/http/http_client.dart';
import 'package:http/http.dart' as http;

class DapurService extends GetxService {
  final MBGHttpHelper _httpHelper = Get.find<MBGHttpHelper>();

  // ==================== DAPUR ====================

  Future<List<DapurModel>> getAllDapur() async {
    final response = await _httpHelper.getRequest('dapur');
    if (response.statusCode == 200 && response.body['success'] == true) {
      // API returns paginated response: {success, data: {data: [], pagination: {}}}
      final dataWrapper = response.body['data'];
      final List data = dataWrapper['data'];
      return data.map((json) => DapurModel.fromJson(json)).toList();
    }
    throw Exception('Failed to load dapur');
  }

  Future<DapurModel> getDapurById(String id) async {
    final response = await _httpHelper.getRequest('dapur/$id');
    if (response.statusCode == 200 && response.body['success'] == true) {
      return DapurModel.fromJson(response.body['data']);
    }
    throw Exception('Failed to load dapur');
  }

  Future<DapurModel> createDapur(Map<String, dynamic> data) async {
    final response = await _httpHelper.postRequest('dapur', data);
    if (response.statusCode == 201 && response.body['success'] == true) {
      return DapurModel.fromJson(response.body['data']);
    }
    throw Exception('Failed to create dapur');
  }

  Future<DapurModel> updateDapur(String id, Map<String, dynamic> data) async {
    final response = await _httpHelper.putRequest('dapur/$id', data);
    if (response.statusCode == 200 && response.body['success'] == true) {
      return DapurModel.fromJson(response.body['data']);
    }
    throw Exception('Failed to update dapur');
  }

  Future<void> deleteDapur(String id) async {
    final response = await _httpHelper.deleteRequest('dapur/$id');
    if (response.statusCode != 200) {
      throw Exception('Failed to delete dapur');
    }
  }

  // ==================== KARYAWAN ====================

  Future<List<KaryawanModel>> getAllKaryawan() async {
    final response = await _httpHelper.getRequest('karyawan');
    if (response.statusCode == 200 && response.body['success'] == true) {
      // API returns paginated response: {success, data: {data: [], pagination: {}}}
      final dataWrapper = response.body['data'];
      final List data = dataWrapper['data'];
      return data.map((json) => KaryawanModel.fromJson(json)).toList();
    }
    throw Exception('Failed to load karyawan');
  }

  Future<List<KaryawanModel>> getKaryawanByDapur(String dapurId) async {
    final response = await _httpHelper.getRequest('dapur/$dapurId/karyawan');
    if (response.statusCode == 200 && response.body['success'] == true) {
      // API returns paginated response: {success, data: {data: [], pagination: {}}}
      final dataWrapper = response.body['data'];
      final List data = dataWrapper['data'];
      return data.map((json) => KaryawanModel.fromJson(json)).toList();
    }
    throw Exception('Failed to load karyawan');
  }

  Future<KaryawanModel> createKaryawan({
    required String dapurId,
    required String nama,
    required String posisi,
    File? foto,
  }) async {
    // First upload image if provided
    String? fotoUrl;
    if (foto != null) {
      fotoUrl = await uploadImage(foto);
    }

    final response = await _httpHelper.postRequest('dapur/$dapurId/karyawan', {
      'nama': nama,
      'posisi': posisi,
      if (fotoUrl != null) 'foto': fotoUrl,
    });

    if (response.statusCode == 201 && response.body['success'] == true) {
      return KaryawanModel.fromJson(response.body['data']);
    }
    throw Exception('Failed to create karyawan');
  }

  Future<void> deleteKaryawan(String id) async {
    final response = await _httpHelper.deleteRequest('karyawan/$id');
    if (response.statusCode != 200) {
      throw Exception('Failed to delete karyawan');
    }
  }

  // ==================== STOK ====================

  Future<List<StokModel>> getAllStok() async {
    final response = await _httpHelper.getRequest('stok');
    if (response.statusCode == 200 && response.body['success'] == true) {
      // API returns paginated response: {success, data: {data: [], pagination: {}}}
      final dataWrapper = response.body['data'];
      final List data = dataWrapper['data'];
      return data.map((json) => StokModel.fromJson(json)).toList();
    }
    throw Exception('Failed to load stok');
  }

  Future<List<StokModel>> getStokByDapur(String dapurId) async {
    final response = await _httpHelper.getRequest('dapur/$dapurId/stok');
    if (response.statusCode == 200 && response.body['success'] == true) {
      // API returns paginated response: {success, data: {data: [], pagination: {}}}
      final dataWrapper = response.body['data'];
      final List data = dataWrapper['data'];
      return data.map((json) => StokModel.fromJson(json)).toList();
    }
    throw Exception('Failed to load stok');
  }

  Future<StokModel> createStok(Map<String, dynamic> data) async {
    final response = await _httpHelper.postRequest('stok', data);
    if (response.statusCode == 201 && response.body['success'] == true) {
      return StokModel.fromJson(response.body['data']);
    }
    throw Exception('Failed to create stok');
  }

  Future<StokModel> adjustStok(String id, double adjustment) async {
    final response = await _httpHelper.patchRequest('stok/$id/adjust', {
      'adjustment': adjustment,
    });
    if (response.statusCode == 200 && response.body['success'] == true) {
      return StokModel.fromJson(response.body['data']);
    }
    throw Exception('Failed to adjust stok');
  }

  Future<void> deleteStok(String id) async {
    final response = await _httpHelper.deleteRequest('stok/$id');
    if (response.statusCode != 200) {
      throw Exception('Failed to delete stok');
    }
  }

  // ==================== MENU PLANNING ====================

  Future<List<MenuPlanningModel>> getAllMenuPlanning() async {
    final response = await _httpHelper.getRequest('menu-planning');
    if (response.statusCode == 200 && response.body['success'] == true) {
      // API returns paginated response: {success, data: {data: [], pagination: {}}}
      final dataWrapper = response.body['data'];
      final List data = dataWrapper['data'];
      return data.map((json) => MenuPlanningModel.fromJson(json)).toList();
    }
    throw Exception('Failed to load menu planning');
  }

  Future<MenuPlanningModel> createMenuPlanning(
    Map<String, dynamic> data,
  ) async {
    final response = await _httpHelper.postRequest('menu-planning', data);
    if (response.statusCode == 201 && response.body['success'] == true) {
      return MenuPlanningModel.fromJson(response.body['data']);
    }
    throw Exception('Failed to create menu planning');
  }

  Future<List<MenuHarianModel>> getMenuHarianByPlanning(
    String planningId,
  ) async {
    final response = await _httpHelper.getRequest(
      'menu-planning/$planningId/menu-harian',
    );
    if (response.statusCode == 200 && response.body['success'] == true) {
      // API returns paginated response: {success, data: {data: [], pagination: {}}}
      final dataWrapper = response.body['data'];
      final List data = dataWrapper['data'];
      return data.map((json) => MenuHarianModel.fromJson(json)).toList();
    }
    throw Exception('Failed to load menu harian');
  }

  Future<MenuHarianModel> createMenuHarian(
    String planningId,
    Map<String, dynamic> data,
  ) async {
    final response = await _httpHelper.postRequest(
      'menu-planning/$planningId/menu-harian',
      data,
    );
    if (response.statusCode == 201 && response.body['success'] == true) {
      return MenuHarianModel.fromJson(response.body['data']);
    }
    throw Exception('Failed to create menu harian');
  }

  // ==================== CHECKPOINT ====================

  Future<List<CheckpointModel>> getCheckpointsByMenuHarian(
    String menuHarianId,
  ) async {
    final response = await _httpHelper.getRequest(
      'menu-harian/$menuHarianId/checkpoint',
    );
    if (response.statusCode == 200 && response.body['success'] == true) {
      // API returns paginated response: {success, data: {data: [], pagination: {}}}
      final dataWrapper = response.body['data'];
      final List data = dataWrapper['data'];
      return data.map((json) => CheckpointModel.fromJson(json)).toList();
    }
    throw Exception('Failed to load checkpoints');
  }

  Future<CheckpointModel> createCheckpoint({
    required String menuHarianId,
    required String tipe,
    File? foto,
  }) async {
    // Upload image if provided
    String? fotoUrl;
    if (foto != null) {
      fotoUrl = await uploadImage(foto);
    }

    final response = await _httpHelper.postRequest(
      'menu-harian/$menuHarianId/checkpoint',
      {'tipe': tipe, if (fotoUrl != null) 'foto': fotoUrl},
    );

    if (response.statusCode == 201 && response.body['success'] == true) {
      return CheckpointModel.fromJson(response.body['data']);
    }
    throw Exception('Failed to create checkpoint');
  }

  // ==================== PENGIRIMAN ====================

  Future<List<PengirimanModel>> getAllPengiriman({
    String? dapurId,
    String? status,
  }) async {
    var endpoint = 'pengiriman';
    final queryParameters = <String, String>{};

    if (dapurId != null && dapurId.isNotEmpty) {
      queryParameters['dapurId'] = dapurId;
    }

    if (status != null && status.isNotEmpty) {
      queryParameters['status'] = status;
    }

    if (queryParameters.isNotEmpty) {
      final query = Uri(queryParameters: queryParameters).query;
      endpoint = '$endpoint?$query';
    }

    final response = await _httpHelper.getRequest(endpoint);
    if (response.statusCode == 200 && response.body['success'] == true) {
      // API returns paginated response: {success, data: {data: [], pagination: {}}}
      final dataWrapper = response.body['data'];
      final List data = dataWrapper['data'];
      return data.map((json) => PengirimanModel.fromJson(json)).toList();
    }
    return [];
  }

  Future<PengirimanModel> createPengiriman(Map<String, dynamic> data) async {
    final response = await _httpHelper.postRequest('pengiriman', data);
    if (response.statusCode == 201 && response.body['success'] == true) {
      return PengirimanModel.fromJson(response.body['data']);
    }
    throw Exception('Failed to create pengiriman');
  }

  Future<PengirimanModel> getPengirimanById(String id) async {
    final response = await _httpHelper.getRequest('pengiriman/$id');
    if (response.statusCode == 200 && response.body['success'] == true) {
      return PengirimanModel.fromJson(response.body['data']);
    }
    throw Exception('Failed to load pengiriman');
  }

  Future<void> deletePengiriman(String id) async {
    final response = await _httpHelper.deleteRequest('pengiriman/$id');
    if (response.statusCode != 200) {
      throw Exception('Failed to delete pengiriman');
    }
  }

  // ==================== HELPER ====================

  Future<String> uploadImage(File image) async {
    try {
      final baseUrl = MBGHttpHelper.getBaseUrl();
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/upload/image'),
      );

      // Add authorization header
      final token = MBGHttpHelper.getSessionToken();
      if (token.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      // Add file
      request.files.add(await http.MultipartFile.fromPath('image', image.path));

      // Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        // Parse JSON response to extract image URL from {success, data} wrapper
        final Map<String, dynamic> responseData =
            jsonDecode(response.body) as Map<String, dynamic>;

        if (responseData['success'] == true) {
          return responseData['data'] as String;
        }
        throw Exception(responseData['message'] ?? 'Failed to upload image');
      }

      throw Exception('Failed to upload image');
    } catch (e) {
      throw Exception('Error uploading image: $e');
    }
  }

  // ==================== KALENDER AKADEMIK ====================

  Future<List<KalenderAkademikModel>> getAllKalenderAkademik() async {
    final response = await _httpHelper.getRequest('kalender-akademik');
    if (response.statusCode == 200 && response.body['success'] == true) {
      // API returns paginated response: {success, data: {data: [], pagination: {}}}
      final dataWrapper = response.body['data'];
      final List data = dataWrapper['data'];
      return data.map((json) => KalenderAkademikModel.fromJson(json)).toList();
    }
    return [];
  }

  Future<KalenderAkademikModel> createKalenderAkademik(
    Map<String, dynamic> data,
  ) async {
    final response = await _httpHelper.postRequest('kalender-akademik', data);
    if (response.statusCode == 201 && response.body['success'] == true) {
      return KalenderAkademikModel.fromJson(response.body['data']);
    }
    throw Exception('Failed to create kalender akademik');
  }

  Future<KalenderAkademikModel> updateKalenderAkademik(
    String id,
    Map<String, dynamic> data,
  ) async {
    final response = await _httpHelper.putRequest(
      'kalender-akademik/$id',
      data,
    );
    if (response.statusCode == 200 && response.body['success'] == true) {
      return KalenderAkademikModel.fromJson(response.body['data']);
    }
    throw Exception('Failed to update kalender akademik');
  }

  Future<void> deleteKalenderAkademik(String id) async {
    final response = await _httpHelper.deleteRequest('kalender-akademik/$id');
    if (response.statusCode != 200) {
      throw Exception('Failed to delete kalender akademik');
    }
  }

  Future<bool> checkHoliday(String date) async {
    final response = await _httpHelper.getRequest(
      'kalender-akademik/check-holiday?tanggal=$date',
    );
    if (response.statusCode == 200 && response.body['success'] == true) {
      return response.body['data']['isHoliday'] ?? false;
    }
    return false;
  }
}
