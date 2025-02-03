import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project_flutter_api_2/setting_app/setting_provider.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("إعدادات التطبيق")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: Text("الوضع الليلي"),
              value: settings.isDarkMode,
              onChanged: (value) => settings.setDarkMode(value),
            ),
            ListTile(
              title: Text("اللغة"),
              trailing: DropdownButton<String>(
                value: settings.language,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    settings.setLanguage(newValue);
                  }
                },
                items: [
                  DropdownMenuItem(value: "ar", child: Text("العربية")),
                  DropdownMenuItem(value: "en", child: Text("الإنجليزية")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
