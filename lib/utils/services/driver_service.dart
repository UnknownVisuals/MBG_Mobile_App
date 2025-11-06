import 'package:get/get.dart';
import 'package:mbg_mobile_app/features/driver/models/driver_delivery_model.dart';
import 'package:mbg_mobile_app/features/driver/models/driver_menu_harian_model.dart';
import 'package:mbg_mobile_app/features/driver/models/driver_menu_planning_model.dart';
import 'package:mbg_mobile_app/features/driver/models/driver_sekolah_model.dart';
import 'package:mbg_mobile_app/utils/http/http_client.dart';

class DriverService extends GetxService {
  DriverService({MBGHttpHelper? httpHelper})
    : _httpHelper = httpHelper ?? Get.find<MBGHttpHelper>();

  final MBGHttpHelper _httpHelper;

  // ====================
  //  DRIVER DELIVERIES
  // ====================

  Future<List<DriverDeliveryModel>> getMyDeliveries() async {
    MBGHttpHelper.loadSessionToken();
    final response = await _httpHelper.getRequest('driver/pengiriman');

    if (!_isSuccess(response)) {
      throw Exception(_responseMessage(response, 'Gagal memuat pengiriman'));
    }

    final data = _extractDataList(response);
    return data.map(DriverDeliveryModel.fromJson).toList();
  }

  Future<DriverDeliveryModel> getDeliveryById(String id) async {
    MBGHttpHelper.loadSessionToken();
    final response = await _httpHelper.getRequest('pengiriman/$id');

    if (!_isSuccess(response)) {
      throw Exception(_responseMessage(response, 'Gagal memuat pengiriman'));
    }

    final data = _extractDataObject(response);
    return DriverDeliveryModel.fromJson(data);
  }

  Future<DriverDeliveryModel> getDeliveryByQR(String qrCodeId) async {
    MBGHttpHelper.loadSessionToken();
    final response = await _httpHelper.getRequest('pengiriman/qr/$qrCodeId');

    if (!_isSuccess(response)) {
      throw Exception(
        _responseMessage(response, 'Gagal memuat pengiriman dari QR'),
      );
    }

    final data = _extractDataObject(response);
    return DriverDeliveryModel.fromJson(data);
  }

  Future<DriverDeliveryModel> scanDriverQR(String qrCodeId) async {
    MBGHttpHelper.loadSessionToken();

    final response = await _httpHelper.postRequest(
      'pengiriman/$qrCodeId/scan-driver',
      const {},
    );

    if (!_isSuccess(response)) {
      throw Exception(
        _responseMessage(response, 'Gagal memindai QR pengiriman'),
      );
    }

    final data = _extractDataObject(response);
    return DriverDeliveryModel.fromJson(data);
  }

  Future<void> updateDriverLocation({
    required double latitude,
    required double longitude,
  }) async {
    MBGHttpHelper.loadSessionToken();

    final response = await _httpHelper.postRequest(
      'drivers/location',
      <String, dynamic>{'latitude': latitude, 'longitude': longitude},
    );

    if (!_isSuccess(response)) {
      throw Exception(
        _responseMessage(response, 'Gagal memperbarui lokasi pengemudi'),
      );
    }
  }

  // ====================
  // DRIVER CHECKPOINTS
  // ====================

  Future<List<DriverSekolahModel>> getAllSekolah() async {
    MBGHttpHelper.loadSessionToken();
    final response = await _httpHelper.getRequest('sekolah');

    if (!_isSuccess(response)) {
      throw Exception(
        _responseMessage(response, 'Gagal memuat checkpoint sekolah'),
      );
    }

    final data = _extractDataList(response);
    return data.map(DriverSekolahModel.fromJson).toList();
  }

  Future<List<DriverMenuPlanningModel>> getAllMenuPlanning() async {
    MBGHttpHelper.loadSessionToken();
    final response = await _httpHelper.getRequest('menu-planning');

    if (!_isSuccess(response)) {
      throw Exception(_responseMessage(response, 'Gagal memuat menu planning'));
    }

    final data = _extractDataList(response);
    return data.map(DriverMenuPlanningModel.fromJson).toList();
  }

  Future<List<DriverMenuPlanningModel>> getMenuPlanningBySekolah(
    String sekolahId,
  ) async {
    MBGHttpHelper.loadSessionToken();
    final response = await _httpHelper.getRequest(
      'sekolah/$sekolahId/menu-planning',
    );

    if (!_isSuccess(response)) {
      throw Exception(
        _responseMessage(response, 'Gagal memuat menu planning sekolah'),
      );
    }

    final data = _extractDataList(response);
    return data.map(DriverMenuPlanningModel.fromJson).toList();
  }

  Future<List<DriverMenuHarianModel>> getMenuHarianByPlanning(
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
    return data.map(DriverMenuHarianModel.fromJson).toList();
  }

  // ====================
  //    HELPER METHODS
  // ====================

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
