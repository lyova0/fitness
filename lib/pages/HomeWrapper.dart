import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

// 🔹 Заглушка экрана Trainings (замени на свой экран позже)
class TrainingsScreen extends StatelessWidget {
  final String level;
  final int day;

  const TrainingsScreen({super.key, required this.level, required this.day});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('$level LEVEL — Day $day'),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'Здесь будет тренировка $level — Day $day',
          style: const TextStyle(color: Colors.white, fontSize: 20),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

// 🔹 Главный экран с боками и всплывающим окном
class HomeWrapper extends StatefulWidget {
  const HomeWrapper({super.key});

  @override
  State<HomeWrapper> createState() => _HomeWrapperState();
}

class _HomeWrapperState extends State<HomeWrapper> {
  int _selectedIndex = 0;
  final List<String> _titles = ['Home', 'Trainings', 'Profile'];

  final user = FirebaseAuth.instance.currentUser;

  // Структура всех тренировок
  final Map<String, List<Map<String, String>>> trainings = {
    'Light': [
      {
        'day': 'Day 1',
        'exercises': '''
Jumping Jacks — 30 sec
Squats — 12
Knee Push-ups — 8
Standing Crunch — 12
Plank — 20 sec
Stretch — 2 min
'''
      },
    ],
    'Middle': [
      {
        'day': 'Day 1',
        'exercises': '''
Jumping Jacks — 40 sec
Squats — 15
Knee Push-ups — 14
Standing Crunch — 15
Plank — 30 sec
Stretch — 3 min
'''
      },
    ],
    'Hard': [
      {
        'day': 'Day 1',
        'exercises': '''
Jumping Jacks — 50 sec
Squats — 20
Knee Push-ups — 16
Standing Crunch — 20
Plank — 50 sec
Stretch — 3 min
'''
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    _checkAndCreateUser();
  }

  // 🔹 Создаём аккаунт пользователя в Realtime Database, если его нет
  Future<void> _checkAndCreateUser() async {
    if (user == null) return;
    final ref = FirebaseDatabase.instance.ref('users/${user!.uid}');
    final snapshot = await ref.get();

    if (!snapshot.exists) {
      await ref.set({
        'email': user!.email,
        'trainings': {},
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 🔹 Фоновая картинка
          Positioned(
            top: -40,
            left: 40,
            child: Image.asset(
              'images/background_lines.png',
              height: screenHeight * 1.2,
              fit: BoxFit.cover,
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 80.0),
              child: Column(
                children: [
                  const SizedBox(height: 40),

                  // 🔹 Заголовок
                  Center(
                    child: Text(
                      'Fitness',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            blurRadius: 10,
                            color: Colors.white.withOpacity(0.3),
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 🔹 Контент вкладки
                  Expanded(
                    child: _selectedIndex == 0
                        ? _homeContent()
                        : Center(
                      child: Text(
                        'Current Tab: ${_titles[_selectedIndex]}',
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 22),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // 🔹 Нижний TabBar
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _tabButton(icon: Icons.home, label: 'Home', index: 0),
            _tabButton(icon: Icons.fitness_center, label: 'Trainings', index: 1),
            _tabButton(icon: Icons.person, label: 'Profile', index: 2),
          ],
        ),
      ),
    );
  }

  // 🔹 Контент Home
  Widget _homeContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          _trainingBox(
            level: 'Light',
            title: 'LIGHT LEVEL — 30 DAY TRAINING',
            duration: '15–20 мин',
            schedule: '3 дня тренировка / 1 день отдых',
            equipment: 'Без оборудования',
            userLevel: 'Новички',
          ),
          const SizedBox(height: 16),
          _trainingBox(
            level: 'Middle',
            title: 'MIDDLE LEVEL — 30 DAY TRAINING',
            duration: '20–30 мин',
            schedule: '3 дня тренировка / 1 день отдых',
            equipment: 'Без оборудования',
            userLevel: 'Средний',
          ),
          const SizedBox(height: 16),
          _trainingBox(
            level: 'Hard',
            title: 'HARD LEVEL — 30 DAY TRAINING',
            duration: '30–40 мин',
            schedule: '3 дня тренировка / 1 день отдых',
            equipment: 'Без оборудования',
            userLevel: 'Продвинутый',
          ),
        ],
      ),
    );
  }

  // 🔹 Бокс тренировки
  Widget _trainingBox({
    required String level,
    required String title,
    required String duration,
    required String schedule,
    required String equipment,
    required String userLevel,
  }) {
    return GestureDetector(
      onTap: () => _showDayExercises(level),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('⏱ $duration', style: const TextStyle(fontSize: 16)),
            Text('📅 $schedule', style: const TextStyle(fontSize: 16)),
            Text('🏋️ $equipment', style: const TextStyle(fontSize: 16)),
            Text('👤 $userLevel', style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  // 🔹 Bottom Sheet с упражнениями и кнопкой Start
  void _showDayExercises(String level) {
    final exercises = trainings[level]![0]['exercises']!.split('\n'); // Day 1

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$level LEVEL — Day 1',
                style:
                const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ...exercises.map((e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    const Icon(Icons.fitness_center, color: Colors.black54),
                    const SizedBox(width: 10),
                    Expanded(
                        child: Text(e, style: const TextStyle(fontSize: 16))),
                  ],
                ),
              )),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context); // закрываем окно

                  // 🔹 Сохраняем прогресс пользователя в Firebase
                  if (user != null) {
                    final ref =
                    FirebaseDatabase.instance.ref('users/${user!.uid}/progress');
                    await ref.set({
                      'level': level,
                      'currentDay': 1,
                      'startedAt': DateTime.now().toIso8601String(),
                    });
                  }

                  // 🔹 Переходим на экран тренировок
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            TrainingsScreen(level: level, day: 1)),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrangeAccent,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text(
                  'Start',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  // 🔹 TabBar кнопка
  Widget _tabButton({required IconData icon, required String label, required int index}) {
    bool selected = _selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? Colors.pinkAccent.withOpacity(0.5) : Colors.white,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: selected ? Colors.white : Colors.grey),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
