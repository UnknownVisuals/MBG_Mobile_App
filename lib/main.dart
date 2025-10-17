import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mbg_mobile_app/features/authentication/screens/onboarding/onboarding.dart';
import 'package:mbg_mobile_app/utils/constants/text_strings.dart';
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

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: MBGTexts.appName,
      themeMode: ThemeMode.system,
      theme: MBGAppTheme.lightTheme,
      darkTheme: MBGAppTheme.darkTheme,
      home: const OnBoardingScreen(),
    );
  }
}
