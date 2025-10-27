import 'dart:io';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:mbg_mobile_app/features/dapur/models/menu_planning_model.dart';
import 'package:mbg_mobile_app/features/dapur/models/pengiriman_model.dart';
import 'package:mbg_mobile_app/features/sekolah/models/absensi_model.dart';
import 'package:mbg_mobile_app/features/sekolah/models/alergi_model.dart';
import 'package:mbg_mobile_app/features/sekolah/models/kelas_model.dart';
import 'package:mbg_mobile_app/features/sekolah/models/sekolah_model.dart';
import 'package:mbg_mobile_app/features/sekolah/models/siswa_model.dart';
import 'package:mbg_mobile_app/utils/http/http_client.dart';
import 'package:http/http.dart' as http;

class SekolahService extends GetxService {
  final MBGHttpHelper _httpHelper = Get.find<MBGHttpHelper>();

  // ==================== SEKOLAH ====================

  Future<List<SekolahModel>> getAllSekolah() async {
    final response = await _httpHelper.getRequest('sekolah');
    if (response.statusCode == 200 && response.body['success'] == true) {
      // API returns paginated response: {success, data: {data: [], pagination: {}}}
      final dataWrapper = response.body['data'];
      final List data = dataWrapper['data'];
      return data.map((json) => SekolahModel.fromJson(json)).toList();
    }
    throw Exception('Failed to load sekolah');
  }

  Future<SekolahModel> getSekolahById(String id) async {
    final response = await _httpHelper.getRequest('sekolah/$id');
    if (response.statusCode == 200 && response.body['success'] == true) {
      return SekolahModel.fromJson(response.body['data']);
    }
    throw Exception('Failed to load sekolah');
  }

  Future<SekolahModel> updateSekolah(
    String id,
    Map<String, dynamic> data,
  ) async {
    final response = await _httpHelper.putRequest('sekolah/$id', data);
    if (response.statusCode == 200 && response.body['success'] == true) {
      return SekolahModel.fromJson(response.body['data']);
    }
    throw Exception('Failed to update sekolah');
  }

  // ==================== KELAS ====================

  Future<List<KelasModel>> getKelasBySekolah(String sekolahId) async {
    final response = await _httpHelper.getRequest('sekolah/$sekolahId/kelas');
    if (response.statusCode == 200 && response.body['success'] == true) {
      // API returns paginated response: {success, data: {data: [], pagination: {}}}
      final dataWrapper = response.body['data'];
      final List data = dataWrapper['data'];
      return data.map((json) => KelasModel.fromJson(json)).toList();
    }
    throw Exception('Failed to load kelas');
  }

  Future<KelasModel> createKelas(
    String sekolahId,
    Map<String, dynamic> data,
  ) async {
    final response = await _httpHelper.postRequest(
      'sekolah/$sekolahId/kelas',
      data,
    );
    if (response.statusCode == 201 && response.body['success'] == true) {
      return KelasModel.fromJson(response.body['data']);
    }
    throw Exception('Failed to create kelas');
  }

  Future<KelasModel> updateKelas(String id, Map<String, dynamic> data) async {
    final response = await _httpHelper.putRequest('kelas/$id', data);
    if (response.statusCode == 200 && response.body['success'] == true) {
      return KelasModel.fromJson(response.body['data']);
    }
    throw Exception('Failed to update kelas');
  }

  Future<void> deleteKelas(String id) async {
    final response = await _httpHelper.deleteRequest('kelas/$id');
    if (response.statusCode != 200) {
      throw Exception('Failed to delete kelas');
    }
  }

  // ==================== SISWA ====================

  Future<List<SiswaModel>> getSiswaBySekolah(String sekolahId) async {
    final response = await _httpHelper.getRequest('sekolah/$sekolahId/siswa');
    if (response.statusCode == 200 && response.body['success'] == true) {
      // API returns paginated response: {success, data: {data: [], pagination: {}}}
      final dataWrapper = response.body['data'];
      final List data = dataWrapper['data'];
      return data.map((json) => SiswaModel.fromJson(json)).toList();
    }
    throw Exception('Failed to load siswa');
  }

  Future<List<SiswaModel>> getSiswaByKelas(String kelasId) async {
    final response = await _httpHelper.getRequest('kelas/$kelasId/siswa');
    if (response.statusCode == 200 && response.body['success'] == true) {
      // API returns paginated response: {success, data: {data: [], pagination: {}}}
      final dataWrapper = response.body['data'];
      final List data = dataWrapper['data'];
      return data.map((json) => SiswaModel.fromJson(json)).toList();
    }
    throw Exception('Failed to load siswa');
  }

  Future<SiswaModel> createSiswa({
    required String sekolahId,
    required String nama,
    required String nis,
    required String kelasId,
    required String jenisKelamin,
    required int umur,
    required double tinggiBadan,
    required double beratBadan,
    File? foto,
  }) async {
    // Upload photo if provided
    String? fotoUrl;
    if (foto != null) {
      fotoUrl = await uploadImage(foto);
    }

    final response = await _httpHelper.postRequest('sekolah/$sekolahId/siswa', {
      'nama': nama,
      'nis': nis,
      'kelasId': kelasId,
      'jenisKelamin': jenisKelamin,
      'umur': umur,
      'tinggiBadan': tinggiBadan,
      'beratBadan': beratBadan,
      if (fotoUrl != null) 'foto': fotoUrl,
    });

    if (response.statusCode == 201 && response.body['success'] == true) {
      return SiswaModel.fromJson(response.body['data']);
    }
    throw Exception('Failed to create siswa');
  }

  Future<void> deleteSiswa(String id) async {
    final response = await _httpHelper.deleteRequest('siswa/$id');
    if (response.statusCode != 200) {
      throw Exception('Failed to delete siswa');
    }
  }

  // ==================== ALERGI ====================

  Future<List<AlergiModel>> getAlergiBySiswa(String siswaId) async {
    final response = await _httpHelper.getRequest('siswa/$siswaId/alergi');
    if (response.statusCode == 200 && response.body['success'] == true) {
      // API returns paginated response: {success, data: {data: [], pagination: {}}}
      final dataWrapper = response.body['data'];
      final List data = dataWrapper['data'];
      return data.map((json) => AlergiModel.fromJson(json)).toList();
    }
    throw Exception('Failed to load alergi');
  }

  Future<AlergiModel> addAlergi(String siswaId, String namaAlergi) async {
    final response = await _httpHelper.postRequest('siswa/$siswaId/alergi', {
      'namaAlergi': namaAlergi,
    });
    if (response.statusCode == 201 && response.body['success'] == true) {
      return AlergiModel.fromJson(response.body['data']);
    }
    throw Exception('Failed to add alergi');
  }

  Future<void> deleteAlergi(String id) async {
    final response = await _httpHelper.deleteRequest('alergi/$id');
    if (response.statusCode != 200) {
      throw Exception('Failed to delete alergi');
    }
  }

  // ==================== ABSENSI ====================

  Future<List<AbsensiModel>> getAbsensiByKelas(String kelasId) async {
    final response = await _httpHelper.getRequest('kelas/$kelasId/absensi');
    if (response.statusCode == 200 && response.body['success'] == true) {
      // API returns paginated response: {success, data: {data: [], pagination: {}}}
      final dataWrapper = response.body['data'];
      final List data = dataWrapper['data'];
      return data.map((json) => AbsensiModel.fromJson(json)).toList();
    }
    throw Exception('Failed to load absensi');
  }

  Future<AbsensiModel> createAbsensi(
    String kelasId,
    Map<String, dynamic> data,
  ) async {
    final response = await _httpHelper.postRequest(
      'kelas/$kelasId/absensi',
      data,
    );
    if (response.statusCode == 201 && response.body['success'] == true) {
      return AbsensiModel.fromJson(response.body['data']);
    }
    throw Exception('Failed to create absensi');
  }

  Future<Map<String, dynamic>> getTotalAbsensi(
    String sekolahId,
    String tanggal,
  ) async {
    final response = await _httpHelper.getRequest(
      'sekolah/$sekolahId/absensi/total/$tanggal',
    );
    if (response.statusCode == 200 && response.body['success'] == true) {
      return response.body['data'];
    }
    throw Exception('Failed to load total absensi');
  }

  // ==================== PENGIRIMAN ====================

  Future<List<PengirimanModel>> getPengirimanBySekolah(String sekolahId) async {
    final response = await _httpHelper.getRequest(
      'sekolah/$sekolahId/pengiriman',
    );
    if (response.statusCode == 200 && response.body['success'] == true) {
      // API returns paginated response: {success, data: {data: [], pagination: {}}}
      final dataWrapper = response.body['data'];
      final List data = dataWrapper['data'];
      return data.map((json) => PengirimanModel.fromJson(json)).toList();
    }
    return [];
  }

  Future<PengirimanModel> scanSekolahQR(String qrCodeId) async {
    final response = await _httpHelper.postRequest(
      'pengiriman/$qrCodeId/scan-sekolah',
      {},
    );
    if (response.statusCode == 200 && response.body['success'] == true) {
      return PengirimanModel.fromJson(response.body['data']);
    }
    throw Exception('Failed to scan QR code');
  }

  // ==================== MENU ====================

  Future<List<MenuPlanningModel>> getMenuBySekolah(String sekolahId) async {
    final response = await _httpHelper.getRequest(
      'sekolah/$sekolahId/menu-planning',
    );
    if (response.statusCode == 200 && response.body['success'] == true) {
      // API returns paginated response: {success, data: {data: [], pagination: {}}}
      final dataWrapper = response.body['data'];
      final List data = dataWrapper['data'];
      return data.map((json) => MenuPlanningModel.fromJson(json)).toList();
    }
    return [];
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
}
