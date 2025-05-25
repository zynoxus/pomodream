import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int minutes = 25;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      minutes = (prefs.getInt('pomodoroDuration') ?? 1500) ~/ 60;
    });
  }

  void _saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('pomodoroDuration', minutes * 60);
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Ayarlar")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text("Tema Seç", style: TextStyle(fontSize: 18)),
            Wrap(
              spacing: 10,
              children:
                  appThemes.map((color) {
                    return GestureDetector(
                      onTap: () => themeNotifier.setTheme(color),
                      child: CircleAvatar(
                        backgroundColor: color,
                        radius: 20,
                        child:
                            color == themeNotifier.themeColor
                                ? const Icon(Icons.check, color: Colors.white)
                                : null,
                      ),
                    );
                  }).toList(),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Pomodoro Süresi", style: TextStyle(fontSize: 18)),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed:
                          () => setState(
                            () => minutes = (minutes - 1).clamp(1, 60),
                          ),
                    ),
                    Text("$minutes dk", style: const TextStyle(fontSize: 18)),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed:
                          () => setState(
                            () => minutes = (minutes + 1).clamp(1, 60),
                          ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveSettings,
              child: const Text("Kaydet"),
            ),
          ],
        ),
      ),
    );
  }
}
