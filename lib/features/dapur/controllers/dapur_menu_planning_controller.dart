import 'package:get/get.dart';
import 'package:mbg_mobile_app/features/dapur/models/dapur_menu_planning_model.dart';
import 'package:mbg_mobile_app/utils/services/dapur_service.dart';

class DapurMenuPlanningController extends GetxController {
  // Dependencies
  final DapurService _dapurService = Get.find<DapurService>();

  // Data Variables
  RxList<DapurMenuPlanningModel> menuPlanningList =
      <DapurMenuPlanningModel>[].obs;

  // State Variables
  RxBool isLoading = false.obs;
}
