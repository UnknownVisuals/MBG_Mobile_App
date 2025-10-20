import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mbg_mobile_app/common/widgets/splash_screen.dart';
import 'package:mbg_mobile_app/features/authentication/controllers/user_controller.dart';
import 'package:mbg_mobile_app/features/authentication/screens/login/login.dart';
import 'package:mbg_mobile_app/features/authentication/screens/onboarding/onboarding.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur.dart';
import 'package:mbg_mobile_app/features/driver/screens/driver.dart';
import 'package:mbg_mobile_app/features/sekolah/screens/sekolah.dart';
import 'package:mbg_mobile_app/navigation_menu.dart';
import 'package:mbg_mobile_app/utils/constants/text_strings.dart';
import 'package:mbg_mobile_app/utils/local_storage/storage_utility.dart';
import 'package:mbg_mobile_app/utils/theme/theme.dart';
import 'package:mbg_mobile_app/utils/http/http_client.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  await GetStorage.init();

  MBGHttpHelper.loadSessionToken();

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  Future<Widget> _determineInitialScreen() async {
    final localStorage = MBGLocalStorage();

    // Check if user has seen onboarding
    final hasSeenOnboarding =
        localStorage.readData<bool>('hasSeenOnboarding') ?? false;

    // If haven't seen onboarding, show it
    if (!hasSeenOnboarding) {
      return const OnBoardingScreen();
    }

    // Check if there's a saved session token
    final sessionToken = localStorage.readData<String>('session_token');

    // If no token, go to login
    if (sessionToken == null || sessionToken.isEmpty) {
      return const LoginScreen();
    }

    // If token exists, try to fetch user profile
    try {
      final userController = Get.put(UserController());
      await userController.fetchUserProfile();

      // If user data is valid, navigate based on role
      if (userController.user.value != null) {
        final userRole = userController.user.value?.role;

        switch (userRole) {
          case 'PIC_DAPUR':
            return const DapurScreen();
          case 'DRIVER':
            return const DriverScreen();
          case 'PIC_SEKOLAH':
            return const SekolahScreen();
          case 'SUPERADMIN':
            return const NavigationMenu();
          default:
            return const NavigationMenu();
        }
      }
    } catch (e) {
      // If token is invalid or expired, clear it and go to login
      await MBGHttpHelper.clearSessionToken();
    }

    // Default to login screen
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
        future: _determineInitialScreen(),
        builder: (context, snapshot) {
          // Show splash screen while determining initial screen
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          }

          // Return the determined screen
          return snapshot.data ?? const OnBoardingScreen();
        },
      ),
    );
  }
}
