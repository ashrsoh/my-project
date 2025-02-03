import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_flutter_api_2/main.dart';
import 'package:project_flutter_api_2/setting_app/setting_provider.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // 1️⃣ إنشاء كائن الإعدادات وتحميل البيانات المخزنة
    final settings = SettingsProvider();
    await settings.loadSettings();

    // 2️⃣ ضخ التطبيق داخل بيئة الاختبار مع Provider و MultiProvider
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => settings),
        ],
        child: MyApp(),
      ),
    );

    // 3️⃣ التأكد من أن العداد يبدأ من 0 (تأكد من وجود النص "0")
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // 4️⃣ النقر على زر "+"
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // 5️⃣ التحقق من زيادة العداد إلى 1
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
