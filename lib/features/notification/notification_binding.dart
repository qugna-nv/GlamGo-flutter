import 'package:get/get.dart';
import 'package:project_shop/features/notification/notification_controller.dart';

class NotificationBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<NotificationController>()) {
      Get.lazyPut(() => NotificationController());
    }
  }
}
