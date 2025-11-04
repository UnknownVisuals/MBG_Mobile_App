// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:mbg_mobile_app/main.dart';
import 'package:mbg_mobile_app/common/widgets/splash_screen.dart';
import 'package:mbg_mobile_app/features/authentication/screens/onboarding/onboarding.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    Get.testMode = true;
    await GetStorage.init();
  });

  setUp(() async {
    await GetStorage().erase();
  });

  testWidgets('App shows onboarding when onboarding data not set', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const App());

    // initial frame should display splash while deciding initial route
    expect(find.byType(MBGSplashScreen), findsOneWidget);

    await tester.pumpAndSettle();

    // without stored session or onboarding flag, onboarding page should render
    expect(find.byType(OnBoardingScreen), findsOneWidget);
  });
}
