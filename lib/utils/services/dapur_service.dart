import 'dart:io';

import 'package:get/get.dart';
import 'package:mbg_mobile_app/features/dapur/models/dapur_checkpoint_model.dart';
import 'package:mbg_mobile_app/features/dapur/models/dapur_info_model.dart';
import 'package:mbg_mobile_app/features/dapur/models/dapur_karyawan_model.dart';
import 'package:mbg_mobile_app/features/dapur/models/dapur_menu_harian_model.dart';
import 'package:mbg_mobile_app/features/dapur/models/dapur_menu_planning_model.dart';
import 'package:mbg_mobile_app/features/dapur/models/dapur_pengiriman_model.dart';
import 'package:mbg_mobile_app/features/dapur/models/dapur_sekolah_model.dart';
import 'package:mbg_mobile_app/features/dapur/models/dapur_stock_model.dart';
import 'package:mbg_mobile_app/utils/http/http_client.dart';

class DapurService extends GetxService {
  DapurService({MBGHttpHelper? httpHelper})
    : _httpHelper = httpHelper ?? Get.find<MBGHttpHelper>();

  final MBGHttpHelper _httpHelper;

  // ==========================================
  //              HELPER METHODS
  // ==========================================

  // Check if response is success
  bool _isSuccess(Response<dynamic> response) {
    if (response.statusCode != null) {
      final code = response.statusCode!;
      if (code < 200 || code >= 300) {
        return false;
      }
    }

    final body = response.body;
    if (body is Map<String, dynamic>) {
      final success = body['success'];
      if (success is bool) {
        return success;
      }
    }
    return true;
  }

  // Extract response message
  String _responseMessage(Response<dynamic> response, String fallback) {
    final body = response.body;
    if (body is Map<String, dynamic>) {
      final message = body['message'];
      if (message is String && message.isNotEmpty) {
        return message;
      }
    }
    return fallback;
  }

  // Extract data list from response
  List<Map<String, dynamic>> _extractDataList(Response<dynamic> response) {
    final body = response.body;

    if (body is Map<String, dynamic>) {
      final data = body['data'];
      if (data is List) {
        return data.whereType<Map<String, dynamic>>().toList();
      }
      if (data is Map<String, dynamic>) {
        final inner = data['data'];
        if (inner is List) {
          return inner.whereType<Map<String, dynamic>>().toList();
        }
      }
    }

    throw Exception('Format data tidak valid');
  }

  // Extract data object from response
  Map<String, dynamic> _extractDataObject(Response<dynamic> response) {
    final body = response.body;
    if (body is Map<String, dynamic>) {
      final data = body['data'];
      if (data is Map<String, dynamic>) {
        final inner = data['data'];
        if (inner is Map<String, dynamic>) {
          return inner;
        }
        return data;
      }
    }
    throw Exception('Format data tidak valid');
  }

  // ========================
  // DAPUR MANAGEMENT - DAPUR
  // ========================

  // Get Dapur by ID
  Future<DapurInfoModel> getDapurById(String id) async {
    MBGHttpHelper.loadSessionToken();
    final response = await _httpHelper.getRequest('dapur/$id');

    if (!_isSuccess(response)) {
      throw Exception(_responseMessage(response, 'Gagal memuat data dapur.'));
    }

    final data = _extractDataObject(response);
    return DapurInfoModel.fromJson(data);
  }

  // ===========================
  // DAPUR MANAGEMENT - KARYAWAN
  // ===========================

  // Create Karyawan
  Future<DapurKaryawanModel> createKaryawan({
    required String nama,
    required String posisi,
    required String jenisKelamin,
    required int umur,
    File? foto,
    String? status,
    String? dapurId,
  }) async {
    MBGHttpHelper.loadSessionToken();
    final payload = <String, dynamic>{
      'nama': nama,
      'posisi': posisi,
      'jenisKelamin': jenisKelamin,
      'umur': umur,
      if (status != null) 'status': status,
      if (dapurId != null) 'dapurId': dapurId,
    };

    Response response;

    if (foto != null) {
      response = await _httpHelper.postMultipartRequest(
        'karyawan',
        fields: payload,
        file: foto,
        fileFieldName: 'foto',
      );
    } else {
      response = await _httpHelper.postRequest('karyawan', payload);
    }

    if (response.statusCode != 201 || !_isSuccess(response)) {
      throw Exception(_responseMessage(response, 'Gagal membuat karyawan'));
    }

    final data = _extractDataObject(response);
    return DapurKaryawanModel.fromJson(data);
  }

  // Get All Karyawan by Dapur
  Future<List<DapurKaryawanModel>> getAllKaryawanByDapur(String dapurId) async {
    MBGHttpHelper.loadSessionToken();
    final response = await _httpHelper.getRequest('dapur/$dapurId/karyawan');

    if (!_isSuccess(response)) {
      throw Exception(_responseMessage(response, 'Gagal memuat data karyawan'));
    }

    final data = _extractDataList(response);
    return data.map(DapurKaryawanModel.fromJson).toList();
  }

  // // Get Karyawan by ID
  // Future<DapurKaryawanModel> getKaryawanById(String karyawanId) async {
  //   MBGHttpHelper.loadSessionToken();
  //   final response = await _httpHelper.getRequest('karyawan/$karyawanId');

  //   if (!_isSuccess(response)) {
  //     throw Exception(_responseMessage(response, 'Gagal memuat data karyawan'));
  //   }

  //   final data = _extractDataObject(response);
  //   return DapurKaryawanModel.fromJson(data);
  // }

  // Update Karyawan
  Future<DapurKaryawanModel> updateKaryawan({
    required String karyawanId,
    String? nama,
    String? posisi,
    KaryawanStatus? status,
    JenisKelamin? jenisKelamin,
    int? umur,
    File? foto,
  }) async {
    MBGHttpHelper.loadSessionToken();
    final payload = <String, dynamic>{
      if (nama != null) 'nama': nama,
      if (posisi != null) 'posisi': posisi,
      if (status != null) 'status': status.name,
      if (jenisKelamin != null) 'jenisKelamin': jenisKelamin.name,
      if (umur != null) 'umur': umur,
    };

    if (payload.isEmpty && foto == null) {
      throw Exception('Tidak ada data yang diperbarui');
    }

    Response response;

    if (foto != null) {
      response = await _httpHelper.postMultipartRequest(
        'karyawan/$karyawanId',
        fields: payload.isEmpty ? null : payload,
        file: foto,
        fileFieldName: 'foto',
        isPutMethod: true,
      );
    } else {
      response = await _httpHelper.putRequest('karyawan/$karyawanId', payload);
    }

    if (!_isSuccess(response)) {
      throw Exception(_responseMessage(response, 'Gagal memperbarui karyawan'));
    }

    final data = _extractDataObject(response);
    return DapurKaryawanModel.fromJson(data);
  }

  // Delete Karyawan
  Future<void> deleteKaryawan(String karyawanId) async {
    MBGHttpHelper.loadSessionToken();
    final response = await _httpHelper.deleteRequest('karyawan/$karyawanId');

    if (!_isSuccess(response)) {
      throw Exception(_responseMessage(response, 'Gagal menghapus karyawan'));
    }
  }

  // ==========
  // DAPUR STOK
  // ==========

  // Create Stok
  Future<DapurStokModel> createStok(Map<String, dynamic> payload) async {
    MBGHttpHelper.loadSessionToken();
    final response = await _httpHelper.postRequest('stok', payload);

    if (response.statusCode != 201 || !_isSuccess(response)) {
      throw Exception(_responseMessage(response, 'Gagal membuat stok'));
    }

    final data = _extractDataObject(response);
    return DapurStokModel.fromJson(data);
  }

  // Get All Stok by Dapur
  Future<List<DapurStokModel>> getAllStok({required String dapurId}) async {
    MBGHttpHelper.loadSessionToken();
    final response = await _httpHelper.getRequest('dapur/$dapurId/stok');

    if (!_isSuccess(response)) {
      throw Exception(_responseMessage(response, 'Gagal memuat stok'));
    }

    final data = _extractDataList(response);
    return data.map(DapurStokModel.fromJson).toList();
  }

  // // Get Stok by ID
  // Future<DapurStokModel> getStokById(String stokId) async {
  //   MBGHttpHelper.loadSessionToken();
  //   final response = await _httpHelper.getRequest('stok/$stokId');

  //   if (!_isSuccess(response)) {
  //     throw Exception(_responseMessage(response, 'Gagal memuat stok'));
  //   }

  //   final data = _extractDataObject(response);
  //   return DapurStokModel.fromJson(data);
  // }

  // Update Stok
  Future<DapurStokModel> updateStok(
    String stokId,
    Map<String, dynamic> payload,
  ) async {
    MBGHttpHelper.loadSessionToken();
    final response = await _httpHelper.putRequest('stok/$stokId', payload);

    if (!_isSuccess(response)) {
      throw Exception(_responseMessage(response, 'Gagal memperbarui stok'));
    }

    final data = _extractDataObject(response);
    return DapurStokModel.fromJson(data);
  }

  // Delete Stok
  Future<void> deleteStok(String stokId) async {
    MBGHttpHelper.loadSessionToken();
    final response = await _httpHelper.deleteRequest('stok/$stokId');

    if (!_isSuccess(response)) {
      throw Exception(_responseMessage(response, 'Gagal menghapus stok'));
    }
  }

  // Adjust Stok
  Future<DapurStokModel> adjustStok(String stokId, double adjustment) async {
    MBGHttpHelper.loadSessionToken();
    final response = await _httpHelper.patchRequest('stok/$stokId/adjust', {
      'adjustment': adjustment,
    });

    if (!_isSuccess(response)) {
      throw Exception(_responseMessage(response, 'Gagal menyesuaikan stok'));
    }

    final data = _extractDataObject(response);
    return DapurStokModel.fromJson(data);
  }

  // ===========================
  // MENU PLANNING & MENU HARIAN
  // ===========================

  // Create Menu Planning
  Future<DapurMenuPlanningModel> createMenuPlanning(
    Map<String, dynamic> payload,
  ) async {
    MBGHttpHelper.loadSessionToken();
    final response = await _httpHelper.postRequest('menu-planning', payload);

    if (!_isSuccess(response)) {
      throw Exception(
        _responseMessage(response, 'Gagal membuat menu planning'),
      );
    }

    final data = _extractDataObject(response);
    return DapurMenuPlanningModel.fromJson(data);
  }

  // Get All Menu Planning
  Future<List<DapurMenuPlanningModel>> getAllMenuPlanning() async {
    MBGHttpHelper.loadSessionToken();
    final response = await _httpHelper.getRequest('menu-planning');

    if (!_isSuccess(response)) {
      throw Exception(_responseMessage(response, 'Gagal memuat menu planning'));
    }

    final data = _extractDataList(response);
    return data.map(DapurMenuPlanningModel.fromJson).toList();
  }

  Future<List<DapurSekolahModel>> getAllSekolah() async {
    MBGHttpHelper.loadSessionToken();
    final response = await _httpHelper.getRequest('sekolah');

    if (!_isSuccess(response)) {
      throw Exception(_responseMessage(response, 'Gagal memuat data sekolah'));
    }

    final data = _extractDataList(response);
    return data.map(DapurSekolahModel.fromJson).toList();
  }

  // Get Menu Planning by Sekolah ID
  Future<List<DapurMenuPlanningModel>> getMenuPlanningBySekolahId(
    String sekolahId,
  ) async {
    MBGHttpHelper.loadSessionToken();
    final response = await _httpHelper.getRequest(
      'sekolah/$sekolahId/menu-planning',
    );

    if (!_isSuccess(response)) {
      throw Exception(_responseMessage(response, 'Gagal memuat menu planning'));
    }

    final data = _extractDataList(response);
    return data.map(DapurMenuPlanningModel.fromJson).toList();
  }

  // Get Menu Harian by Planning
  Future<List<DapurMenuHarianModel>> getMenuHarianByPlanning(
    String planningId,
  ) async {
    MBGHttpHelper.loadSessionToken();
    final response = await _httpHelper.getRequest(
      'menu-planning/$planningId/menu-harian',
    );

    if (!_isSuccess(response)) {
      throw Exception(_responseMessage(response, 'Gagal memuat menu harian'));
    }

    final data = _extractDataList(response);
    return data.map(DapurMenuHarianModel.fromJson).toList();
  }

  // Update Menu Planning
  Future<DapurMenuPlanningModel> updateMenuPlanning(
    String planningId,
    Map<String, dynamic> payload,
  ) async {
    MBGHttpHelper.loadSessionToken();
    final response = await _httpHelper.putRequest(
      'menu-planning/$planningId',
      payload,
    );

    if (!_isSuccess(response)) {
      throw Exception(
        _responseMessage(response, 'Gagal memperbarui '),
      );
    }

    final data = _extractDataObject(response);
    return DapurMenuPlanningModel.fromJson(data);
  }

  // Delete Menu Planning
  Future<void> deleteMenuPlanning(String planningId) async {
    MBGHttpHelper.loadSessionToken();
    final response = await _httpHelper.deleteRequest(
      'menu-planning/$planningId',
    );

    if (!_isSuccess(response)) {
      throw Exception(
        _responseMessage(response, 'Gagal menghapus menu planning'),
      );
    }
  }

  // Create Menu Harian
  Future<DapurMenuHarianModel> createMenuHarian(
    String planningId,
    Map<String, dynamic> payload,
  ) async {
    MBGHttpHelper.loadSessionToken();
    final response = await _httpHelper.postRequest(
      'menu-planning/$planningId/menu-harian',
      payload,
    );

    if (response.statusCode != 201 || !_isSuccess(response)) {
      throw Exception(_responseMessage(response, 'Gagal membuat menu harian'));
    }

    final data = _extractDataObject(response);
    return DapurMenuHarianModel.fromJson(data);
  }

  // Get Menu Harian by Planning

  // Get Menu Harian by ID

  // Update Menu Harian
  Future<DapurMenuHarianModel> updateMenuHarian(
    String menuId,
    Map<String, dynamic> payload,
  ) async {
    MBGHttpHelper.loadSessionToken();
    final response = await _httpHelper.putRequest(
      'menu-harian/$menuId',
      payload,
    );

    if (!_isSuccess(response)) {
      throw Exception(
        _responseMessage(response, 'Gagal memperbarui menu harian'),
      );
    }

    final data = _extractDataObject(response);
    return DapurMenuHarianModel.fromJson(data);
  }

  // Delete Menu Harian
  Future<void> deleteMenuHarian(String menuId) async {
    MBGHttpHelper.loadSessionToken();
    final response = await _httpHelper.deleteRequest('menu-harian/$menuId');

    if (!_isSuccess(response)) {
      throw Exception(
        _responseMessage(response, 'Gagal menghapus menu harian'),
      );
    }
  }

  // ================
  // DAPUR CHECKPOINT
  // ================

  // Create Checkpoint
  Future<DapurCheckpointModel> createCheckpoint({
    required String menuHarianId,
    required String tipe,
    required File foto,
    String? deskripsi,
  }) async {
    MBGHttpHelper.loadSessionToken();

    final fields = <String, String>{'tipe': tipe};
    if (deskripsi != null && deskripsi.isNotEmpty) {
      fields['deskripsi'] = deskripsi;
    }

    final response = await _httpHelper.postMultipartRequest(
      'menu-harian/$menuHarianId/checkpoint',
      fields: fields,
      file: foto,
      fileFieldName: 'foto',
    );

    if (response.statusCode != 201 || !_isSuccess(response)) {
      throw Exception(_responseMessage(response, 'Gagal membuat checkpoint'));
    }

    final data = _extractDataObject(response);

    final model = DapurCheckpointModel.fromJson(data);

    return model;
  }

  // Get Checkpoints by Menu Harian
  Future<List<DapurCheckpointModel>> getCheckpointsByMenuHarian(
    String menuHarianId,
  ) async {
    MBGHttpHelper.loadSessionToken();
    final response = await _httpHelper.getRequest(
      'menu-harian/$menuHarianId/checkpoint',
    );

    if (!_isSuccess(response)) {
      throw Exception(_responseMessage(response, 'Gagal memuat checkpoint'));
    }

    final data = _extractDataList(response);
    return data.map(DapurCheckpointModel.fromJson).toList();
  }

  // Get Menu Harian by ID

  // Update Menu Harian

  // Delete Menu Harian

  // ====================
  // PENGIRIMAN & QR CODE
  // ====================

  // Create Pengiriman
  Future<DapurPengirimanModel> createPengiriman(
    Map<String, dynamic> payload,
  ) async {
    MBGHttpHelper.loadSessionToken();
    final response = await _httpHelper.postRequest('pengiriman', payload);

    if (response.statusCode != 201 || !_isSuccess(response)) {
      throw Exception(_responseMessage(response, 'Gagal membuat pengiriman'));
    }

    final data = _extractDataObject(response);
    return DapurPengirimanModel.fromJson(data);
  }

  Future<List<DapurPengirimanModel>> getPengirimanBySekolah(
    String sekolahId,
  ) async {
    MBGHttpHelper.loadSessionToken();
    final response = await _httpHelper.getRequest(
      'sekolah/$sekolahId/pengiriman',
    );

    if (!_isSuccess(response)) {
      throw Exception(
        _responseMessage(response, 'Gagal memuat data pengiriman'),
      );
    }

    final body = response.body;
    if (body is Map<String, dynamic>) {
      final data = body['data'];
      if (data is Map<String, dynamic>) {
        final items = data['data'];
        if (items is List) {
          return items
              .whereType<Map<String, dynamic>>()
              .map(DapurPengirimanModel.fromJson)
              .toList();
        }
      }
    }

    throw Exception('Format data pengiriman tidak valid');
  }

  // Get Pengiriman by ID
  Future<DapurPengirimanModel> getPengirimanById(String id) async {
    MBGHttpHelper.loadSessionToken();
    final response = await _httpHelper.getRequest('pengiriman/$id');

    if (!_isSuccess(response)) {
      throw Exception(_responseMessage(response, 'Gagal memuat pengiriman'));
    }

    final data = _extractDataObject(response);
    return DapurPengirimanModel.fromJson(data);
  }

  // Dalete Pengiriman
  Future<void> deletePengiriman(String id) async {
    MBGHttpHelper.loadSessionToken();
    final response = await _httpHelper.deleteRequest('pengiriman/$id');

    if (!_isSuccess(response)) {
      throw Exception(_responseMessage(response, 'Gagal menghapus pengiriman'));
    }
  }
}
