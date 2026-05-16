import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:project_shop/bindings/initial_app.dart';
import 'package:project_shop/bindings/initial_binding.dart';
import 'package:project_shop/core/notification_service.dart';
import 'package:project_shop/data/secure_storage/share_preference_manager.dart';
import 'package:project_shop/firebase_options.dart';
import 'package:project_shop/routes/app_pages.dart';
import 'package:project_shop/widgets/common/toast_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  Get.put(SharedPreferencesManager(sharedPreferences: prefs));
  await AppInitializer.init();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Get.putAsync<NotificationService>(
    () async => await NotificationService().init(),
  );

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (_) => runApp(const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final toastBuilder = FToastBuilder();

    return ScreenUtilInit(
      designSize: Size(375, 812),
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'FlutterApp'.tr,
          navigatorKey: Get.key,
          builder: (context, child) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (Get.isRegistered<ToastWidget>() &&
                  Get.key.currentContext != null) {
                Get.find<ToastWidget>().registerContext();
              }
            });
            return toastBuilder(context, child);
          },
          theme: ThemeData(
            fontFamily: 'Inter',
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.white,
            ),
          ),
          locale: Get.deviceLocale,
          fallbackLocale: Locale('en', 'US'),
          initialBinding: InitialBinding(),
          getPages: AppPages.routes,
          initialRoute: AppPages.initial,
        );
      },
    );
  }
}
