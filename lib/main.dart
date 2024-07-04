import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'common/routes/pages.dart';
import 'common/services/storage.dart';
import 'common/store/config.dart';
import 'common/store/user.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Get.putAsync<StorageService>(() => StorageService().init());
  Get.put<ConfigStore>(ConfigStore());
  Get.put<UserDBStore>(UserDBStore());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        builder: (BuildContext context, Widget? child) => GetMaterialApp(
              title: 'BMW Car App',
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              initialRoute: AppPages.Welcome,
              getPages: AppPages.routes,
              debugShowCheckedModeBanner: false,
            ));
  }
}
