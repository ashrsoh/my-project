import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:project_flutter_api_2/login.dart';
import 'package:project_flutter_api_2/setting_app/translations.dart';
import 'package:project_flutter_api_2/setting_app/setting_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final settings = SettingsProvider();
  await settings.loadSettings(); // تحميل الإعدادات المخزنة

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => settings),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);

    return GetMaterialApp(
      title: 'Flutter API Project',
      debugShowCheckedModeBanner: false,
      theme: settings.isDarkMode ? ThemeData.dark() : ThemeData.light(),
      locale: Locale(settings.language), // تعيين اللغة حسب التفضيل
      translations: AppTranslations(),
      fallbackLocale: Locale('ar'), // لغة افتراضية إذا لم توجد ترجمة
      home: LoginPage(), // الصفحة الرئيسية
    );
  }
}
