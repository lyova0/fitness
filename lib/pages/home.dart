import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'workouts.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final user = FirebaseAuth.instance.currentUser;

  final List<Map<String, dynamic>> levels = [
    {
      'title': 'Light',
      'time': '15-20 min',
      'days': '3 days workout / 1 day rest',
      'equipment': 'No equipment',
      'level': 'Beginner',
      'icon': Icons.sentiment_satisfied
    },
    {
      'title': 'Middle',
      'time': '20-30 min',
      'days': '3 days workout / 1 day rest',
      'equipment': 'No equipment',
      'level': 'Intermediate',
      'icon': Icons.directions_run
    },
    {
      'title': 'Hard',
      'time': '30-40 min',
      'days': '3 days workout / 1 day rest',
      'equipment': 'No equipment',
      'level': 'Advanced',
      'icon': Icons.fitness_center
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned(
            top: 40,
            left: 0,
            right: 0,
            child: Image.asset(
              'images/background_lines.png',
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    'Fitness',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // 🚀 Боксы уровней
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: levels.length,
                    itemBuilder: (context, index) {
                      final levelData = levels[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => Workouts(
                                level: levelData['title'] ?? 'Light',
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withOpacity(0.3),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Icon(
                                levelData['icon'] ?? Icons.fitness_center,
                                size: 50,
                                color: Colors.deepOrangeAccent,
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      levelData['title'] ?? '',
                                      style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 6),
                                    Text('Time: ${levelData['time'] ?? ''}'),
                                    Text('${levelData['days'] ?? ''}'),
                                    Text('Equipment: ${levelData['equipment'] ?? ''}'),
                                    Text('Level: ${levelData['level'] ?? ''}'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
