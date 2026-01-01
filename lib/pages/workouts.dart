import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class Workouts extends StatefulWidget {
  final String level;
  const Workouts({super.key, required this.level});

  @override
  State<Workouts> createState() => _WorkoutsState();
}

class _WorkoutsState extends State<Workouts> {
  final user = FirebaseAuth.instance.currentUser!;
  final db = FirebaseDatabase.instance.ref();

  Map<String, bool> days = {};

  @override
  void initState() {
    super.initState();
    _loadDays();
  }

  void _loadDays() async {
    final snapshot = await db.child('users/${user.uid}/workouts/${widget.level}').get();
    if (snapshot.exists) {
      setState(() {
        days = Map<String, bool>.from(snapshot.value as Map);
      });
    }
  }

  void _toggleDay(String day) async {
    bool newVal = !(days[day] ?? false);
    setState(() => days[day] = newVal);
    await db.child('users/${user.uid}/workouts/${widget.level}/$day').set(newVal);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.level.toUpperCase(), style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: days.keys.map((day) {
          return ListTile(
            title: Text(day, style: const TextStyle(color: Colors.white)),
            trailing: Checkbox(
              value: days[day],
              onChanged: (_) => _toggleDay(day),
              activeColor: Colors.blueAccent,
            ),
          );
        }).toList(),
      ),
    );
  }
}
