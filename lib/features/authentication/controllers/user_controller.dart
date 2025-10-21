import 'package:get/get.dart';
import 'package:mbg_mobile_app/features/authentication/models/user_model.dart';
import 'package:mbg_mobile_app/features/authentication/screens/login/login.dart';
import 'package:mbg_mobile_app/utils/http/http_client.dart';
import 'package:mbg_mobile_app/utils/popups/loaders.dart';

class UserController extends GetxController {
  UserController();

  // Dependencies
  final MBGHttpHelper httpHelper = Get.find<MBGHttpHelper>();

  // Data Variables
  Rx<UserModel?> user = Rx<UserModel?>(null);

  // State Variables
  RxBool isLoading = false.obs;
  bool _isHandlingSessionExpired = false;

  @override
  void onInit() {
    super.onInit();
    MBGHttpHelper.registerUnauthorizedHandler(_handleSessionExpired);
    fetchUserProfile();
  }

  @override
  void onClose() {
    MBGHttpHelper.unregisterUnauthorizedHandler(_handleSessionExpired);
    super.onClose();
  }

  /// Fetch user profile from API
  Future<void> fetchUserProfile() async {
    try {
      isLoading.value = true;

      // Load session token first
      MBGHttpHelper.loadSessionToken();

      final response = await httpHelper.getRequest('auth/me');

      if (response.statusCode == 200) {
        final responseData = response.body;

        if (responseData is Map<String, dynamic> &&
            responseData['success'] == true) {
          user.value = UserModel.fromJson(responseData['data']);
        }
      }
    } catch (_) {
      user.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  /// Clear user data on logout
  Future<void> logout() async {
    try {
      await MBGHttpHelper.clearSessionToken();
      user.value = null;
      Get.offAll(() => const LoginScreen());
      MBGLoaders.successSnackBar(
        title: 'Logout Berhasil',
        message: 'Sampai jumpa lagi!',
      );
    } catch (e) {
      MBGLoaders.errorSnackBar(title: 'Logout Failed', message: e.toString());
    }
  }

  /// Check if user is authenticated
  bool get isAuthenticated => user.value != null;

  /// Get user role
  String? get userRole => user.value?.role;

  /// Get user name
  String? get userName => user.value?.name;

  /// Get user email
  String? get userEmail => user.value?.email;

  Future<void> _handleSessionExpired({String? message}) async {
    if (_isHandlingSessionExpired) return;
    _isHandlingSessionExpired = true;

    user.value = null;

    MBGLoaders.warningSnackBar(
      title: 'Sesi berakhir',
      message: message ?? 'Silakan login kembali.',
    );

    Get.offAll(() => const LoginScreen());
    _isHandlingSessionExpired = false;
  }
}
