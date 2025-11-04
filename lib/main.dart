import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mbg_mobile_app/common/widgets/splash_screen.dart';
import 'package:mbg_mobile_app/features/authentication/controllers/user_controller.dart';
import 'package:mbg_mobile_app/features/authentication/screens/login/login.dart';
import 'package:mbg_mobile_app/features/authentication/screens/onboarding/onboarding.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur.dart';
import 'package:mbg_mobile_app/features/driver/screens/driver.dart';
import 'package:mbg_mobile_app/features/sekolah/screens/sekolah.dart';
import 'package:mbg_mobile_app/utils/constants/text_strings.dart';
import 'package:mbg_mobile_app/utils/services/dapur_service.dart';
import 'package:mbg_mobile_app/utils/services/driver_service.dart';
import 'package:mbg_mobile_app/utils/http/http_client.dart';
import 'package:mbg_mobile_app/utils/services/sekolah_service.dart';
import 'package:mbg_mobile_app/utils/local_storage/storage_utility.dart';
import 'package:mbg_mobile_app/utils/theme/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await initializeDateFormatting('id_ID', null);
  await dotenv.load(fileName: ".env");
  await GetStorage.init();

  // Initialize HTTP Client
  Get.put(MBGHttpHelper());
  Get.put(DapurService());
  Get.put(DriverService());
  Get.put(SekolahService());
  MBGHttpHelper.loadSessionToken();

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  Future<Widget> _initialScreen() async {
    // =============================
    // ===== ONBOARDING SCREEN =====
    // =============================

    // Check if onboarding has been seen
    final MBGLocalStorage localStorage = MBGLocalStorage();

    // Check if onboarding has been seen
    final bool hasSeenOnboarding =
        localStorage.readData<bool>('hasSeenOnboarding') ?? false;

    // If onboarding not seen, show onboarding screen
    if (!hasSeenOnboarding) {
      return const OnBoardingScreen();
    }

    // ================================
    // ===== AUTHENTICATION CHECK =====
    // ================================

    // Check for existing session token
    final String? sessionToken = localStorage.readData<String>('session_token');

    // If no session token, show login screen
    if (sessionToken == null || sessionToken.isEmpty) {
      return const LoginScreen();
    }

    // If session token exists, validate and fetch user profile
    try {
      final UserController userController = Get.put(UserController());
      await userController.fetchUserProfile();

      if (userController.userModel.value != null) {
        final userRole = userController.userModel.value?.role;
        switch (userRole) {
          case 'PIC_DAPUR':
            return const DapurScreen();
          case 'DRIVER':
            return const DriverScreen();
          case 'PIC_SEKOLAH':
            return const SekolahScreen();
          default:
            return const LoginScreen();
        }
      }
    } catch (e) {
      await MBGHttpHelper.clearSessionToken();
    }

    return const LoginScreen();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: MBGTexts.appName,
      themeMode: ThemeMode.system,
      theme: MBGAppTheme.lightTheme,
      darkTheme: MBGAppTheme.darkTheme,
      home: FutureBuilder<Widget>(
        future: _initialScreen(),
        builder: (context, snapshot) {
          // While waiting for the future to complete, show splash screen
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MBGSplashScreen();
          }

          // Once complete, show the appropriate initial screen
          return snapshot.data ?? const OnBoardingScreen();
        },
      ),
    );
  }
}
