import 'dart:async';
import 'package:pomodream/models/motiveTxt.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'settings_screen.dart';
import 'todo_screen.dart';
import 'dart:math'; // Rastgele seçim için

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Duration duration = const Duration(minutes: 25);
  late final MotiveTxt motiveTxt;
  Timer? timer;
  String rdmtext = "";

  @override
  void initState() {
    super.initState();
    _loadDuration();

    // Rastgele motivasyon cümlesi ekle
    final quotes = MotiveTxt.rdmTxt;
    rdmtext = quotes[Random().nextInt(quotes.length)];
  }

  void _loadDuration() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int seconds = prefs.getInt('pomodoroDuration') ?? 1500;
    setState(() {
      duration = Duration(seconds: seconds);
    });
  }

  void _saveDuration() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('pomodoroDuration', duration.inSeconds);
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (duration.inSeconds == 0) {
        timer?.cancel();
      } else {
        setState(() => duration -= const Duration(seconds: 1));
      }
    });
  }

  void stopTimer() {
    timer?.cancel();
  }

  void resetTimer() {
    setState(() => duration = const Duration(minutes: 25));
    stopTimer();
    _saveDuration();
  }

  String formatTime() =>
      "${duration.inMinutes.toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.settings),
          onPressed:
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TodoScreen()),
                ),
          ),
        ],
        title: const Text('Pomodream'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            margin: const EdgeInsets.all(24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            color: Theme.of(context).primaryColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 40),
              child: Text(
                formatTime(),
                style: const TextStyle(fontSize: 48, color: Colors.white),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: startTimer,
                child: const Text("Başlat"),
              ),
              const SizedBox(width: 10),
              ElevatedButton(onPressed: stopTimer, child: const Text("Durdur")),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: resetTimer,
                child: const Text("Sıfırla"),
              ),
            ],
          ),
          const SizedBox(height: 50),
          Text("$rdmtext", style: TextStyle(fontStyle: FontStyle.italic)),
        ],
      ),
    );
  }
}
