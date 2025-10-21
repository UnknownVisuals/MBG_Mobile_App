import 'package:get/get.dart';
import 'package:mbg_mobile_app/features/dapur/models/pengiriman_model.dart';
import 'package:mbg_mobile_app/utils/http/http_client.dart';

class DriverService extends GetxService {
  final MBGHttpHelper _httpHelper = Get.find<MBGHttpHelper>();

  // Get driver's deliveries
  Future<List<PengirimanModel>> getMyDeliveries() async {
    final response = await _httpHelper.getRequest('driver/pengiriman');
    if (response.statusCode == 200 && response.body['success'] == true) {
      // API returns paginated response: {success, data: {data: [], pagination: {}}}
      final dataWrapper = response.body['data'];
      final List data = dataWrapper['data'];
      return data.map((json) => PengirimanModel.fromJson(json)).toList();
    }
    return [];
  }

  // Scan QR code for pickup
  Future<PengirimanModel> scanDriverQR(String qrCodeId) async {
    final response = await _httpHelper.postRequest(
      'pengiriman/$qrCodeId/scan-driver',
      {},
    );
    if (response.statusCode == 200 && response.body['success'] == true) {
      return PengirimanModel.fromJson(response.body['data']);
    }
    throw Exception('Failed to scan QR code');
  }

  // Get delivery by ID
  Future<PengirimanModel> getDeliveryById(String id) async {
    final response = await _httpHelper.getRequest('pengiriman/$id');
    if (response.statusCode == 200 && response.body['success'] == true) {
      return PengirimanModel.fromJson(response.body['data']);
    }
    throw Exception('Failed to load delivery');
  }

  // Get delivery by QR Code
  Future<PengirimanModel> getDeliveryByQR(String qrCodeId) async {
    final response = await _httpHelper.getRequest('pengiriman/qr/$qrCodeId');
    if (response.statusCode == 200 && response.body['success'] == true) {
      return PengirimanModel.fromJson(response.body['data']);
    }
    throw Exception('Failed to load delivery');
  }
}
