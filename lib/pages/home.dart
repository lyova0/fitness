import 'package:flutter/material.dart';
import '../workouts.dart'; // путь к вашему файлу с классом Workouts
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  final List<String> _titles = ['Home', 'Trainings', 'Profile'];

  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _checkAndCreateUser();
  }

  // 🔹 Создаем аккаунт пользователя в Realtime Database, если его нет
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

                  // 🔹 Контент вкладки Home
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

  // 🔹 Контент Home: боксы с уровнями тренировок
  Widget _homeContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          _trainingBox(
            level: 'LIGHT',
            title: 'LIGHT LEVEL — 30 DAY TRAINING',
            duration: '15–20 мин',
            schedule: '3 дня тренировка / 1 день отдых',
            equipment: 'Без оборудования',
            experience: 'Новички',
          ),
          const SizedBox(height: 16),
          _trainingBox(
            level: 'MIDDLE',
            title: 'MIDDLE LEVEL — 30 DAY TRAINING',
            duration: '20–30 мин',
            schedule: '3 дня тренировка / 1 день отдых',
            equipment: 'Без оборудования',
            experience: 'Средний',
          ),
          const SizedBox(height: 16),
          _trainingBox(
            level: 'HARD',
            title: 'HARD LEVEL — 30 DAY TRAINING',
            duration: '30–40 мин',
            schedule: '3 дня тренировка / 1 день отдых',
            equipment: 'Без оборудования',
            experience: 'Продвинутый',
          ),
        ],
      ),
    );
  }

  // 🔹 Бокс тренировки с кнопкой START
  Widget _trainingBox({
    required String level,
    required String title,
    required String duration,
    required String schedule,
    required String equipment,
    required String experience,
  }) {
    return Container(
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
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('⏱ $duration', style: const TextStyle(fontSize: 16)),
          Text('📅 $schedule', style: const TextStyle(fontSize: 16)),
          Text('🏋️ $equipment', style: const TextStyle(fontSize: 16)),
          Text('👤 $experience', style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              // 🔹 Переход на Workouts с выбранным уровнем
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => Workouts(level: level),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrangeAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('START'),
          ),
        ],
      ),
    );
  }

  // 🔹 Кнопки TabBar
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
