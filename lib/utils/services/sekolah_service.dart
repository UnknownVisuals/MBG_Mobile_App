import 'dart:io';

import 'package:get/get.dart';
import 'package:mbg_mobile_app/features/dapur/models/dapur_menu_planning_model.dart';
import 'package:mbg_mobile_app/features/dapur/models/dapur_menu_harian_model.dart';
import 'package:mbg_mobile_app/features/sekolah/models/sekolah_alergi_model.dart';
import 'package:mbg_mobile_app/features/sekolah/models/sekolah_delivery_model.dart';
import 'package:mbg_mobile_app/features/sekolah/models/sekolah_info_model.dart';
import 'package:mbg_mobile_app/features/sekolah/models/sekolah_kalender_akademik_model.dart';
import 'package:mbg_mobile_app/features/sekolah/models/sekolah_kelas_model.dart';
import 'package:mbg_mobile_app/features/sekolah/models/sekolah_siswa_model.dart';
import 'package:mbg_mobile_app/utils/http/http_client.dart';

import 'package:mbg_mobile_app/features/sekolah/models/sekolah_tray_return_model.dart';

class SekolahService extends GetxService {
  SekolahService({MBGHttpHelper? httpHelper})
    : _httpHelper = httpHelper ?? Get.find<MBGHttpHelper>();

  final MBGHttpHelper _httpHelper;

  Future<List<DapurMenuPlanningModel>> getMenuBySekolah(
    String sekolahId,
  ) async {
    MBGHttpHelper.loadSessionToken();
    final response = await _httpHelper.getRequest(
      'sekolah/$sekolahId/menu-planning',
    );

    if (!_isSuccess(response)) {
      throw Exception(_responseMessage(response, 'Gagal memuat menu sekolah'));
    }

    final data = _extractDataList(response);
    return data.map(DapurMenuPlanningModel.fromJson).toList();
  }

  Future<List<SekolahDeliveryModel>> getPengirimanBySekolah(
    String sekolahId,
  ) async {
    MBGHttpHelper.loadSessionToken();
    final response = await _httpHelper.getRequest(
      'sekolah/$sekolahId/pengiriman',
    );

    if (!_isSuccess(response)) {
      throw Exception(
        _responseMessage(response, 'Gagal memuat pengiriman sekolah'),
      );
    }

    final data = _extractDataList(response);
    return data.map(SekolahDeliveryModel.fromJson).toList();
  }

  Future<SekolahDeliveryModel> scanSekolahQR(String qrCodeId) async {
    MBGHttpHelper.loadSessionToken();
    final response = await _httpHelper.postRequest(
      'pengiriman/$qrCodeId/scan-sekolah',
      const {},
    );

    if (!_isSuccess(response)) {
      throw Exception(_responseMessage(response, 'Gagal memindai QR sekolah'));
    }

    final data = _extractDataObject(response);
    return SekolahDeliveryModel.fromJson(data);
  }

  Future<Map<String, dynamic>> getTotalAbsensi(
    String sekolahId,
    String tanggal,
  ) async {
    MBGHttpHelper.loadSessionToken();
    final response = await _httpHelper.getRequest(
      'sekolah/$sekolahId/absensi/total/$tanggal',
    );

    if (!_isSuccess(response)) {
      throw Exception(_responseMessage(response, 'Gagal memuat data absensi'));
    }

    final body = response.body;
    if (body is Map<String, dynamic>) {
      final data = body['data'];
      if (data is Map<String, dynamic>) {
        return data;
      }
    }

    throw Exception('Format respons tidak valid');
  }

  Future<SekolahSiswaPaginatedResponse> getSiswaBySekolah(
    String sekolahId, {
    int page = 1,
    int limit = 10,
  }) async {
    MBGHttpHelper.loadSessionToken();
    final response = await _httpHelper.getRequest(
      'sekolah/$sekolahId/siswa?page=$page&limit=$limit',
    );

    if (!_isSuccess(response)) {
      throw Exception(_responseMessage(response, 'Gagal memuat siswa'));
    }

    final body = response.body;
    if (body is Map<String, dynamic>) {
      final data = body['data'];
      if (data is Map<String, dynamic>) {
        final items =
            (data['data'] as List<dynamic>?)
                ?.whereType<Map<String, dynamic>>()
                .map(SekolahSiswaModel.fromJson)
                .toList() ??
            <SekolahSiswaModel>[];

        final paginationJson = data['pagination'];
        final pagination = paginationJson is Map<String, dynamic>
            ? SekolahSiswaPagination.fromJson(paginationJson)
            : null;

        return SekolahSiswaPaginatedResponse(
          data: items,
          pagination: pagination,
        );
      }
    }

    throw Exception('Format data tidak valid');
  }

  Future<SekolahSiswaModel> getSiswaById(String siswaId) async {
    MBGHttpHelper.loadSessionToken();
    final response = await _httpHelper.getRequest('siswa/$siswaId');

    if (!_isSuccess(response)) {
      throw Exception(_responseMessage(response, 'Gagal memuat siswa'));
    }

    final data = _extractDataObject(response);
    return SekolahSiswaModel.fromJson(data);
  }

  Future<List<SekolahKelasModel>> getKelasBySekolah(String sekolahId) async {
    MBGHttpHelper.loadSessionToken();
    final response = await _httpHelper.getRequest('sekolah/$sekolahId/kelas');

    if (!_isSuccess(response)) {
      throw Exception(_responseMessage(response, 'Gagal memuat kelas'));
    }

    final data = _extractDataList(response);
    return data.map(SekolahKelasModel.fromJson).toList();
  }

  Future<SekolahKalenderAkademikResponse> getKalenderAkademik({
    String? sekolahId,
  }) async {
    MBGHttpHelper.loadSessionToken();
    final endpoint = sekolahId != null && sekolahId.isNotEmpty
        ? 'sekolah/$sekolahId/kalender-akademik'
        : 'kalender-akademik';
    final response = await _httpHelper.getRequest(endpoint);

    if (!_isSuccess(response)) {
      throw Exception(
        _responseMessage(response, 'Gagal memuat kalender akademik'),
      );
    }

    final body = response.body;
    if (body is Map<String, dynamic>) {
      final data = body['data'];
      if (data is Map<String, dynamic>) {
        return SekolahKalenderAkademikResponse.fromJson(data);
      }
    }

    throw Exception('Format respons tidak valid');
  }

  Future<SekolahKalenderAkademikModel> createKalenderAkademik(
    Map<String, dynamic> payload,
  ) async {
    MBGHttpHelper.loadSessionToken();
    final response = await _httpHelper.postRequest(
      'kalender-akademik',
      payload,
    );

    if (response.statusCode != 201 || !_isSuccess(response)) {
      throw Exception(
        _responseMessage(response, 'Gagal membuat kalender akademik'),
      );
    }

    final data = _extractDataObject(response);
    return SekolahKalenderAkademikModel.fromJson(data);
  }

  Future<SekolahKalenderAkademikModel> updateKalenderAkademik(
    String id,
    Map<String, dynamic> payload,
  ) async {
    MBGHttpHelper.loadSessionToken();
    final response = await _httpHelper.putRequest(
      'kalender-akademik/$id',
      payload,
    );

    if (!_isSuccess(response)) {
      throw Exception(
        _responseMessage(response, 'Gagal memperbarui kalender akademik'),
      );
    }

    final data = _extractDataObject(response);
    return SekolahKalenderAkademikModel.fromJson(data);
  }

  Future<void> deleteKalenderAkademik(String id) async {
    MBGHttpHelper.loadSessionToken();
    final response = await _httpHelper.deleteRequest('kalender-akademik/$id');

    if (!_isSuccess(response)) {
      throw Exception(
        _responseMessage(response, 'Gagal menghapus kalender akademik'),
      );
    }
  }

  Future<SekolahKelasModel> createKelas(
    String sekolahId,
    Map<String, dynamic> payload,
  ) async {
    MBGHttpHelper.loadSessionToken();
    final response = await _httpHelper.postRequest(
      'sekolah/$sekolahId/kelas',
      payload,
    );

    if (response.statusCode != 201 || !_isSuccess(response)) {
      throw Exception(_responseMessage(response, 'Gagal membuat kelas'));
    }

    final data = _extractDataObject(response);
    return SekolahKelasModel.fromJson(data);
  }

  Future<SekolahKelasModel> updateKelas(
    String kelasId,
    Map<String, dynamic> payload,
  ) async {
    MBGHttpHelper.loadSessionToken();
    final response = await _httpHelper.putRequest('kelas/$kelasId', payload);

    if (!_isSuccess(response)) {
      throw Exception(_responseMessage(response, 'Gagal memperbarui kelas'));
    }

    final data = _extractDataObject(response);
    return SekolahKelasModel.fromJson(data);
  }

  Future<void> deleteKelas(String kelasId) async {
    MBGHttpHelper.loadSessionToken();
    final response = await _httpHelper.deleteRequest('kelas/$kelasId');

    if (!_isSuccess(response)) {
      throw Exception(_responseMessage(response, 'Gagal menghapus kelas'));
    }
  }

  Future<SekolahAlergiModel> addAlergi(
    String siswaId,
    String namaAlergi,
  ) async {
    MBGHttpHelper.loadSessionToken();
    final response = await _httpHelper.postRequest('siswa/$siswaId/alergi', {
      'namaAlergi': namaAlergi,
    });

    if (response.statusCode != 201 || !_isSuccess(response)) {
      throw Exception(_responseMessage(response, 'Gagal menambah alergi'));
    }

    final data = _extractDataObject(response);
    return SekolahAlergiModel.fromJson(data);
  }

  Future<List<SekolahAlergiModel>> getAlergiBySiswa(String siswaId) async {
    MBGHttpHelper.loadSessionToken();
    final response = await _httpHelper.getRequest('siswa/$siswaId/alergi');

    if (!_isSuccess(response)) {
      throw Exception(_responseMessage(response, 'Gagal memuat alergi'));
    }

    final data = _extractDataList(response);
    return data.map(SekolahAlergiModel.fromJson).toList();
  }

  Future<void> deleteAlergi(String alergiId) async {
    MBGHttpHelper.loadSessionToken();
    final response = await _httpHelper.deleteRequest('alergi/$alergiId');

    if (!_isSuccess(response)) {
      throw Exception(_responseMessage(response, 'Gagal menghapus alergi'));
    }
  }

  Future<SekolahSiswaModel> createSiswa({
    required String sekolahId,
    required String kelasId,
    required String nama,
    required String nis,
    required int umur,
    required String jenisKelamin,
    required double tinggiBadan,
    required double beratBadan,
    File? foto,
  }) async {
    MBGHttpHelper.loadSessionToken();
    final response = await _httpHelper.postMultipartRequest(
      'sekolah/$sekolahId/siswa',
      fields: {
        'nama': nama,
        'nis': nis,
        'kelasId': kelasId,
        'jenisKelamin': jenisKelamin,
        'umur': umur.toString(),
        'tinggiBadan': tinggiBadan.toString(),
        'beratBadan': beratBadan.toString(),
      },
      file: foto,
      fileFieldName: 'foto',
    );

    if (response.statusCode != 201 || !_isSuccess(response)) {
      throw Exception(_responseMessage(response, 'Gagal menambahkan siswa'));
    }

    final data = _extractDataObject(response);
    return SekolahSiswaModel.fromJson(data);
  }

  Future<SekolahSiswaModel> updateSiswa({
    required String siswaId,
    required String nama,
    required String nis,
    required String jenisKelamin,
    required int umur,
    required double tinggiBadan,
    required double beratBadan,
    required String kelasId,
    File? foto,
  }) async {
    MBGHttpHelper.loadSessionToken();
    final fields = {
      'nama': nama,
      'nis': nis,
      'jenisKelamin': jenisKelamin,
      'umur': umur.toString(),
      'tinggiBadan': tinggiBadan.toString(),
      'beratBadan': beratBadan.toString(),
      'kelasId': kelasId,
    };

    final response = await _httpHelper.postMultipartRequest(
      'siswa/$siswaId',
      fields: fields,
      file: foto,
      fileFieldName: 'foto',
      isPutMethod: true,
    );

    if (!_isSuccess(response)) {
      throw Exception(_responseMessage(response, 'Gagal memperbarui siswa'));
    }

    final data = _extractDataObject(response);
    return SekolahSiswaModel.fromJson(data);
  }

  Future<void> deleteSiswa(String siswaId) async {
    MBGHttpHelper.loadSessionToken();
    final response = await _httpHelper.deleteRequest('siswa/$siswaId');

    if (!_isSuccess(response)) {
      throw Exception(_responseMessage(response, 'Gagal menghapus siswa'));
    }
  }

  // Future<SekolahPengirimanModel> scanSekolahQR(String qrCodeId) async {
  //   MBGHttpHelper.loadSessionToken();
  //   final response = await _httpHelper.postRequest(
  //     'pengiriman/$qrCodeId/scan-sekolah',
  //     const {},
  //   );

  //   if (!_isSuccess(response)) {
  //     throw Exception(_responseMessage(response, 'Gagal memindai QR sekolah'));
  //   }

  //   final data = _extractDataObject(response);
  //   return SekolahPengirimanModel.fromJson(data);
  // }

  // Future<List<SekolahAbsensiModel>> getAbsensiByKelas(String kelasId) async {
  //   MBGHttpHelper.loadSessionToken();
  //   final response = await _httpHelper.getRequest('kelas/$kelasId/absensi');

  //   if (!_isSuccess(response)) {
  //     throw Exception(_responseMessage(response, 'Gagal memuat absensi kelas'));
  //   }

  //   final data = _extractDataList(response);
  //   return data.map(SekolahAbsensiModel.fromJson).toList();
  // }

  // Future<SekolahAbsensiModel> createAbsensi(
  //   String kelasId,
  //   Map<String, dynamic> payload,
  // ) async {
  //   MBGHttpHelper.loadSessionToken();
  //   final response = await _httpHelper.postRequest(
  //     'kelas/$kelasId/absensi',
  //     payload,
  //   );

  //   if (response.statusCode != 201 || !_isSuccess(response)) {
  //     throw Exception(_responseMessage(response, 'Gagal membuat absensi'));
  //   }

  //   final data = _extractDataObject(response);
  //   return SekolahAbsensiModel.fromJson(data);
  // }

  Future<SekolahInfoModel> getSekolahInfo(String sekolahId) async {
    MBGHttpHelper.loadSessionToken();
    final response = await _httpHelper.getRequest('sekolah/$sekolahId');

    if (!_isSuccess(response)) {
      throw Exception(
        _responseMessage(response, 'Gagal memuat informasi sekolah'),
      );
    }

    final data = _extractDataObject(response);
    return SekolahInfoModel.fromJson(data);
  }

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

  // ====================
  // TRAY RETURN
  // ====================

  Future<SekolahTrayReturnModel> createTrayReturn(
    Map<String, dynamic> payload,
  ) async {
    MBGHttpHelper.loadSessionToken();
    final response = await _httpHelper.postRequest('tray-return', payload);

    if (response.statusCode != 201 || !_isSuccess(response)) {
      throw Exception(
        _responseMessage(response, 'Gagal membuat pengembalian tray'),
      );
    }

    final data = _extractDataObject(response);
    return SekolahTrayReturnModel.fromJson(data);
  }

  Future<List<SekolahTrayReturnModel>> getMyTrayReturns() async {
    MBGHttpHelper.loadSessionToken();
    final response = await _httpHelper.getRequest('tray-return/my-submissions');

    if (!_isSuccess(response)) {
      throw Exception(
        _responseMessage(response, 'Gagal memuat riwayat pengembalian'),
      );
    }

    final data = _extractDataList(response);
    return data.map(SekolahTrayReturnModel.fromJson).toList();
  }

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

  Map<String, dynamic> _extractDataObject(Response<dynamic> response) {
    final body = response.body;
    if (body is Map<String, dynamic>) {
      final data = body['data'];
      if (data is Map<String, dynamic>) {
        return data;
      }
    }
    throw Exception('Format data tidak valid');
  }
}
