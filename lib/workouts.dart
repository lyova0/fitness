import 'package:flutter/material.dart';

class Workouts extends StatefulWidget {
  final String level;
  const Workouts({super.key, required this.level});

  @override
  State<Workouts> createState() => _WorkoutsState();
}

class _WorkoutsState extends State<Workouts> {
  @override
  void initState() {
    super.initState();
    // Показываем окно выбора времени при входе на экран
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showTimePicker();
    });
  }

  void _showTimePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (_) {
        TimeOfDay selectedTime = TimeOfDay.now();
        return StatefulBuilder(builder: (context, setState) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${widget.level} LEVEL — Set Daily Reminder',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Pick a time for daily reminder to train',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    TimeOfDay? picked = await showTimePicker(
                      context: context,
                      initialTime: selectedTime,
                    );
                    if (picked != null) {
                      setState(() {
                        selectedTime = picked;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrangeAccent,
                  ),
                  child: Text(
                      'Selected: ${selectedTime.format(context)}'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // 🔹 Тут можно сохранить время напоминания в Firebase или SharedPreferences
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrangeAccent,
                  ),
                  child: const Text('Confirm'),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('${widget.level} Workouts'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'Workouts content here',
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
