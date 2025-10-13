import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mbg_mobile_app/utils/constants/text_strings.dart';
import 'package:mbg_mobile_app/utils/theme/theme.dart';

void main() {
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
      debugShowCheckedModeBanner: false,
      // initialBinding: GeneralBindings(),
      home: const Scaffold(
        body: Center(
          child: Text(
            'Project Structure is set up and running.\n LEGOHHHHH 🎊',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
